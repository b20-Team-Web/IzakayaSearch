$(function(){
    var coler = '#FFF9BF';
    $(":checked").closest('li').css('background', coler);
    $("input[type='checkbox']").change(function(){
        if($(this).is(":checked")){
            $(this).closest('li').css('background', coler);
        }else{
            $(this).closest('li').css('background', '');
        }
    });
})