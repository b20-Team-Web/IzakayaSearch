$(function($) {
    var selectBox = document.getElementsByName("sort");
    var selectForm = document.getElementById("sortFrom");
    $(selectBox).change(function() {
        var text = $('option:selected').text();
        if(text == "ビールが安い順"){
            $(document.getElementById("sortFrom")).cleanQuery();
            alert("読み込まれてるよ");
            //document.getElementById("sortFrom").submit();
            selectBox.options["ビールが安い順"].selected = ture;
            location.href("https://areabeersearch.com/");
        }else{
            console.log(selectBox.option);
            document.getElementById("sortFrom").submit();
        }
    });
});
