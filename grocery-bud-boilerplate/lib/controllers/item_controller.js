import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["itemName", "input", "save", "edit"];

  connect() {
    console.log("hello from item!");
  }

  deleteItem() {
    // remove() the element (li)
    this.element.remove();
  }

  revealInput() {
    // remove d-none from input
    this.inputTarget.classList.remove("d-none");
    // hide the span
    this.itemNameTarget.classList.add("d-none");

    // Hide the edit button
    this.editTarget.classList.add("d-none");
    // Reveal the save button
    this.saveTarget.classList.remove("d-none");
  }

  saveItem() {
    // Get the current value of the input
    const updatedItem = this.inputTarget.value;
    // Replace the span's inner text with that
    this.itemNameTarget.innerText = updatedItem;
    // hide the save button
    this.saveTarget.classList.add("d-none");
    // reveal the edit button again
    this.editTarget.classList.remove("d-none");

    // Hide the input field
    this.inputTarget.classList.add("d-none");
    // Reveal the span back
    this.itemNameTarget.classList.remove("d-none");
  }
}
