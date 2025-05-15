import { Dropzone } from "dropzone";
Dropzone.autoDiscover = false;

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

document.addEventListener("turbo:load", () => {
  const dropzoneElement = document.querySelector("#player-files-dropzone");
  if (dropzoneElement && !dropzoneElement.dropzone) {
    const dropzone = new Dropzone(dropzoneElement, {
      url: dropzoneElement.getAttribute("action"),
      headers: {
        "X-CSRF-Token": csrfToken,
      },
      maxFilesize: 5,
      acceptedFiles: "image/jpeg,image/png,application/pdf",
      addRemoveLinks: true,
      autoProcessQueue: true,
      paramName: "document",
      clickable: false,
      uploadMultiple: true, 
      forceFallback: false,
    });

    dropzone.on("success", (file, response) => {
      console.log("Upload successful:", response);
      setTimeout(() => {
        const url = new URL(window.location.href);
        url.hash = "#documents";
        Turbo.visit(url.toString());
      }, 300);
    });

    dropzone.on("error", (file, errorMessage, xhr) => {
      console.error("Upload failed:", errorMessage, xhr);
      alert("Error uploading file: " + (errorMessage.message || errorMessage));
    });

    dropzone.on("sending", (file, xhr, formData) => {
      console.log("Sending file:", file);
      console.log("Form data:", formData);
    });
  }

  // Re-bind modal preview click behavior
  document.querySelectorAll("[data-bs-toggle='modal'][data-doc-url]").forEach(link => {
    link.addEventListener("click", (e) => {
      const previewImage = document.getElementById("doc-preview-image");
      const docUrl = e.currentTarget.getAttribute("data-doc-url");
      if (previewImage) previewImage.src = docUrl;
    });
  });

  const hash = window.location.hash;
  if (hash && document.querySelector(`a[data-bs-toggle="tab"][href="${hash}"]`)) {
    const tabTrigger = new bootstrap.Tab(document.querySelector(`a[href="${hash}"]`));
    tabTrigger.show();
  }

  // Clear preview when modal closes
  const modal = document.getElementById("docModal");
  if (modal) {
    modal.addEventListener("hidden.bs.modal", () => {
      const previewImage = document.getElementById("doc-preview-image");
      if (previewImage) previewImage.src = "";
    });
  }
});

document.addEventListener("dragover", function (e) {
  if (!e.target.closest("#player-files-dropzone")) {
    e.preventDefault();
    e.stopPropagation();
  }
});

document.addEventListener("drop", function (e) {
  if (!e.target.closest("#player-files-dropzone")) {
    e.preventDefault();
    e.stopPropagation();
  }
});