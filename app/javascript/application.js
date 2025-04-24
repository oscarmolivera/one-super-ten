// Entry point for the build script in your package.json
import "./vendor/jquery"
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap
import 'jquery-slimscroll'  
import 'jquery-sparkline'
import feather from 'feather-icons'
window.feather = feather
import PerfectScrollbar from 'perfect-scrollbar'
window.PerfectScrollbar = PerfectScrollbar
import "./vendor/template"
import "./vendor/custom"