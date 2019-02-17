// Initialisation
var d = new Date(0);
var uID = "2vlMo1eTAwSVbptjBUuT"
var table = document.getElementById("requests");
var config = {
    apiKey: "AIzaSyAUj5V7i-0jPFfwd4DnTryT5fPGxlxThGE",
    authDomain: "project-engine-5cb03.firebaseapp.com",
    databaseURL: "https://project-engine-5cb03.firebaseio.com",
    projectId: "project-engine-5cb03",
    storageBucket: "project-engine-5cb03.appspot.com",
    messagingSenderId: "1093130137991"
};
firebase.initializeApp(config);
var db = firebase.firestore();
var user = db.collection("nannies").doc(uID)
// User Details
document.getElementById("uID").innerText = "User ID: " + uID;
user.get().then(function(doc) {
    console.log(doc.data)
    document.getElementById("profilePic").src = doc.data().img;
    document.getElementById("uFirstName").innerHTML = "&nbsp; Name: " + doc.data().name;
    document.getElementById("uDesc").innerHTML = "&nbsp; Description: " + doc.data().desc;
    if (doc.data().dbs == true) {
        document.getElementById("uDBS").innerHTML = "&nbsp; DBS Checked: Yes";
    } else {
       document.getElementById("uDBS").innerHTML = "&nbsp; DBS Checked: No";
    }
    document.getElementById("uRate").innerHTML = "&nbsp; Hourly Rate: £" + doc.data().hour;
});
