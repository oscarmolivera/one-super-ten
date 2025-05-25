import { application } from "./application"

import SchoolTogglesController from "./school_toggles_controller.js"
application.register("school-toggles", SchoolTogglesController)

import HandlePreviewController from "./handle_preview_controller.js"
application.register("handle-preview", HandlePreviewController)