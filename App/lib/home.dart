import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'auth.dart';
import 'root_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:latlong/latlong.dart';
import 'package:geo_location_finder/geo_location_finder.dart';
import 'dart:math';


class HomePage extends StatefulWidget{
  HomePage({this.auth, this.onSignedOut, this.choice});
  
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final Market choice;

  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  void initState(){
    super.initState();
    getLocation();
  }

  var currentLocation;

  Future<void> getLocation() async{
    var location = await GeoLocation.getLocation;
    print(location.toString());
    setState(() {
          currentLocation = location;
        });
  }

  List<Widget> tabs = [
    Tab(text: "Babysitter",),
    Tab(text: "Playmate",)
  ];

  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
    
      child: Scaffold(
      appBar: AppBar(
        title: Text("Monkey Minders"),
        bottom: TabBar(
          tabs: tabs,
        ),
        //actions: <Widget>[
          //IconButton(
            //icon: Icon(Icons.account_circle),
            //onPressed: () => MaterialPageRoute(
              //(context) => 
            //) 
          //,)
        //],
      ),
      body: TabBarView(
        children: <Widget>[
          Nanny(location: currentLocation,),
          Mate()
        ],
      )
    )
    );
  }
}

class Nanny extends StatefulWidget{
  Nanny({this.location});
  final location;

  @override
  State<StatefulWidget> createState() => NannyState();
}
  
  
class NannyState extends State<Nanny>{ 
  
  Widget build(BuildContext context){
    return(
      StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("nannies").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Error: ${snapshot.error}");
          }
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return Text("Loading", textAlign: TextAlign.center,);
            default:
            return ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document){
                return ListTile(
                leading: Container( 
                  width: 50,
                  height: 50,
                  decoration:BoxDecoration(
                    shape: BoxShape.circle, 
                    image: DecorationImage(
                        fit:BoxFit.cover, 
                        image: NetworkImage(document["img"]),
                        )
                  )
                ),
                title: Text(document["name"], textDirection: TextDirection.ltr, textAlign: TextAlign.start),
                subtitle: Text(document["desc"]),
                trailing: Container(child: StarRating(starCount: 5, rating: document["star"]+ .0, size: 20, color: Colors.amber,), width: 100,),
                onTap: () => Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (BuildContext context) => InfoScreen(document: document, location: widget.location)
                  )
                )
              );
              }).toList()
            );
          }
        },
      )
    );
  }
}

class Mate extends StatelessWidget{
  Widget build(BuildContext context){
    return(
      Text("PlayMate")
    );
  }
}

class Profile extends StatefulWidget{
  Profile({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile>{
  var uname = "loading";

  void initState(){
    super.initState();
    
  }

  Future<String> getName() async{
    FirebaseUser uName =  await widget.auth.currentUser();
    setState(() {
          uname = uName.displayName != null ? uName.displayName : uName.email;
        });
  }

  Widget build(BuildContext context){
    return(
      Scaffold(
        appBar: AppBar(
          title: Text(uname),
          )


      )
    );
  }
}

class InfoScreen extends StatefulWidget{
  InfoScreen({this.document, this.location});
  final DocumentSnapshot document;
  final  location;
  final Distance distance = new Distance();
  @override
  State<StatefulWidget> createState() => InfoState();
}

class InfoState extends State<InfoScreen>{
  Widget build(BuildContext context){
    GeoPoint nannyLoc = widget.document["loc"];
    num distance = widget.distance.as(LengthUnit.Meter, LatLng(widget.location["latitude"], widget.location["longitude"]), LatLng(nannyLoc.latitude, nannyLoc.longitude));
    num distanceKm =  distance/1000;
    String rounded = distanceKm.toStringAsFixed(1);
    return Scaffold(
      appBar: AppBar(title: Text(widget.document["name"])),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration( 
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.document["img"])
              )

            ),
          ),
          ListTile(
            title: Text(widget.document["name"]),
            trailing: Container(
              width: 85,
              child: Row(
                children: <Widget>[
                  Icon(Icons.pin_drop),
                  Text(rounded+" km")
                ],
              ),
            )
          ),
          ListTile(
            title: Text("DBS Checked:"),
            trailing: widget.document["dbs"] == true ? Text("Yes", style: TextStyle(color: Colors.green)) : Text("No", style: TextStyle(color: Colors.redAccent))
          ),
          ListTile(
            leading: FlatButton(
              child: Text("Book Interview"),
              onPressed: () => setInterview(context, widget.location, widget.document, true)
            ),
            trailing: FlatButton(
              child: Text("Book a session"),
              onPressed: () => setInterview(context, widget.location, widget.document, false)
            ),
          )
        ]
      )
    );
  }

  setInterview(BuildContext context, location, DocumentSnapshot document, bool type) async{
    DateTime appointmentDay = await showDatePicker(
      firstDate: DateTime.now(), 
      lastDate: DateTime(DateTime.now().year+1), 
      initialDate: DateTime.now(), 
      context: context, 
      initialDatePickerMode: DatePickerMode.day);

    TimeOfDay appointmentTime = await showTimePicker(
      initialTime: TimeOfDay.now(), 
      context: context);

    GeoPoint geoPoint = GeoPoint(location["latitude"], location["longitude"]);

    DateTime appointment = DateTime.utc(appointmentDay.year, appointmentDay.month, appointmentDay.day, appointmentTime.hour, appointmentTime.hour);

    TimeOfDay appointEnd = type == true ? appointmentTime : await showTimePicker(
      initialTime: appointmentTime,
      context: context
    );

    Duration lengthApp = DateTime(appointment.year, appointment.month, appointment.day, appointEnd.hour, appointEnd.minute).difference(appointment);



    num charge = type == true ? 0 : document["hour"] * lengthApp.inHours.toDouble();

    Firestore.instance.document("nannies/"+document.documentID).collection("requests").add({"charge": charge , "date": appointment, "fufilled": false, "interview": type, "location": geoPoint});
  }
}