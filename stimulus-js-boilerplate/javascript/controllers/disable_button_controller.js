import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "resetLink"];
  static values = {
    text: String,
    originalText: String,
  };

  connect() {
    console.log("connected!");
  }

  disable() {
    // disable the button that was clicked
    // event.currentTarget.setAttribute("disabled", "true");
    // event.currentTarget.disabled = true;
    // How to access element that the controller is mounted on -> this.element
    // this.element.disabled = true;
    // this.element.innerText = "Bingo!!";

    // Access the targets button using this.
    this.buttonTarget.disabled = true;
    this.buttonTarget.innerText = this.textValue;

    // Remove the class d-non from the reset link
    this.resetLinkTarget.classList.remove("d-none");
  }

  reset() {
    // enable the button back
    this.buttonTarget.disabled = false;

    this.buttonTarget.innerText = this.originalTextValue;

    // add d-none class back to the reset link
    this.resetLinkTarget.classList.add("d-none");
  }
}
