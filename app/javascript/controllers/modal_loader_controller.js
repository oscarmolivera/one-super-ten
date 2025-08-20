// app/javascript/controllers/modal_loader_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { url: String, targetFrame: String };

  connect() {
  }

  load() {
    const frameId = (this.targetFrameValue || "").replace("#", "");
    const frame = document.getElementById(frameId);
    if (!frame) {
      console.error(`Frame with ID ${frameId} not found`);
      return;
    }

    // Clear existing frame src to force reload if needed
    if (frame.getAttribute("src") === this.urlValue) {
      frame.removeAttribute("src");
    }

    const onLoad = () => {
      const checkModal = () => {
        const modalEl = frame.querySelector(".modal");
        if (!modalEl) {
          console.warn(`Modal not found in frame ${frameId}, retrying...`);
          return setTimeout(checkModal, 50);
        }

        // Move modal to body
        document.body.appendChild(modalEl);

        // Initialize Bootstrap modal
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl, {
          backdrop: true, // Ensure backdrop is enabled
          keyboard: true, // Allow closing with ESC key
        });

        // Remove any existing modal-open class or styles
        document.body.classList.remove("modal-open");
        document.body.style.overflow = "";
        document.body.style.paddingRight = "";

        // Show the modal
        modal.show();

        // Handle modal show event
        modalEl.addEventListener(
          "show.bs.modal",
          () => {
            modalEl.removeAttribute("inert");
          },
          { once: true }
        );

        // Handle modal hide event
        modalEl.addEventListener(
          "hide.bs.modal",
          () => {
            modalEl.setAttribute("inert", "");
          },
          { once: true }
        );

        // Handle modal hidden event (cleanup)
        modalEl.addEventListener(
          "hidden.bs.modal",
          () => {
            // Dispose of the modal instance
            modal.dispose();

            // Remove modal element from DOM
            modalEl.remove();

            // Clean up frame src
            frame.removeAttribute("src");

            // Ensure body is reset
            document.body.classList.remove("modal-open");
            document.body.style.overflow = "";
            document.body.style.paddingRight = "";

            // Remove any leftover modal backdrops
            const backdrops = document.querySelectorAll(".modal-backdrop");
            backdrops.forEach((backdrop) => backdrop.remove());
          },
          { once: true }
        );

        // Cleanup frame event listener
        frame.removeEventListener("turbo:frame-load", onLoad);
      };

      checkModal();
    };

    // Add event listeners for Turbo frame load and errors
    frame.addEventListener("turbo:frame-load", onLoad, { once: true });
    frame.addEventListener(
      "turbo:fetch-request-error",
      (event) => {
        console.error("Turbo fetch error:", event.detail);
      },
      { once: true }
    );

    // Set frame src to trigger content load
    frame.setAttribute("src", this.urlValue);
  }
}