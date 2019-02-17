function login() {
    ID = document.forms["login"]["ID"].value;
    document.cookie = "uID="+ ID;
    document.location.href = "dash.html";
    return false; 
}