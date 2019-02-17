// document.cookie = "uID="

function login() {
    ID = document.forms["login"]["ID"].value;
    document.cookie = "uID="+ ID;
    document.location.href = "dash.html";
    return false; 
}

function signOut() {
    document.cookie = "uID=";
    document.location.href = "index.html";
    return false; 
}