import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { url: String, targetFrame: String };

  connect() {
    document.addEventListener("turbo:stream-render", (event) => {
      console.log("Turbo Stream rendered:", event.detail);
    });
  }

  load() {
    const frameId = (this.targetFrameValue || "").replace("#", "");
    const frame = document.getElementById(frameId);
    if (!frame) {
      console.error(`Frame with ID ${frameId} not found`);
      return;
    }

    if (frame.getAttribute("src") === this.urlValue) frame.removeAttribute("src");

    const onLoad = () => {
      const checkModal = () => {
        const modalEl = frame.querySelector(".modal");
        if (!modalEl) {
          console.warn(`Modal not found in frame ${frameId}, retrying...`);
          return setTimeout(checkModal, 50);
        }
        document.body.appendChild(modalEl);
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();

        modalEl.addEventListener(
          "show.bs.modal",
          () => {
            modalEl.removeAttribute("inert");
          },
          { once: true }
        );

        modalEl.addEventListener(
          "hide.bs.modal",
          () => {
            modalEl.setAttribute("inert", "");
          },
          { once: true }
        );
        modalEl.addEventListener(
          "hidden.bs.modal",
          () => {
            modal.dispose();
            modalEl.remove();
            frame.removeAttribute("src");
          },
          { once: true }
        );

        frame.removeEventListener("turbo:frame-load", onLoad);
      };
      checkModal();
    };

    frame.addEventListener("turbo:frame-load", onLoad, { once: true });
    frame.addEventListener("turbo:fetch-request-error", (event) => {
      console.error("Turbo fetch error:", event.detail);
    }, { once: true });
    frame.setAttribute("src", this.urlValue);
  }
}