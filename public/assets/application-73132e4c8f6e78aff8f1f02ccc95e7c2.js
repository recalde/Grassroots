/*
 * JavaScript Pretty Date
 * Copyright (c) 2008 John Resig (jquery.com)
 * Licensed under the MIT license.
 */
// Takes an ISO time and returns a string representing how
// long ago the date represents.
function prettyDate(a){var b=new Date((a||"").replace(/-/g,"/").replace(/[TZ]/g," ")),c=((new Date).getTime()-b.getTime())/1e3,d=Math.floor(c/86400);if(isNaN(d)||d<0||d>=31)return;return d==0&&(c<60&&"just now"||c<120&&"1 minute ago"||c<3600&&Math.floor(c/60)+" minutes ago"||c<7200&&"1 hour ago"||c<86400&&Math.floor(c/3600)+" hours ago")||d==1&&"Yesterday"||d<7&&d+" days ago"||d<31&&Math.ceil(d/7)+" weeks ago"}typeof jQuery!="undefined"&&(jQuery.fn.prettyDate=function(){return this.each(function(){var a=prettyDate(this.title);a&&jQuery(this).text(a)})})