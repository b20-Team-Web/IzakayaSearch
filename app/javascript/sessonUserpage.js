$(function(){
    var session = window.sessionStorage.getItem(['form']);
    var selectBox = $('[name=js-sort]');
    if (session !== null) {
        if (session === "beer") {
            $('select[name="jssort"] > option[value="beer"]').prop('selected', true);
        } else if (session === "budget") {
            $('select[name="jssort"] > option[value="budget"]').prop('selected', true);
        }
    } else {
        $("#js-beer").selected = true;
    }
});
