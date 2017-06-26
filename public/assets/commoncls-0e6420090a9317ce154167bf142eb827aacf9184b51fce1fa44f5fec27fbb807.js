$(document).ready(function(){ 

                $(".commoncls").keyup(function() {

    var val = $(this).val();
    if (parseInt(val) < 0 || isNaN(val)) {
        alert("please enter valid values");
        $(this).val("");
        $(this).focus();
    }
});
});

