function signIn(email, password) {
    var email = document.forms["login"]["email"]
    var password = document.forms["login"]["password"]
    firebase.auth().signInWithEmailAndPassword(email, password).catch(function(error) {
        console.log(email)
        console.log(password)
        var errorCode = error.code;
        var errorMessage = error.message;
        console.log(errorCode, ",", errorMessage)
        console.log("Working?")
    });}

document.addEventListener('DOMContentLoaded', () => {
    const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
    if ($navbarBurgers.length > 0) {
        $navbarBurgers.forEach( el => {
        el.addEventListener('click', () => {
            const target = el.dataset.target;
            const $target = document.getElementById(target);
            el.classList.toggle('is-active');
            $target.classList.toggle('is-active');
        });
        });
    }
    });