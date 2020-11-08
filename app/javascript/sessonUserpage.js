$(function(){
    var sesson = window.sessionStorage.getItem(['form']);
    if(sesson){
        if(sesson == "beer"){
            document.getElementById("beer").selected = true;
        }else{
            document.getElementById("budget").selected = true;
        }
    }
});