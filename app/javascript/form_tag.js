$(function($) {
    var selectBox = $('[name=jssort]');
    $(selectBox).change(function() {
        var value = $(selectBox).val();
        if( value === "beer" ){
            window.sessionStorage.setItem(['form'],[value]);
            window.location.href = "/";
        } else if ( value === "budget" ) {
            window.sessionStorage.setItem(['form'],[value]);
            $("#sortFrom").submit();
        }
    });
});
