$( document ).ready(function() {

  	$(document).on('click', '.save-traveled-to', function(e) {
		var all_select, id, list, str;
		e.preventDefault();
		id = $("meta[name='user-id']").attr('content');
		list = [];
		all_select = $('.traveled_to_wrap').find('select');
		$.each(all_select, function(index) {
			list.push($(this).val());
		});
		str = '';
		str = list.join(',');
		$.post('/traveled', {
			country_visited: str,
			id: id
		});
		alert("Countries Traveled to Saved");
	});

    /*
     *
     */
    $(document).on('click', '.save-to-visit', function(e) {
		var all_select, id, list, str;
		e.preventDefault();
		id = $("meta[name='user-id']").attr("content");
		list = [];
		all_select = $('.to_visit_wrap').find('select');
		$.each(all_select, function(index) {
			list.push($(this).val());
		});
		str = '';
		str = list.join(',');
		$.post('/want', {
			country_to_visit: str,
			id: id
		});
		alert("Countries to Travel to Saved");
	});

});

