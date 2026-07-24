#!/usr/bin/env python3
"""
Clone a public GitHub repo (shallow, blobless) and extract structured, factual
data about recent activity: what landed on the default branch in the last N
days, and what's happening on branches that had commits in that same window
(including who authored them).

This script only extracts and structures raw facts -- it does NOT decide what
counts as a "potential issue" or write any prose. That judgment call is left
to the model reading this output, because it requires actually reading commit
messages and diffs in context (a bootcamp group's first PR looks different
from a solo late-night force-push, and a script can't tell the difference
reliably -- a model reading the real content can).

Usage:
    python3 analyze_repo.py <repo_url> [--since-days 3] [--name "Team Alpha"]

Prints one JSON object to stdout. On any failure (private repo, bad URL, repo
has been deleted, etc.) prints a JSON object with an "error" key instead of
raising, so a caller processing multiple repos in a loop can continue past
one bad entry.

Two additional things this script pulls, beyond commit metadata:

1. Full diff text for each enriched commit (master and branch). This is the
   primary signal for judging what actually happened in a commit -- commit
   messages are just a label the author chose and are often vague,
   incomplete, or flat wrong about what the diff actually does. Capped at
   DIFF_TEXT_LINE_LIMIT changed lines per commit for runtime's sake (a
   multi-thousand-line diff is a vendored dependency or a lockfile, not
   something worth reading line-by-line anyway).

2. Pull request review/merge metadata via the GitHub REST API, for every PR
   number we can recover from a "Merge pull request #N from ..." commit
   subject on the default branch. This is the only reliable way to know who
   *reviewed* a PR and who actually clicked merge -- git history alone only
   shows the merge commit's author, which is often the same person
   regardless of who wrote the code. Unauthenticated requests are limited to
   60/hour by GitHub; set a GITHUB_TOKEN environment variable (any personal
   access token, no special scopes needed for public repos) to raise that to
   5000/hour if you're checking several repos back-to-back. On rate-limit or
   any other API failure, the affected PR (or all of them) gets an "error"
   key instead of crashing the whole script -- the rest of the report still
   goes out.
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request
from datetime import datetime, timedelta, timezone

GITHUB_API_BASE = "https://api.github.com"

PR_MERGE_SUBJECT_RE = re.compile(r"Merge pull request #(\d+) from")

# Bound how many PRs we look up per repo -- a very active repo could have
# dozens of merges in the window, and each PR costs 2 API calls (PR details +
# reviews). This keeps a single repo from burning the whole rate-limit budget
# for the other four.
MAX_PRS_PER_REPO = 20


def parse_owner_repo(repo_url):
    """Extract (owner, repo) from a GitHub URL, with or without a trailing
    .git or slash. Returns (None, None) if it doesn't look like a GitHub
    URL (e.g. a self-hosted git server) -- callers should treat that as
    "PR/review data unavailable" rather than an error."""
    m = re.search(r"github\.com[:/]+([^/]+)/([^/.]+?)(?:\.git)?/?$", repo_url)
    if not m:
        return None, None
    return m.group(1), m.group(2)


def github_api_get(path, token=None):
    """GET a GitHub REST API path and return parsed JSON. Raises
    urllib.error.HTTPError on failure (404 deleted PR, 403 rate limit,
    etc.) -- callers catch this and degrade gracefully per-PR rather than
    letting one bad lookup take down the whole repo's report."""
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "bootcamp-repo-briefing-script",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(f"{GITHUB_API_BASE}{path}", headers=headers)
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.loads(resp.read().decode("utf-8"))


def extract_pr_numbers(commits):
    """Pull distinct PR numbers out of 'Merge pull request #N from ...'
    commit subjects on the default branch, in the order first seen. This is
    the only reliable PR-number signal available from git alone -- squash
    or rebase merges don't leave this pattern and simply won't have PR
    metadata available (there's no way to recover the PR number from git
    history in that case)."""
    numbers = []
    seen = set()
    for c in commits:
        m = PR_MERGE_SUBJECT_RE.search(c["subject"])
        if m:
            n = int(m.group(1))
            if n not in seen:
                seen.add(n)
                numbers.append(n)
    return numbers


