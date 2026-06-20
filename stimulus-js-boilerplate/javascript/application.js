import { Application, Controller } from "@hotwired/stimulus";
import DisableButtonController from "./controllers/disable_button_controller.js";

window.Stimulus = Application.start();

Stimulus.register("disable-button", DisableButtonController);

// const button = document.querySelector("#click-me");

// button.addEventListener("click", () => {
//   button.innerText = "clicked!!";
// });
