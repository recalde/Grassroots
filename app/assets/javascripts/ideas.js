
$category_data = [];
$current_category_filter = {};
$current_category_div = {};

function login_dialog(){
	var dialogDiv = $('<div></div>');
	dialogDiv.attr('title', 'You are not logged in.');
	dialogDiv.html('Please login or register to continue.');
	dialogDiv.dialog({ 
		width:300, 
		height:200,
		buttons: {
			"Ok": function() {
				$( this ).dialog( "close" );
			}
		}
	});
}

function renderCategories() {
	$.ajax({
		url: '/categories',
		dataType: 'json',
		success: function(data) {
			$category_data = data;
			var topics = { topics: data };
			var renderTopics = $('#topicsTemplate').tmpl(topics);
			$('#grass-body').empty();
			renderTopics.appendTo('#grass-body');
			$('#tabs').tabs();
			
			$('#tabs').bind( "tabsselect", function(event, ui) {
				var category_id = $(ui.panel).attr('category_id');
				var category_type = $(ui.panel).attr('category_type');
				
				$current_category_filter = { };
				$current_category_div = { };
				
				if (category_id) {
					$current_category_filter.category_id = category_id;
					$current_category_div = $('#category-' + category_id);
				}
				else if (category_type) {
					$current_category_filter.category_type = category_type;
					$current_category_div = $('#category-' + category_type);
				}

				renderIdeas($current_category_filter, $current_category_div);	
			});

			$current_category_filter = { category_type: 'top' };
			$current_category_div = $('#category-top');
			renderIdeas($current_category_filter, $current_category_div);	
			
		}
	});
}

function renderIdeas(filter, category_div) {

	$.ajax({
		url: '/ideas',
		dataType: 'json',
		data: filter,
		success: function(data) {
			var render = $('#ideaTemplate').tmpl(data);
			category_div.empty();
			render.appendTo(category_div);
			
			var new_button = $('<button class="new-idea ui-button">New Idea</button>');
			new_button.button();
			
			if (filter.category_id != null)
				new_button.attr('category_id', filter.category_id);
				
			new_button.appendTo(category_div);
			
		}
	});
}

function new_idea() {
	var category = $(this).attr('category_id');
	
	var data = { };

	if (category != undefined)
		data.category_id = category;
	else
		data.categories = $category_data;

	var newIdeaDiv = $('<div></div>');
	newIdeaDiv.attr('title', 'New Idea');
	
	var renderDialog = $('#newIdeaDialogTemplate').tmpl(data);
	renderDialog.appendTo(newIdeaDiv);
	newIdeaDiv.dialog({
		width:600,
		height:400,
		buttons: {
			"Create": function() {
				var new_idea_data = { 
					new_idea_subject: $('#new_idea_subject').val(), 
					new_idea_description: $('#new_idea_description').val(), 
					new_idea_category_id: $('#new_idea_category_id').val()
				};
				
				$(this).dialog("close");
				$(this).remove();
				
				$.ajax({
					url: '/new_idea',
					dataType: 'json',
					data: new_idea_data,
					success: function() {
						renderIdeas($current_category_filter, $current_category_div);
					}
				});
			},
			Cancel: function() {
				$(this).dialog( "close" );
				$(this).remove();
			}
		}
	});
}

function vote(vote_id, vote, success) {
	var voteData = { idea_id: vote_id, vote: vote };
	
	$.ajax({
		url: '/vote',
		dataType: 'json',
		data: voteData,
		success: success
	});
}