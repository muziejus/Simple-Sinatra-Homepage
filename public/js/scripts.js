(function($) {
  "use strict";

  $("a[href^='http']").append(" <i class='fa fa-external-link'></i>");

  $("body").scrollspy({ target: "#navbar" });

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
