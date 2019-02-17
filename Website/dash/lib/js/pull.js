// Initialisation
var d = new Date(0);
var uID = "2vlMo1eTAwSVbptjBUuT"
var table = document.getElementById("requests");
// User ID
document.getElementById("uID").innerText = "User ID: " + uID

// Firebase 
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
var coll = db.collection("nannies").doc("2vlMo1eTAwSVbptjBUuT").collection("requests");
coll.get().then((querySnapshot) => {
    querySnapshot.forEach((doc) => {
        var row = table.insertRow(1);
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        var cell4 = row.insertCell(3);
        console.log("Document data:", doc.data());
        fulish = doc.data().fufilled; 
        console.log(fulish)
        if (fulish == "true") {
            reqFill = "Yes"
        } else {
            reqFill = "No"
        }
        reqLat = doc.data().location.latitude.toString();
        reqLon = doc.data().location.longitude.toString();
        reqLoc = reqLat + ", " + reqLon
        reqDate = new Date(doc.data().date.seconds * 1000).toString().split("GMT")[0];
        cell1.innerHTML = reqDate;
        cell2.innerHTML = reqFill;
        cell3.innerHTML = reqLoc;
        cell4.innerHTML = '<a href="fufil.html"><i class="fas fa-check-circle"></i></a>'
    });
});