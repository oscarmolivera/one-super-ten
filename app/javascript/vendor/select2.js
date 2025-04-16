import 'select2/dist/css/select2.min.css'
import $ from 'jquery'
import select2 from 'select2/dist/js/select2.full' // full bundle is required

// Make sure jQuery is global
window.$ = $
window.jQuery = $

// ✅ Register Select2 with jQuery
$.fn.select2 = select2

console.log("✅ Select2 loaded:", typeof $.fn.select2)