def fetch_pr_review_info(owner, repo, pr_number, token=None):
    """Return the raw facts needed to judge whether a PR was self-merged
    without review: who authored it, who clicked merge, and whether anyone
    other than the author left an APPROVED review. Never raises -- any API
    failure is captured in an 'error' key so one bad lookup doesn't take
    down the rest of the repo's PR list."""
    info = {"number": pr_number}
    try:
        pr = github_api_get(f"/repos/{owner}/{repo}/pulls/{pr_number}", token)
    except urllib.error.HTTPError as e:
        info["error"] = f"HTTP {e.code}"
        if e.code == 403:
            info["rate_limited"] = True
        return info
    except Exception as e:
        info["error"] = str(e)
        return info

    author = (pr.get("user") or {}).get("login")
    merged_by = (pr.get("merged_by") or {}).get("login")
    info.update(
        {
            "author": author,
            "merged_by": merged_by,
            "created_at": pr.get("created_at"),
            "merged_at": pr.get("merged_at"),
            # True when the same account both opened and merged the PR --
            # not automatically a problem (small teams often don't set up
            # branch protection), but combined with had_approval=False it's
            # worth a mentor's glance.
            "self_merged": bool(author) and author == merged_by,
        }
    )
    try:
        reviews = github_api_get(
            f"/repos/{owner}/{repo}/pulls/{pr_number}/reviews", token
        )
        info["reviews"] = [
            {
                "user": (r.get("user") or {}).get("login"),
                "state": r.get("state"),
            }
            for r in reviews
        ]
        info["had_approval"] = any(
            r["state"] == "APPROVED" and r["user"] != author
            for r in info["reviews"]
        )
    except urllib.error.HTTPError as e:
        info["reviews"] = None
        info["had_approval"] = None
        info["reviews_error"] = f"HTTP {e.code}"
        if e.code == 403:
            info["rate_limited"] = True
    except Exception as e:
        info["reviews"] = None
        info["had_approval"] = None
        info["reviews_error"] = str(e)
    return info


def run(cmd, cwd=None, check=True, timeout=120):
    result = subprocess.run(
        cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout
    )
    if check and result.returncode != 0:
        raise RuntimeError(
            f"Command failed ({result.returncode}): {' '.join(cmd)}\n{result.stderr}"
        )
    return result.stdout


def get_default_branch(repo_url):
    out = run(["git", "ls-remote", "--symref", repo_url, "HEAD"])
    for line in out.splitlines():
        if line.startswith("ref:"):
            # e.g. "ref: refs/heads/main\tHEAD"
            ref = line.split()[1]
            return ref.replace("refs/heads/", "")
    raise RuntimeError("Could not determine default branch from ls-remote output")


def clone_repo(repo_url, dest, since_date):
    """Clone without downloading file contents (--filter=blob:none) and with
    every branch present (--no-single-branch), so we can inspect commit
    history and branch activity without paying for a full checkout.

    We'd prefer to also pass --shallow-since so we only fetch history back to
    the window we care about, but some GitHub-hosted repos reproducibly
    reject that combination with "fatal: error processing shallow info" (a
    server-side quirk, not something wrong with the repo or our request --
    it reliably reproduces on the same repo every time, and reliably works
    without --shallow-since). Try the fast path first; fall back to a full
    partial clone if the server rejects it. Either way blobs are still
    deferred, so this stays cheap even without the shallow cutoff.
    """
    try:
        run(
            [
                "git",
                "clone",
                "--filter=blob:none",
                "--no-single-branch",
                f"--shallow-since={since_date}",
                repo_url,
                dest,
            ],
            timeout=180,
        )
    except RuntimeError:
        shutil.rmtree(dest, ignore_errors=True)
        run(
            ["git", "clone", "--filter=blob:none", "--no-single-branch", repo_url, dest],
            timeout=180,
        )


