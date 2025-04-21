import * as bootstrap from 'bootstrap'
window.bootstrap = bootstrap

import * as Popper from '@popperjs/core'
window.Popper = Popper
import "animate.css/animate.css";

//Aniimate.css - AOS
import  AOS  from "aos";
import "aos/dist/aos.css";

//---------------------------------------------------------------------
// jQuery Slimscroll & Sparkline
import 'jquery-slimscroll';
import 'jquery-sparkline';

// Icon styles
import 'weathericons/css/weather-icons.css'
import 'weathericons/css/weather-icons-wind.css' // for wind direction icons

//
import './pace/pace.min.css';
import './pace/pace.min.js';

// Bootstrap Timepicker
import './bootstrap-timepicker/bootstrap-timepicker.css';
import * as timepicker from './bootstrap-timepicker/bootstrap-timepicker.js';
window.timeInput = timepicker;


import './bootstrap-wysihtml5/wysihtml5.js'
import * as wysihtml5 from './bootstrap-wysihtml5/bootstrap-wysihtml5.js'
import './bootstrap-wysihtml5/bootstrap-wysihtml5.css'

// Icheck
import './icheck/icheck.min.js';
import './icheck/flat/blue.css';

// Bootstrap Slider
import 'bootstrap-slider/dist/css/bootstrap-slider.min.css';
import 'bootstrap-slider';

// Chartist.js
import 'chartist/dist/index.css'
import * as ChartistModule from 'chartist/dist/index.js'

//C3 chart
import 'c3/c3.min.css';
import * as d3 from 'd3';
import c3 from 'c3';
window.d3 = d3;
window.c3 = c3;

// Bootstrap Switch
import 'bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.min.css';
import { bootstrapSwitch } from 'bootstrap-switch';

// Sortable
import { Sortable } from 'sortablejs';

// jQuery Toast
import './jquery-toast/jquery.toast.min.css';
import * as  toast from './jquery-toast/jquery.toast.min.js'

// Gridstack
import 'gridstack/dist/gridstack.min.css';
import { GridStack } from 'gridstack';

//ion-rangeslider
import 'ion-rangeslider/css/ion.rangeSlider.min.css';
import 'ion-rangeslider';

// Raty manually imported
import './raty/raty.css';
import Raty from './raty/raty';

// Bootstrap Touchspin
import 'bootstrap-touchspin/dist/jquery.bootstrap-touchspin.min.css'
import 'bootstrap-touchspin/dist/jquery.bootstrap-touchspin.min.js'

// Bootstrap Tagsinput
import 'bootstrap-tagsinput/dist/bootstrap-tagsinput.css'
import 'bootstrap-tagsinput/dist/bootstrap-tagsinput.min.js'

// Bootstrap Select
import 'bootstrap-select/dist/css/bootstrap-select.min.css'
import 'bootstrap-select/dist/js/bootstrap-select.min.js'

// Bootstrap-colorpicker
import '@claviska/jquery-minicolors/jquery.minicolors.css'
import '@claviska/jquery-minicolors'

// Bootstrap DateRangePicker
import moment from 'moment'
import 'bootstrap-daterangepicker/daterangepicker.css'
import 'bootstrap-daterangepicker'

// Daterangepicker
import 'daterangepicker/daterangepicker.css'
import 'daterangepicker'

// Select2
import './select2';

// Dropzone
import './dropzone';

//Bootstrap Markdown
// import '../vendor/bootstrap3-editable/bootstrap-markdown.min.css'
// import '../vendor/bootstrap3-editable/bootstrap-markdown.js'

// SweetAlert
import swal from 'sweetalert'

// Bootstrap3 Editable'
// import '../vendor/bootstrap3-editable/bootstrap-editable.css'
// import '../vendor/bootstrap3-editable/bootstrap-editable.min.js'

// Ekko Lightbox
import './ekko-lightbox';

// Perfect Scrollbar
import PerfectScrollbar from 'perfect-scrollbar';
import 'perfect-scrollbar/css/perfect-scrollbar.css';
window.PerfectScrollbar = PerfectScrollbar;

// Morris.js
import './morris-global';

// Owl Carousel
import './owl-caroussel';

// FlexSlider
import './flexslider';

// Prism.js
import './prism';

// dataTables
import './dataTables'

// Magnific Popup
import './magnific-popup'

// Masonry
import './masonry-layout';
// Feather Icons
import feather from 'feather-icons'
window.feather = feather

// FontAwesome
import '@fortawesome/fontawesome-free/js/all.js';