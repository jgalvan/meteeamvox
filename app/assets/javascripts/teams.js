$(document).ready(function () {
    $('.modal').modal();


    $("#add-team-members").select2({
        placeholder: "Invite...",
        allowClear: false,
        openOnEnter: false,
        minimumInputLength: 3,
        minimumResultsForSearch: 1,
        width: "70%"
    });

});