// Initialisation
var d = new Date(0);
var cook = document.cookie;
console.log("cook")
var uID = cook.split("=")[1]
console.log(uID)
var tableR = document.getElementById("requests");
var tableI = document.getElementById("interviews")
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
    document.getElementById("uFirstName").innerText = doc.data().name;
    document.getElementById("uDesc").innerText = doc.data().desc;
});
// Firebase 
var coll = db.collection("nannies").doc(uID).collection("requests");
coll.get().then((querySnapshot) => {
    querySnapshot.forEach((doc) => {
        if (doc.data().interview == true) {
            table = tableI
        } else {table = tableR}
        var row = table.insertRow(1);
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        var cell4 = row.insertCell(3);
        console.log("Document data:", doc.data());
        fulish = doc.data().fufilled; 
        console.log(fulish)
        if (fulish == true) {
            reqFill = "Yes"
        } else {
            reqFill = "No"
        }
        reqLat = doc.data().location.latitude.toString();
        reqLon = doc.data().location.longitude.toString();
        reqLoc = reqLat + "," + reqLon
        reqDate = new Date(doc.data().date.seconds * 1000).toString().split("GMT")[0];
        cell1.innerHTML = reqDate;
        cell2.innerHTML = '<span id="' + doc.id + '">' + reqFill + '</span>';
        cell3.innerHTML = '<a target="_blank" href="https://www.google.com/maps/dir/?api=1&destination='+reqLoc+'">'+reqLoc+'</a>';
        if (reqFill == "Yes") {
            cell4.innerHTML = '<i style="color: green;" class="fas fa-check-circle"></i>'
        } else {
            cell4.innerHTML = '<a><i onclick="acceptJob(\'' + doc.id + '\')" class="fas fa-check-circle"></i></a>'
        }
    });
});

function acceptJob(dID) {
    console.log("Firing")
    console.log(dID)
    var docc = db.collection("nannies").doc(uID).collection("requests").doc(dID)
    var acception = docc.set({
        fufilled: true
    }, { merge: true });
    document.getElementById(dID).innerText = "Yes";
}