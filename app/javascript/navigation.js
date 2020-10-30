/*
 * 並び順を変更するナビゲーションで使うJS
 *
 */
$(function(){
    const navPostion = $('#js-search-nav').offset().top;
    const navWidth  = $('#js-search-nav').outerWidth();

    $(window).on('scroll', function(){
        if ($(this).scrollTop() > navPostion) {
            $('.p-topAreaList').css('margin-left', navWidth);
            $('#js-search-nav').addClass('m_fixed');
        } else {
            $('.p-topAreaList').css('margin-left', 0);
            jQuery('#js-search-nav').removeClass('m_fixed');
        }
    })
});
