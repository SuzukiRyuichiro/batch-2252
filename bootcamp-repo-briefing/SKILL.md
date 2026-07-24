---
name: bootcamp-repo-briefing
description: Checks in on a bootcamp cohort's 5 group-project GitHub repos (listed in repos.md) and produces a short, plain-English briefing covering what each team shipped to master in the last few days, any potential issues worth a mentor's attention, and which branches are active and who's on them. Use this whenever the user wants a status check, progress update, or health check on their bootcamp students' or group projects' repos -- trigger on phrases like "check in on the repos," "what did the teams push," "any issues in the student projects," "who's working on what branch," or a request to review/summarize recent GitHub activity for a cohort or group of teams, even if they don't name this skill directly.
---

# Bootcamp Repo Briefing

A bootcamp instructor or TA can't realistically `git log` through 5 different
student repos every couple of days. This skill does the mechanical part --
cloning each repo and pulling out exactly what changed recently -- so the
model can spend its effort on the part a script can't do: reading the actual
commits and diffs and judging what they mean for that team.

## How it works

1. **Read the repo list.** Read `repos.md` (in this skill's folder) to get
   the 5 `<name>: <GitHub URL>` entries. If the user gave you a different
   path or pasted their own list in the request, use that instead -- `repos.md`
   is just the default when they haven't.

2. **Pull structured facts per repo.** For each repo, run:

   ```
   python3 scripts/analyze_repo.py <repo_url> --since-days 3 --name "<team name>"
   ```

   Adjust `--since-days` if the user asks for a different window (they said
   "past 2-3 days" as the default, but "since Monday" or "the last week" are
   reasonable variations -- just pass the right number). The script clones
   the repo shallowly (only the commit history since that date, no old blobs)
   and prints one JSON object shaped like:

   ```
   {
     "default_branch": "main",           // whatever the repo actually uses
     "master_commits": [ <commit>, ... ],
     "pull_requests": [ <pr_review_info>, ... ],
     "github_api_rate_limited": false,
     "active_branches": [
       {
         "branch": "some-feature-branch",   // note: key is "branch", not "name"
         "authors": ["Ada Lovelace"],
         "commit_count": 3,
         "earliest_commit_date": "...",
         "latest_commit_date": "...",
         "commits": [ <commit>, ... ]
       }
     ],
     "error": "..."   // present instead of the above if the repo couldn't be read
   }
   ```

   where each `<commit>` is:

   ```
   {
     "sha": "...", "author": "...", "date": "...", "subject": "...",
     "files_changed": ["path/to/file.py", ...],
     "insertions": 12, "deletions": 3,
     "is_shallow_boundary": false,
     "diff_text": "commit abc123...\n+    def foo\n...",   // full `git show` patch text, or null
     "diff_skipped_too_large": false   // true if diff_text is null because the commit was too big to capture
   }
   ```

   and each `<pr_review_info>` (recovered from "Merge pull request #N from
   ..." commit subjects on the default branch, via the GitHub API) is:

   ```
   {
     "number": 30,
     "author": "riet6422",         // PR opener's GitHub login
     "merged_by": "riet6422",      // who clicked merge
     "created_at": "...", "merged_at": "...",
     "self_merged": true,          // author == merged_by
     "reviews": [ { "user": "...", "state": "APPROVED" }, ... ],
     "had_approval": false,        // any APPROVED review from someone other than the author
     "error": "HTTP 404"           // present instead of the above if this PR's lookup failed
   }
   ```

   `diff_text` and the PR-review fields are the two things that need a
   specific read, alongside the one below:

   - `diff_text` is the actual code change -- **this, not the commit
     subject, is the primary thing to read.** Commit messages are just a
     label the author chose for themselves; they're frequently vague
     ("update," "fix stuff"), incomplete, or describe something slightly
     different from what the diff actually does. Don't write up "what got
     implemented" from subjects alone -- open `diff_text` and see what code
     was actually added, changed, or removed. It's only populated when the
     commit's total changed lines are within `DIFF_TEXT_LINE_LIMIT` --
     otherwise it's `null` and `diff_skipped_too_large` will be `true`.
   - `pull_requests` can come back empty even for an active repo -- this
     happens when PRs were squash-merged or rebase-merged rather than
     merged with GitHub's "Merge pull request" button (no recoverable PR
     number in that case), or when the repo isn't hosted on github.com at
     all. Don't read an empty list as "no PRs happened"; check
     `github_api_rate_limited` and the commit history before concluding
     that. If `github_api_rate_limited` is `true`, some or all PR
     review/self-merge data for this repo is missing -- say so in the
     briefing rather than silently treating missing data as "nothing to
     report." Setting a `GITHUB_TOKEN` environment variable before running
     the script raises the limit from 60/hour to 5000/hour if this comes up
     repeatedly.

   One more field needs a specific read, not a literal one:
   - `is_shallow_boundary: true` means this is the oldest commit the clone
     reached, so git has no local parent to diff it against -- `files_changed`,
     `insertions`, and `deletions` will be `null` because a diff against
     "nothing" would otherwise make this look like a massive commit dumping
     in the entire repo, when really it just marks where the fetch window
     stops. **Never cite one of these as an "issue" or a real commit size** --
     treat it as a boundary marker, not content.

   If a repo returns an `error` key (private repo, bad URL, repo deleted,
   network hiccup), don't let it block the other four -- note it in the
   briefing and move on.

   Run all 5 in parallel if you can (they're independent), but note that each
   clone hits GitHub over the network, so give it a moment.

3. **Read the actual content, don't just count it.** The script deliberately
   does not tell you what's "good" or "bad" -- that requires judgment a regex
   can't make. Skim the commit subjects, file lists, and diffs it handed you
   and form your own read on each repo:

   - **What got implemented**: base this on `diff_text`, not the commit
     subject. Open the diff and see what code actually changed -- which
     models, controllers, views, routes, or config got added or edited, and
     what the new code does. Commit subjects are a useful label but an
     unreliable source of truth on their own; treat them as a hint about
     where to look, not as the answer. Synthesize into a sentence or two of
     what actually happened -- "added user auth with a login form and JWT
     middleware," not a bullet list of raw commit messages -- and always
     name the specific person (their git author name, matching how they
     appear in `authors`/commit `author` fields) who did it. Avoid vague
     attribution like "the team" or "someone" when the data tells you
     exactly who. If you notice near-duplicate subjects/diffs credited to
     the same person under slightly different name formatting, that's
     usually squash-merge or rebase history rather than genuinely repeated
     work -- don't double-count it as "shipped twice."
   - **Potential issues**: things worth a mentor glancing at, for example --
     a single giant commit with a one-word message dumping in a whole
     feature (hard to review, suggests they aren't committing incrementally),
     commit messages like "fix," "wip," "asdf" with no context that turn out
     (per the diff) to be doing something more substantial than the message
     lets on, no changes to tests when the diff clearly adds new logic, or
     one person authoring every commit while teammates are silent (possible
     sign of an uneven group project). Don't force an issue where there
     isn't one -- plenty of repos will have nothing concerning, and that's a
     fine thing to report.
   - **Branch activity**: for each active branch, say who's on it (the
     `authors` list) and what they seem to be building, based on the branch
     name and its commit subjects. A branch untouched by anyone but with an
     ambitious name from a week ago might just mean nobody's picked it up
     yet -- say so plainly rather than speculating.
   - **Siloed work**: every branch (or master-bound PR) should read as one
     coherent thing -- a feature, a bug fix, or a UI/styling pass. Use
     `files_changed` across the branch's commits to check this: a feature
     branch touching only `app/controllers/foo_controller.rb` with nothing
     in the model, view, route, or test layer is a signal that the person
     dumped in one file without integrating it into the rest of the app (or
     without their teammates knowing it's there). A branch that touches only
     `.scss`/view files is *not* siloed if the branch is clearly a UI pass --
     that's the expected shape for that kind of work. What you're looking
     for is a mismatch between what the branch seems to be trying to do (per
     its name and commit subjects) and how narrow/isolated the actual
     footprint is. Flag genuine mismatches; don't invent one where a
     single-file change is exactly what the task called for.
   - **Self-merges**: check `pull_requests` for `self_merged: true` combined
     with `had_approval: false` -- the PR's author is also the one who
     clicked merge, and nobody else approved it. This isn't automatically a
     problem (student group repos rarely have branch protection turned on),
     but it's worth a mention, especially if `created_at` to `merged_at` is
     only a few minutes -- that's a strong signal no one actually reviewed
     the diff before it landed. If `github_api_rate_limited` is set or
     `pull_requests` is empty, say the self-merge check couldn't run for
     that repo rather than implying everything was properly reviewed.
   - **Possible AI-generated code**: skim `diff_text` on the larger/PR-merge
     commits for signals that don't match the rest of the codebase's level --
     comment blocks that are unusually thorough or formally worded for a
     first-pass student commit; sudden use of Rails/Ruby idioms that go
     beyond what a one-week bootcamp would teach (e.g. `dig`, chained
     `Enumerable` methods, ActiveRecord `.includes`/`.joins` for query
     optimization, custom service objects introduced with no prior lead-up);
     or fully-built-out infrastructure with no clear use yet (e.g. a
     complete mailer/email-template setup when nothing in the app sends
     email). None of these alone is proof -- plenty of students pick up
     idioms from tutorials or a TA -- so frame this as "worth asking the
     student about" rather than an accusation, and only raise it when
     multiple signals stack up together rather than on a single ambiguous
     line.

4. **Write the briefing.** Deliver it directly in the chat response (not a
   saved file, unless the user asks for one this time). Keep it scannable --
   a mentor should be able to read it in under a minute per repo. Each of the
   5 repos gets its own block in this structure:

   ```
   ## <Team name> (<repo URL>)

   Features implemented:

   * <what> by <specific person's name> (branch: <name>, in progress -- omit the branch note if already merged to master)
   * <what> by <specific person's name>

   Fixes:

   * <what> by <specific person's name>

   UI updates:

   * <what> by <specific person's name>

   Some other misc notes:

   * <self-merges, siloed work, possible AI-generated code, stale/duplicate branches,
     rate-limit caveats, or "nothing notable">
   ```

   Sort each piece of work (merged or still on a branch) into whichever of
   Features / Fixes / UI updates it most clearly is, based on what the diff
   actually does (see step 3 -- read `diff_text`, don't just paraphrase the
   commit subject) -- a bug-fix-worded commit with a small, targeted diff
   correcting existing behavior is a Fix; a change touching only
   stylesheets/views is a UI update; anything adding new models,
   controllers, routes, or functionality is a Feature. **Always name the
   specific person** who did the work -- pull the name straight from the
   commit `author` field (or `authors` for a branch) rather than writing
   "the team" or leaving it unattributed. If a section has nothing for a
   given repo, write "None this window" rather than omitting the header.
   Work still in progress on a branch (not yet merged) still gets listed
   under the relevant section -- just note which branch it's on, so the
   "who's working on what" signal isn't lost now that there's no separate
   branches section. Put self-merge flags, siloed-work flags,
   possible-AI-code flags, and any other observations (stale duplicate
   branches, GitHub API rate-limit caveats) in the misc section -- that's the
   one section that's about the *process*, not the *work product*.

   After all 5, add a short **overall** wrap-up: which teams are moving fast,
   which look quiet or stuck, and anything that needs the instructor's
   attention across the whole cohort -- including patterns that show up in
   more than one repo (e.g. several self-merges cohort-wide might mean the
   group project norms need re-explaining, rather than being one team's
   issue). This last part is the actual point of the exercise -- the
   per-repo detail exists to support this bird's-eye read, so don't skip it
   even if the per-repo sections ran long.

## Notes

- All 5 repos are assumed public (no auth needed to clone). If one turns out
  to be private and the clone fails with an auth error, tell the user rather
  than silently skipping it.
- PR review/self-merge data comes from the GitHub REST API, which is
  unauthenticated and capped at 60 requests/hour by default -- fine for an
  occasional check-in, but 5 active repos can exhaust it if run back-to-back
  or multiple times a day. If the user hits `github_api_rate_limited`
  regularly, mention that setting a `GITHUB_TOKEN` environment variable
  (any personal access token works, no special scopes needed for public
  repos) before running raises the limit to 5000/hour.
- The shallow clone only fetches history since the requested window, so this
  stays fast even against large repos -- no need to worry about repo size.
- "Branch created recently" is approximated as "has commits not yet on the
  default branch, within the window." A branch could technically be older
  than that if it went quiet and was just revived -- worth a caveat in the
  briefing if the commit history suggests that, but not worth over-engineering
  the detection for.
