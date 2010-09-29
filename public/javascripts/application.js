$(function() {
	// =================
	// = flash message =
	// =================
	if ($('.flash_notice').length > 0) {
		// $.jGrowl($('.flash_notice').text(), {theme: 'flash_notice', speed: 100, life: 2000});
		$.jGrowl($('.flash_notice').text(), {theme: 'flash_notice', speed: 100});
		$('.flash_notice').remove();
	}
	if ($('.flash_alert').length > 0) {
		$.jGrowl($('.flash_alert').text(), {sticky: true, theme: 'flash_alert', speed: 100});
		$('.flash_alert').remove();
	}
	
	// =================
	// = navigate menu =
	// =================
	$('.menu li:last-child').addClass('last');

	// ========================
	// = destroy confirmation =
	// ========================
	$('a[data-confirm],input[data-confirm]').live('click', function () {
		confirming = "<span class='confirming'>Really Delete?<a id='positive' href='#'>Yes</a><a id='negative' href='#'>No</a></span>"
		var el = $(this);
		el.before(confirming);
		el.hide();
		return false
	});
	
	$('.confirming > #positive').live('click', function (e) {
		var el = $(this);
		origin_link = el.parents('span.confirming').next('a');

		href = origin_link.attr('href');
		method = origin_link.attr('data-method');
		form = $('<form method="post" action="'+href+'"></form>');
		metadata_input = '<input name="_method" value="'+method+'" type="hidden" />';


		csrf_token = $('meta[name=csrf-token]').attr('content');
		csrf_param = $('meta[name=csrf-param]').attr('content');
		if (csrf_param != null && csrf_token != null) {
			metadata_input += '<input name="'+csrf_param+'" value="'+csrf_token+'" type="hidden" />';
		}

		form.append(metadata_input);
	
		e.preventDefault();
		form.submit();
	});
	
	$('.confirming > #negative').live('click', function (e) {
		var el = $(this);
		parent_span = el.parents('span.confirming');
		origin_link = parent_span.next('a');
		parent_span.remove();
		origin_link.show();
		return false
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
});
