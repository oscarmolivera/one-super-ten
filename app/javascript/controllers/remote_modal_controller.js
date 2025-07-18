import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="remote-modal"
export default class extends Controller {
  static values = {
    modalId: String
  };

  onSubmitEnd(event) {
    if (event.detail.success) {
      const modalElement = document.getElementById(this.modalIdValue);
      if (modalElement) {
        const modalInstance = bootstrap.Modal.getInstance(modalElement);
        if (modalInstance) {
          modalInstance.hide();
        }
      }
    }
  }
}