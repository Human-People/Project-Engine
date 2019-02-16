import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'global.dart' as global;

abstract class BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWIthEmailAndPassword(String email, String password);
  Future<String> signInWithGoogle();
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<String> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    print(user);
    return user.uid;
  }

  Future<String> createUserWIthEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    print(user);
    return user.uid;
  }

  Future<String>signInWithGoogle() async{
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
    
    FirebaseUser user = await _firebaseAuth.signInWithGoogle(idToken: authentication.idToken, accessToken: authentication.accessToken );
    return user.uid;
  }

  Future<FirebaseUser> currentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async{
    return _firebaseAuth.signOut();
  }


}