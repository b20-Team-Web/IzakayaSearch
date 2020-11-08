$(function($) {
    var selectBox = document.getElementsByName("sort");
    var selectForm = document.getElementById("sortFrom");
    $(selectBox).change(function() {
        var text = $('option:selected').text();
        if(text == "ビールが安い順"){
            //$(document.getElementById("sortFrom")).cleanQuery();
            alert("読み込まれてるよ");
            //selectBox.options[0].selected = ture;
            //location.href("https://areabeersearch.com/");
            window.sessionStorage.setItem(['form'],["beer"]);
            document.getElementById("sortFrom").submit();
        }else{
            //selectBox.options[1].selected = ture;
            window.sessionStorage.setItem(['form'],["badget"]);
            document.getElementById("sortFrom").submit();
        }
    });
});
