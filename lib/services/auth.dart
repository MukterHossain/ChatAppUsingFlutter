import 'package:chatappuf/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userModelFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? UserModel(userId: user.uid) : null;
  }

  Future signInWithEmailAndPass(String email, String password) async {
    try {
      await Firebase.initializeApp();
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user!;
      return _userModelFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signUPWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user!;
      return _userModelFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future rsetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
