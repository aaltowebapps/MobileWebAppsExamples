/*
 * Self executing function to hide functions from the global scope
 */
(function($){
	$(document).bind("mobileinit", function(){
		// Apply overrides here
		// See http://jquerymobile.com/demos/1.1.0-rc.1/docs/api/globalconfig.html
	});
	
	$(function() {
		// Document is ready
	});
})(jQuery);