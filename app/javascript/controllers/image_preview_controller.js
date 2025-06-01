import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "filename"]

  previewImage() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove("d-none")
      this.previewTarget.classList.add("img-fluid", "rounded", "shadow-sm", "border")
      this.previewTarget.style.maxHeight = "200px"
      this.previewTarget.style.objectFit = "contain"

      // Update file name
      this.filenameTarget.textContent = `Archivo seleccionado: ${file.name}`
      this.filenameTarget.classList.remove("d-none")
    }
    reader.readAsDataURL(file)
  }
}