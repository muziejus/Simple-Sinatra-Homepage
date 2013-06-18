/* Author: Moacir P. de Sá Pereira, 2012 (http://moacir.com)

*/

$('.trigger').removeAttr('href');

$('.trigger').click(function() {
	var stateobj = { foo: "bar" }; // Just some data for pushState…
	var pathname = location.pathname; // the current url after 'moacir.com'
	var togglename = $(this).attr('id').replace('subhead', '');
	var togglediv = togglename + 'body';
	var togglepatt = new RegExp(togglename);
	var trailslash = new RegExp(/\/$/);
	if (!$('#'+togglediv).is(':visible')){ // is the toggle not visible? if yes:
		if (trailslash.test(pathname)){ // make the url without double slashes
			history.replaceState(stateobj, togglename, pathname + togglename);
		}else{
			history.replaceState(stateobj, togglename, pathname + '/' + togglename);
		}
		$('#'+togglediv).show(); // and now we use show() instead of toggle()
	}else{ // so the toggle is visible. Hide it and delete it from the URL
		pathname = pathname.replace(togglepatt, ''); // erase it!
		if (togglename == 'publishing'){ // get rid of specific subtopics, too
			subtopics = ["poparticles", "presentations", "selfpublishing", "cartography"]
			for (x in subtopics){
				pathname = pathname.replace('/' + subtopics[x], '');
				$('#'+subtopics[x]+'body').hide();
			}
		}	
		pathname = pathname.replace('//', '/'); // and the double slashes!
		history.replaceState(stateobj, '-' + togglename, pathname);
		$('#'+togglediv).hide(); // use hide() instead of toggle()
	} 
});



