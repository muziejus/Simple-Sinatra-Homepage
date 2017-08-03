(function($) {
    "use strict";

    $("body").scrollspy({
        target: ".navbar-fixed-top",
        offset: 60
    });

    $("a[href^='http']").append(" <i class='fa fa-external-link'></i>");

    new WOW().init();
    
    $("a.page-scroll").click(function(event) {
        var $ele = $(this);
        $("html, body").stop().animate({
            scrollTop: ($($ele.attr("href")).offset().top - 60)
        }, 1450, "easeInOutExpo");
        event.preventDefault();
    });
    
    $(".navbar-collapse ul li a").click(function() {
        /* always close responsive nav after click */
        $(".navbar-toggle:visible").click();
    });

    $("#galleryModal").on("show.bs.modal", function (e) {
       $("#galleryImage").attr("src",$(e.relatedTarget).data("src"));
    });

})(jQuery);
