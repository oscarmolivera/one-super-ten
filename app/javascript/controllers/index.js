import { application } from "./application"

// Manual list of controllers to register
import HelloController from "./hello_controller.js"

application.register("hello", HelloController)