
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

function renderTopics() {
	$.ajax({
		url: '/categories',
		dataType: 'json',
		success: function(data) {
			var topics = { topics: data };
			var renderTopics = $('#topicsTemplate').tmpl(topics);
			$('#grass-body').empty();
			renderTopics.appendTo('#grass-body');
			$('#tabs').tabs();
			
			$('#tabs').bind( "tabsselect", function(event, ui) {
				var category_id = $(ui.panel).attr('category_id');
				var category_type = $(ui.panel).attr('category_type');
				
				var category_filter = { };
				var category_div;
				if (category_id) {
					category_filter.category_id = category_id;
					category_div = $('#category-' + category_id);
				}
				else if (category_type) {
					category_filter.category_type = category_type;
					category_div = $('#category-' + category_type);
				}

				renderIdeas(category_filter, category_div);	
			});


			renderIdeas({ category_type: 'top' }, $('#category-top'));	
			
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
			new_button.appendTo(category_div);
			new_button.attr('category_id', category_id);
		}
	});
}

function new_idea() {
	var category = $(this).attr('category_id');
	var data = { category_id: category };

	var newIdeaDiv = $('<div></div>');
	newIdeaDiv.attr('title', 'New Idea');
	
	var renderDialog = $('#newIdeaDialogTemplate').tmpl(data);
	renderDialog.appendTo(newIdeaDiv);
	newIdeaDiv.dialog({
		width:600,
		height:250,
		buttons: {
			"Create": function() {
				var data = { 
					new_idea_subject: $('#new_idea_subject').val(), 
					new_idea_description: $('#new_idea_description').val(), 
					new_idea_category_id: $('#new_idea_category_id').val()
				};
				
				$(this).dialog("close");
				$(this).remove();
				
				$.ajax({
					url: '/new_idea',
					dataType: 'json',
					data: data,
					success: function() {
						renderIdeas(category);
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