def get_shallow_boundary_shas(dest):
    """SHAs of commits at the edge of a shallow clone -- git has no parent
    for these locally, so diffing them against their (unfetched) parent
    would show the ENTIRE file tree as newly added. That's not a real giant
    commit, it's just where our fetch window stops, and without flagging it
    a reader (human or model) would mistake it for a suspiciously large
    dump. Only present when the --shallow-since clone path succeeded; the
    full-clone fallback has no such boundary."""
    shallow_file = f"{dest}/.git/shallow"
    try:
        with open(shallow_file) as f:
            return {line.strip() for line in f if line.strip()}
    except FileNotFoundError:
        return set()


def list_remote_branches_with_tip_dates(dest):
    """Return {branch_short_name: tip_commit_iso_date} for every remote branch,
    in a single git call. A repo can have anywhere from 2 to 1000+ branches
    (bot branches, stale contributor forks-that-never-got-cleaned-up, etc.),
    and shelling out to `git log` once per branch to check its tip date does
    not scale -- for-each-ref gets everything in one process."""
    out = run(
        [
            "git",
            "for-each-ref",
            "--format=%(refname:short)|%(committerdate:iso-strict)",
            "refs/remotes/origin",
        ],
        cwd=dest,
    )
    tips = {}
    for line in out.splitlines():
        if "|" not in line:
            continue
        name, date = line.split("|", 1)
        name = name.strip()
        if name.endswith("HEAD") or not name:
            continue
        tips[name] = date.strip()
    return tips


def commit_list(dest, rev_range):
    """Return list of {sha, author, date, subject} for a git log rev range/args."""
    fmt = "%H%x01%an%x01%ad%x01%s"
    out = run(
        ["git", "log", "--date=iso-strict", f"--format={fmt}"] + rev_range,
        cwd=dest,
        check=False,
    )
    commits = []
    for line in out.splitlines():
        if not line.strip():
            continue
        parts = line.split("\x01")
        if len(parts) != 4:
            continue
        sha, author, date, subject = parts
        commits.append(
            {"sha": sha, "author": author, "date": date, "subject": subject}
        )
    return commits


# Above this many changed lines, skip pulling the full diff text. A
# student project's real commits are small; a commit this size is usually a
# vendored dependency, a lockfile, or a generated-file dump -- not something
# worth reading line-by-line, and it's exactly the kind of moment where this
# script's runtime needs to stay bounded regardless of what a particular
# commit happens to contain.
DIFF_TEXT_LINE_LIMIT = 2000


def commit_stat(dest, sha, shallow_boundary_shas):
    """Return (files_changed, insertions, deletions, diff_captured,
    is_shallow_boundary, diff_text)."""
    if sha in shallow_boundary_shas:
        # Diffing this against its (unfetched) parent would show every file
        # in the repo as newly added -- skip it rather than report numbers
        # that look like a massive commit but actually just reflect where
        # our fetch window ends.
        return None, None, None, False, True, None

    stat_out = run(
        ["git", "show", "--stat", "--format=", sha], cwd=dest, check=False
    )
    files = []
    insertions = 0
    deletions = 0
    for line in stat_out.splitlines():
        line = line.strip()
        if "|" in line:
            fname = line.split("|")[0].strip()
            if fname:
                files.append(fname)
        m = re.search(r"(\d+) insertion", line)
        if m:
            insertions = int(m.group(1))
        m = re.search(r"(\d+) deletion", line)
        if m:
            deletions = int(m.group(1))

    diff_text = None
    captured = insertions + deletions <= DIFF_TEXT_LINE_LIMIT
    if captured:
        try:
            # This is the actual code change -- the thing to read to know
            # what was added/updated, as opposed to the commit subject,
            # which is just whatever label the author chose.
            diff_text = run(["git", "show", sha], cwd=dest, check=False, timeout=60)
        except Exception:
            diff_text = None
            captured = False

    return files, insertions, deletions, captured, False, diff_text


