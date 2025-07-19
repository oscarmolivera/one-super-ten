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
import "./vendor/calender"
import "./vendor/dropzone_config"
import "./vendor/splidejs"
import "trix"
import "@rails/actiontext"
