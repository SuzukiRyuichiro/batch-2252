import { Application, Controller } from "@hotwired/stimulus";
import DisableButtonController from "./controllers/disable_button_controller.js";
import MovieSearchController from "./controllers/movie_search_controller.js";

window.Stimulus = Application.start();

Stimulus.register("disable-button", DisableButtonController);
Stimulus.register("movie-search", MovieSearchController);

// const button = document.querySelector("#click-me");

// button.addEventListener("click", () => {
//   button.innerText = "clicked!!";
// });
