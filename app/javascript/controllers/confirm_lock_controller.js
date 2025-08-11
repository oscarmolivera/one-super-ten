// app/javascript/controllers/confirm_lock_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  static values = {
    confirmed: { type: Boolean, default: false },
    modalId: String, // e.g., "lockConfirmModal_123"
  }

  connect() {
    // Clean up any orphaned backdrops if this frame was reloaded
    this.cleanupModalArtifacts()

    // Also clean up before Turbo renders a new page/fragment
    this._beforeRender = () => this.cleanupModalArtifacts()
    document.addEventListener("turbo:before-render", this._beforeRender)
  }

  disconnect() {
    document.removeEventListener("turbo:before-render", this._beforeRender)
  }

  // 1) Intercept the first submit and show the confirm modal
  intercept(event) {
    if (this.confirmedValue) return // already confirmed once
    event.preventDefault()
    this.showModal()
  }

  // 2) User confirms in the modal: hide modal first, then submit
  confirmAndSubmit() {
    const modalEl = this._modalElement()
    this.confirmedValue = true

    if (window.bootstrap?.Modal && modalEl) {
      const instance = bootstrap.Modal.getOrCreateInstance(modalEl)

      const onHidden = () => {
        modalEl.removeEventListener("hidden.bs.modal", onHidden)
        this.cleanupModalArtifacts()
        this.element.requestSubmit()
      }

      modalEl.addEventListener("hidden.bs.modal", onHidden)
      instance.hide()
    } else {
      // Fallback if Bootstrap JS isn’t present
      this.hideFallback()
      this.cleanupModalArtifacts()
      this.element.requestSubmit()
    }
  }

  // 3) Your requested improvement: close any open modal AFTER a successful submit
  // Hook with: data-action="turbo:submit-end->confirm-lock#onSubmitEnd"
  onSubmitEnd(event) {
    if (!event.detail?.success) return

    const modalEl = this._modalElement()
    if (!modalEl) return

    const instance = window.bootstrap?.Modal?.getInstance(modalEl)
      || (window.bootstrap?.Modal && bootstrap.Modal.getOrCreateInstance(modalEl))

    if (instance) instance.hide()
    this.cleanupModalArtifacts()
  }

  showModal() {
    const modalEl = this._modalElement()
    if (!modalEl) return
    if (window.bootstrap?.Modal) {
      bootstrap.Modal.getOrCreateInstance(modalEl).show()
    } else {
      // minimal fallback
      modalEl.classList.add("show")
      modalEl.style.display = "block"
      modalEl.removeAttribute("aria-hidden")
      document.body.classList.add("modal-open")
    }
  }

  hideFallback() {
    const modalEl = this._modalElement()
    if (!modalEl) return
    modalEl.classList.remove("show")
    modalEl.style.display = "none"
    modalEl.setAttribute("aria-hidden", "true")
  }

  cleanupModalArtifacts() {
    // Remove stray backdrops and body classes left by interrupted transitions
    document.querySelectorAll(".modal-backdrop").forEach(el => el.remove())
    document.body.classList.remove("modal-open")
    document.body.style.removeProperty("padding-right")
  }

  _modalElement() {
    // Prefer explicit modalIdValue (works even if the modal isn’t a Stimulus target)
    if (this.hasModalIdValue) return document.getElementById(this.modalIdValue)
    // Fallback to a target defined as data-confirm-lock-target="modal"
    if (this.hasModalTarget) return this.modalTarget
    return null
  }
}