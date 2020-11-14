$(function(){
    $('.js-topSort_accordionItemLink').each(function(){
        $(this).on('click',function(){
            $(this).toggleClass('on');
            $("+.topSort_accordionUl",this).slideToggle();
            return false;
        })
    })
});
