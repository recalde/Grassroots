
$category_data = [];
$current_category_filter = {};
$current_category_div = {};

function dialog_close() {
	$(this).remove();
}

function login_dialog(){
	var dialogDiv = $('<div></div>');
	dialogDiv.attr('title', 'You are not logged in.');
	dialogDiv.html('Please login or register to continue.');
	dialogDiv.dialog({ 
		width:300, 
		height:200,
		buttons: {
			"Ok": function() {
				$(this).dialog("close");
			}
		},
		close: dialog_close
	});
}

function loadCategories() {
	$.ajax({
		url: '/categories',
		dataType: 'json',
		success: function(data) {
			$category_data = data;
		}
	});
}

function new_idea(category) {
	
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
		close: dialog_close,
		buttons: {
			"Create": function() {
				var new_idea_data = { 
					new_idea_subject: $('#new_idea_subject').val(), 
					new_idea_description: $('#new_idea_description').val(), 
					new_idea_category_id: $('#new_idea_category_id').val()
				};
				
				$(this).dialog("close");
				
				$.ajax({
					url: '/new_idea',
					dataType: 'json',
					data: new_idea_data,
					success: function() {
						$('.grassroots-tab-panel').empty();
						var tabindex = $("#tabs").tabs('option', 'selected');
						$("#tabs").tabs('load',tabindex);
					}
				});
			},
			Cancel: dialog_close
		}
	});
}

function new_comment(idea_id, comment_id, comment_text) {
	
	var dialogDiv = $('<div></div>');
	
	
	if (comment_text) {
		dialogDiv.append('Response To:<br/>');
		dialogDiv.append(comment_text);
		dialogDiv.append('<br/><br/>');
		dialogDiv.attr('title', 'Reply To Comment');
	}
	else {
		dialogDiv.attr('title', 'New Comment');
	}
	
	dialogDiv.append('Comment Text:<br/>');
	var comment_text = $('<textarea id="new_comment" cols="50" rows="5"></textarea>');
	comment_text.appendTo(dialogDiv);
	dialogDiv.append('<br/>');
	
	var buttons = {
		"Create": function() {
			var new_comment_data = { 
				idea_id: idea_id, 
				comment: comment_text.val()
			};
			
			if (comment_id) {
				new_comment_data.parent_id = comment_id;
			}
			
			$(this).dialog("close");

			
			$.ajax({
				url: '/new_comment',
				dataType: 'json',
				data: new_comment_data,
				success: function() {
					location.reload(true);
				},
				
			});
		},
		Cancel: dialog_close
	};
	
	dialogDiv.dialog({ 
		width:550, 
		height:400,
		close: dialog_close,
		buttons: buttons
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