def enrich_commits(dest, commits, shallow_boundary_shas, max_full_stats=40):
    """Attach file/insertion/deletion/diff info to each commit, capped so a
    repo with hundreds of commits in the window doesn't blow up runtime."""
    for c in commits[:max_full_stats]:
        files, ins, dele, captured, is_boundary, diff_text = commit_stat(
            dest, c["sha"], shallow_boundary_shas
        )
        c["files_changed"] = files
        c["insertions"] = ins
        c["deletions"] = dele
        c["is_shallow_boundary"] = is_boundary
        c["diff_text"] = diff_text
        c["diff_skipped_too_large"] = not captured and not is_boundary
    for c in commits[max_full_stats:]:
        c["files_changed"] = None
        c["insertions"] = None
        c["deletions"] = None
        c["is_shallow_boundary"] = c["sha"] in shallow_boundary_shas
        c["diff_text"] = None
        c["diff_skipped_too_large"] = None
    return commits


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("repo_url")
    parser.add_argument("--since-days", type=int, default=3)
    parser.add_argument("--name", default=None, help="Human label, e.g. team name")
    args = parser.parse_args()

    since_dt = datetime.now(timezone.utc) - timedelta(days=args.since_days)
    since_date = since_dt.strftime("%Y-%m-%d")

    result = {
        "repo_url": args.repo_url,
        "label": args.name or args.repo_url,
        "since_days": args.since_days,
        "since_date": since_date,
    }

    tmpdir = tempfile.mkdtemp(prefix="repo_watch_")
    try:
        default_branch = get_default_branch(args.repo_url)
        result["default_branch"] = default_branch

        clone_repo(args.repo_url, tmpdir, since_date)
        shallow_boundary_shas = get_shallow_boundary_shas(tmpdir)

        default_ref = f"origin/{default_branch}"
        master_commits = commit_list(tmpdir, [default_ref, f"--since={since_date}"])
        master_commits = enrich_commits(tmpdir, master_commits, shallow_boundary_shas)
        result["master_commits"] = master_commits

        # PR review/merge metadata (self-merge detection). Best-effort: a
        # non-GitHub remote, or a fully rate-limited API, just means this
        # section comes back empty/flagged rather than failing the repo.
        owner, repo_name = parse_owner_repo(args.repo_url)
        pull_requests = []
        rate_limited = False
        if owner and repo_name:
            token = os.environ.get("GITHUB_TOKEN")
            for n in extract_pr_numbers(master_commits)[:MAX_PRS_PER_REPO]:
                pr_info = fetch_pr_review_info(owner, repo_name, n, token)
                pull_requests.append(pr_info)
                if pr_info.get("rate_limited"):
                    rate_limited = True
                    break  # no point burning remaining calls once limited
        result["pull_requests"] = pull_requests
        result["github_api_rate_limited"] = rate_limited

        branches_out = []
        branch_tips = list_remote_branches_with_tip_dates(tmpdir)
        for branch, tip_date in branch_tips.items():
            short_name = branch.replace("origin/", "")
            if short_name == default_branch:
                continue

            # Cheap bail-out before the more expensive diff below: if the
            # branch's tip commit predates our window, nothing on it is
            # recent (a repo can accumulate a lot of stale contributor/bot
            # branches, and running a full diff against each one adds up).
            if tip_date:
                try:
                    if datetime.fromisoformat(tip_date) < since_dt:
                        continue
                except ValueError:
                    pass  # if we can't parse it, fall through and check properly

            # Commits reachable from this branch but not from the default
            # branch, AND within the window -- without the --since filter here,
            # a long-abandoned branch that diverged years ago would dump its
            # entire divergent history (it's all "not on default"), drowning
            # out branches that are actually active right now. This is our
            # proxy for "recent activity unique to this branch," and the
            # earliest such commit's date is our proxy for when work on the
            # branch began (not necessarily true branch-creation time, but
            # close enough for a status briefing).
            unique = commit_list(
                tmpdir, [f"{default_ref}..{branch}", f"--since={since_date}"]
            )
            if not unique:
                continue
            unique = enrich_commits(tmpdir, unique, shallow_boundary_shas)
            authors = sorted(set(c["author"] for c in unique))
            dates = sorted(c["date"] for c in unique)
            branches_out.append(
                {
                    "branch": short_name,
                    "authors": authors,
                    "commit_count": len(unique),
                    "earliest_commit_date": dates[0],
                    "latest_commit_date": dates[-1],
                    "commits": unique,
                }
            )
        result["active_branches"] = branches_out

    except Exception as e:
        result["error"] = str(e)
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)

    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
