function linkify(elements){
    var re = /((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g;

	elements.each(function() {
		var element = $(this);
		var html = element.html();
	    html = html.replace(re, '<a href="$1" target="_blank">$1</a> ');
		element.html(html);	
	});
}
