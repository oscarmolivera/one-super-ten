import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    targetModal: String
  }


  connect() {
   }

  load() {
    const frame = document.getElementById("rival_modal_frame");

    // Set the frame's src attribute (not .src)
    if (!frame.hasAttribute("src")) {
      frame.setAttribute("src", this.urlValue)
    }

    // Reset the frame to force reload
    frame.removeAttribute("src");

    // Set the frame's src attribute again
    frame.setAttribute("src", this.urlValue);


    // When Turbo finishes loading the frame, show the modal
    frame.addEventListener(
      "turbo:frame-load",
      () => {
        const modal = new bootstrap.Modal(
          document.querySelector(this.targetModalValue)
        );
        modal.show();
      },
      { once: true }
    );
  }
}