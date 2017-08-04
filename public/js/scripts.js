(function($) {
  "use strict";

  let externalLink = $.parseHTML("<span>&nbsp;<i class='fa fa-small fa-external-link'></i></span>");
  $("a[href^='http']").append(externalLink).get(0);

  $("body").scrollspy({ target: 
    "#navbar",
    offset: 100 
  });

  ScrollPosStyler.init();

  new WOW().init();
  
  // $("a.page-scroll").click(function(event) {
  //     var $ele = $(this);
  //     $("html, body").stop().animate({
  //         scrollTop: ($($ele.attr("href")).offset().top - 60)
  //     }, 1450, "easeInOutExpo");
  //     event.preventDefault();
  // });
  
  $(".navbar-collapse ul li a").click(function() {
    /* always close responsive nav after click */
    $(".navbar-toggler:visible").click();
  });

})(jQuery);
