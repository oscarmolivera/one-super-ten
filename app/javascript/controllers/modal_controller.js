import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  static values = { selector: String }

  connect() {
    window.addEventListener("modal:close", () => this.close())
  }

  close(event) {
    const modalEl = document.querySelector(this.selectorValue);
    bootstrap.Modal.getInstance(modalEl)?.hide();
  }
}