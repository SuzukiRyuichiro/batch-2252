import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "input", "list"];

  connect() {
    console.log("hello from grocery controller!");
  }

  addItem(event) {
    event.preventDefault();

    // get the item name from the input
    const itemName = this.inputTarget.value;
    // display it in the list
    this.listTarget.insertAdjacentHTML(
      "beforeend",
      `<li data-controller="item" class="list-group-item d-flex justify-content-between">
          <span data-item-target="itemName">${itemName}</span>
          <input data-item-target="input" type="text" class="d-none" value="${itemName}" />
          <div class="d-flex gap-1">
            <button class="btn btn-info" data-action="click->item#revealInput" data-item-target="edit">Edit</button>
            <button class="btn d-none btn-success" data-action="click->item#saveItem" data-item-target="save">Save</button>
            <button data-action="click->item#deleteItem" class="btn btn-danger">X</button>
          </div>
        </li>`,
    );

    // Clear the input field aka reset
    this.inputTarget.value = "";
  }
}
