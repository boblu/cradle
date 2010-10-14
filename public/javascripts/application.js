$(function() {
	get_flash_msg();
	
	// =================
	// = navigate menu =
	// =================
	$('.menu li:last-child').addClass('last');

	// ========================
	// = destroy confirmation =
	// ========================
	$('.destroy_button .minibutton').live('click', function () {
		$(this).hide().next().show();
		return false;
	});
	
	$('.destroy_button .negative').live('click', function () {
		$(this).parent().hide().prev().show();
		return false;
	});
	
	// =============
	// = dashboard =
	// =============
	$("#tabs").tabs({
		ajaxOptions: {
			error: function(xhr, status, index, anchor) {
				$(anchor.hash).html("Couldn't load this tab. We'll try to fix this as soon as possible.");
			}
		}
	});
	
	$('.dashboard_sidebar li a').live('click', function () {
		$('.dashboard_sidebar li a').removeClass('selected');
		$(this).addClass('selected');
	});
	
	$('.remove_parent_infobox').live('click', function () {
		$(this).parents('div.infobox').remove();
		return false;
	});
	
	
	
	$('#dictionary_section table.listing_table td .anchor').live('click', function () {
		$(this).parent().siblings().removeClass('selected');
		$(this).parent().addClass('selected');
	});
});

// =================
// = flash message =
// =================
function get_flash_msg() {
	if ($('.flash_notice').length > 0) {
		$.jGrowl($('.flash_notice').text(), {theme: 'flash_notice', speed: 100});
		$('.flash_notice').remove();
	}
	if ($('.flash_alert').length > 0) {
		$.jGrowl($('.flash_alert').text(), {sticky: true, theme: 'flash_alert', speed: 100});
		$('.flash_alert').remove();
	}
}