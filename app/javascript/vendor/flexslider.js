import 'flexslider/flexslider.css'
import 'flexslider/jquery.flexslider'

// este paso asegura que esté disponible como plugin
if (typeof $.fn.flexslider === 'undefined') {
  console.warn('FlexSlider is not attaching to jQuery properly');
} else {
  console.log('FlexSlider registered correctly');
}