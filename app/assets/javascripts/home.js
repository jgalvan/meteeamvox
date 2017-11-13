$(document).ready(function() {
    $("#sign-in-form").on("ajax:success", function(e, data, status, xhr) {
        window.location.replace("/meetings/");
    });
    $("#sign-in-form").on("ajax:error", function(evt) {
        $("#error-msg").text(evt.detail[0].error);
    });
});
