// TODO: Fetch an activity with the Bored API - Let's pseudocode!
const url = "https://bored.api.lewagon.com/api/activity/";

// select the button element
const button = document.querySelector("button");
// add event listener to the button
button.addEventListener("click", async (event) => {
  // when clicked, make a HTTP GET request to the bored API
  const response = await fetch(url);
  // parse the response JSON
  const data = await response.json();

  // Extract the info we need from the parsed JSON
  const activity = data.activity;
  // put the inspirational activity we got back into the H2 tag under the button
  const quote = document.getElementById("activity");
  quote.textContent = activity;
});
