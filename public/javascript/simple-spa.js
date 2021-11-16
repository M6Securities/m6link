$.ajaxSetup({
	contentType: 'application/json; charset=utf-8'
});

let host = window.location.hostname;
let pageContent;
const urlTest = /^http?:\/\//i;
let useSPA = false;

var showPace = true;

$(function () {
	$(document).ajaxStart(function () {
		if (showPace) {
			$('body').removeClass('pace-done');
			Pace.restart();
		}
	});
});

function getParameterByName(name, url) {
	if (!url) {
		url = window.location.href;
	}

	name = name.replace(/[\[\]]/g, '\\$&');

	const regex = new RegExp(`[?&]${name}(=([^&#]*)|&|#|$)`);
	let results = regex.exec(url);

	if (!results) {
		return null;
	}
	if (!results[2]) {
		return '';
	}

	return decodeURIComponent(results[2].replace(/\+/g, " "));
}

// THIS IS GETTING CALLED MULTIPLE TIMES n^2
function loadPage(page, back) {
	// console.log(page);
	const logoutPath = '/users/sign_out';
	const contentID = '#page-content';

	if (!urlTest.test(page) && page !== null) {

		try {
			rg4js('trackEvent', { type: 'pageView', path: page });
		} catch (e) {

		}

		try {
			$.ajax({
				url: page,
				type: 'GET',
				dataType: 'text',
				beforeSend: function () {
					//console.log("Before send");
				},
				success: function () {
					//console.log("Haha this never gets called when using App Menu FML");
				},
				complete: function () {
					//console.log("AJAX ran");
				},
				statusCode: {
					200: function (data) {
						//console.log("Request OK");
						useSPA = true;
						//const contentID = '#page-content'



                        //POS JQuery what the hell is this
                        // const elementMain = $(data).filter('main');

                        //const elementContent = $(elementMain.html()).filter('.content');
						const elementContent = $(data).filter('.content');

						const elementWrapper = $(elementContent.html()).filter('.content-wrapper');


						// check to see if the page is the logout page
						let pagePath =  $(elementWrapper.html()).filter('#requested-page-path').html();
						if (pagePath !== undefined) {
							pagePath = pagePath.trim();
							if (pagePath === logoutPath) {
								basket.clear();
								window.location.href = logoutPath;
								return;
							}
						}


                        const elementPageContent = $(elementWrapper.html()).filter( function (index, element) {
                            //console.log(element);
                            return $( this ).attr( 'id' ) === 'page-content';
                        });

                        // console.log(elementPageContent.html());

                        const content = $(elementPageContent.html()).filter('div');

                        // console.log(content);


						/*

						// fetches the content from data
						const content = $( $( $( $(data).filter('main').html() ).filter('.content').html() ).filter( function (index, element) {
							//console.log(element);
							return $( this ).attr( "id" ) === "page-content";
						}).html() ).filter("div");

						 */

						// fetches and sets the title
						const title = $(data).filter('title').html().trim();

						if (title === '' || title === undefined) {
							$('title').html('ONAC-APP');
						} else {
							$('title').html(title);
						}



						//console.log($($(data).filter("main")).filter(".app-content").html());

						//clear existing data
						$(`${contentID} > *`).remove();

						//add new data
						$(contentID).html(content);

						//update the render time
						//$("#page-render-time").html($(data).find("#page-render-time").html())

						//arrangePage();

						$('html, body').animate({
							scrollTop: 0
						}, 0);

						if (back == null) {
							history.pushState(null, null, page);
						}

						bindLinks();

						try {
							if (feather) {
								feather.replace({
									width: 14,
									height: 14
								});
							}
						} catch (e) {}

						if(useSPA){
							try {
								formatPage();
								pageReady();
							} catch {}
						}


					},
					204: function () {
						createToast('Error 204', 'No Content', 'error');
					},
					401: function () {
						// unbind the links to force a redirect
						const links = $('a');
						links.off('click');


						createToast('Error 401', 'Invalid Permissions <br> Action Unauthorized', 'error');
					},
					404: function () {
						createToast('Error 404', 'Page not found', 'error');
					},
					500: function () {
						createToast('Error 500', 'Looks like something tripped up. Try reloading the page?', 'error');
					},
					502: function () {
						createToast('Error 502', 'No response from the server...', 'error')	;
					},
					504: function () {
						createToast('Error 504', 'Gateway error', 'error');
					}
				},
				error: function (jqXHR, textStatus, errorThrown) {
					console.log('Error running AJAX request');
					console.log(`jqXHR: ${jqXHR}`);
					console.log(`Text Status: ${textStatus}`);
					console.log(`Error Thrown: ${errorThrown}`);
				}
			});
			//console.log("After AJAX");
		} catch (e) {
			console.log('Caught error running AJAX request');
			console.log(e);
		}


	} else {
		//window.open(page, "_blank");
		createToast('Error Opening Page', 'Something isn\'t right.', 'error');
	}
}


function bindLinks() {
	const links = $('a');

	// we remove all the click events because we're then rebinding them.
	// if we didn't, loadpage would be called 2^n times.
	links.off('click');

	links.on('click', function (e) {
		const page = $(this);

		if ((typeof page.data('external') !== 'undefined') || (typeof page.data('internal') !== 'undefined')) {
			//if it's an internal link, aka one that calls js, or an external link, like www.google.com, do nothing
			//console.log("Internal page link clicked")
		} else if (page.attr('href') === undefined || page.attr('href') === '#') {
			// Do nothing
		} else {
			e.preventDefault();
			showPace = true;
			loadPage(page.attr('href'));
		}
	});
}

$(document).ready( function () {
	// console.log('bruh');

	bindLinks();

	if(!useSPA) {
		try {
			formatPage();
			pageReady();
		} catch {}
	}


	window.addEventListener('popstate', function (e) {
		loadPage('/' + location.href.replace(/^(?:\/\/|[^\/]+)*\//, ''), '1');
	});

	document.addEventListener('DOMContentLoaded', function () {
		//arrangePage();
	});
});
