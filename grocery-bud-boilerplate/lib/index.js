import { Application, Controller } from "@hotwired/stimulus";
import GroceryController from "./controllers/grocery_controller.js";
import ItemController from "./controllers/item_controller.js";
window.Stimulus = Application.start();

// register all my controllers

Stimulus.register("grocery", GroceryController);
Stimulus.register("item", ItemController);
