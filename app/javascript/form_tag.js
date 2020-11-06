$(function($) {   
    var selectBox = document.getElementsByName("sort");
    $(selectBox).change(function() {
        var text = $('option:selected').text();
        console.log(text);
        document.getElementById("sortFrom").submit();
    });
});