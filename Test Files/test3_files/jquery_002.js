(function($) {

	$.fn.tristate = function(options){

		var tristate = this;
		var settings = jQuery.extend({
				states:		["tristate-null","tristate-on","tristate-off"]
		},options||{});

		return this.each(function() {

			var label = $(this);
			var oldcheck = label.find(":checkbox");
			var status = parseInt(oldcheck.attr('rel')) || 0;
			var identifier = oldcheck.attr("name");
			
			// need to do this in reverse order since we're using prepend instead of append
			for (var index = settings.states.length; index >= 0 ; index--) {
				$('<input type="radio">')
				.attr('name', identifier).attr('value', index).prependTo(label).hide();
			}
			
			label.find(":radio").eq(status).attr("checked", true);			
			oldcheck.remove();
			label.addClass(settings.states[status]);
			label.hover(function(){
				$(this).css("cursor", "pointer").addClass("tristate-hover");
			},function(){
				$(this).css("cursor", null).removeClass("tristate-hover");
			});
			
			label.click(function(){
				var radiogroup = label.find(":radio");
				var radiochecked = radiogroup.filter(":checked");
				var currentstate = radiogroup.index(radiochecked);
				currentstate = ++currentstate % settings.states.length;
				radiochecked.attr("checked", false);
				radiogroup.eq(currentstate).attr("checked", true);
				label.removeClass(settings.states.join(" ")).addClass(settings.states[currentstate]);
			});
		});
	};
})(jQuery);