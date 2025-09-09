// app/javascript/controllers/modal_escape_controller.js
import { Controller } from "@hotwired/stimulus"

// Attach on the modal root: <div class="modal" data-controller="modal-escape">
export default class extends Controller {
  connect() {
    // Ensure the modal escapes stacking contexts
    this.ensureInBody()

    // Remember the element that opened the modal so we can restore focus later
    this._onShow = (e) => {
      this.ensureInBody()
      // Bootstrap sets e.relatedTarget as the trigger when using data-bs-toggle
      this.returnFocusTo = e.relatedTarget || document.activeElement
    }
    this.element.addEventListener("show.bs.modal", this._onShow)

    // When the modal is fully hidden, restore focus somewhere sensible
    this._onHidden = () => {
      // If focus is still inside the modal, blur it
      if (this.element.contains(document.activeElement)) {
        document.activeElement.blur()
      }
      // Try to restore to the trigger if it still exists and is visible
      if (this.returnFocusTo && document.contains(this.returnFocusTo)) {
        try { this.returnFocusTo.focus({ preventScroll: true }) } catch { }
      } else {
        // Fallbacks: active tab link, otherwise body
        const activeTab = document.querySelector('.nav-pills .nav-link.active')
          ; (activeTab || document.body).focus?.()
      }

      // Safety: remove any stray backdrops/classes
      this.cleanupArtifacts()
    }
    this.element.addEventListener("hidden.bs.modal", this._onHidden)

    // ✅ Close the modal after a successful Turbo form submit inside this modal
    this._onSubmitEnd = (e) => {
      // Only react to forms inside this modal
      if (!this.element.contains(e.target)) return

      if (e.detail && e.detail.success) {
        // Defer a tick so Turbo streams can finish replacing DOM
        queueMicrotask(() => {
          const modal = bootstrap.Modal.getOrCreateInstance(this.element)
          modal.hide()
        })
      }
    }
    // Listen on capture to catch the event even if inner frames re-render
    this.element.addEventListener("turbo:submit-end", this._onSubmitEnd, true)

    // Auto-repair: if modal is hidden but still display:block with aria-hidden="true"
    this.fixAriaDisplayMismatch()
  }

  disconnect() {
    this.element.removeEventListener("show.bs.modal", this._onShow)
    this.element.removeEventListener("hidden.bs.modal", this._onHidden)
    this.element.removeEventListener("turbo:submit-end", this._onSubmitEnd, true)
  }

  ensureInBody() {
    if (this.element.parentNode !== document.body) {
      document.body.appendChild(this.element)
    }
  }

  cleanupArtifacts() {
    document.querySelectorAll(".modal-backdrop").forEach(el => el.remove())
    document.body.classList.remove("modal-open")
    document.body.style.removeProperty("padding-right")
  }

  fixAriaDisplayMismatch() {
    const hidden = this.element.getAttribute("aria-hidden") === "true"
    const shown = this.element.classList.contains("show") || this.element.style.display === "block"
    if (hidden && shown) {
      // Normalize to fully hidden state
      this.element.classList.remove("show")
      this.element.style.display = "none"
      this.cleanupArtifacts()
    }
  }
}