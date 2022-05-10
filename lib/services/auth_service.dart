import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/services/database_service.dart';

class AuthService {
  final FA.FirebaseAuth _auth = FA.FirebaseAuth.instance;

  // create user object based on FA.User
  User _userFromFirebaseUser(FA.User user) {
    CurrentAppUser.currentUserData.userId = user.uid;
    var currentUserUid = user.uid;
    return (user != null) ? User(uid: user.uid) : null;
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      FA.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FA.User user = result.user;
      CurrentAppUser.currentUserData.userId = result.user.uid;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      // Fluttertoast.showToast(msg: 'User Not found!', gravity: ToastGravity.TOP);
      if (e.toString().contains('password')) {
        Fluttertoast.showToast(msg: 'Wrong Password!');
      } else if (e.toString().contains('user-not-found')) {
        Fluttertoast.showToast(msg: 'User Not found!');
      } else {
        Fluttertoast.showToast(msg: 'Unexpected Error!');
      }
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String fullName,
      String email,
      String password,
      String state,
      String lga,
      String sex,
      String phone,
      String username,
      String address) async {
    try {
      FA.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FA.User user = result.user;

      // Create a new document for the user with uid
      await DatabaseService(uid: user.uid).updateUserData(fullName, user.uid,
          email, password, state, lga, sex, phone, username, address);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //lOGIN WITH GOOGLE
  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // 'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _auth = await account.authentication;
      final FA.AuthCredential credential = FA.GoogleAuthProvider.credential(
        accessToken: _auth.accessToken,
        idToken: _auth.idToken,
      );
      FA.User user =
          (await FA.FirebaseAuth.instance.signInWithCredential(credential))
              .user;
      if (user != null) {
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc('${user.uid}');
        DocumentSnapshot ds = await userDoc.get();
        if (ds.exists) {
          CurrentAppUser.currentUserData.userId = user.uid;
        } else {
          await DatabaseService(uid: user.uid).updateUserData(
              '${user.displayName}',
              user.uid,
              '${user.email}',
              '',
              '-',
              '-',
              '-',
              '-',
              user.email.split('@')[0],
              '-');
        }
        await HelperFunctions.saveUserLoggedInSharedPreference(true);
        await HelperFunctions.saveUserEmailSharedPreference('${user.email}');
        await HelperFunctions.saveUserNameSharedPreference(
            '${user.displayName}');
        return _userFromFirebaseUser(user);
      } else {
        Fluttertoast.showToast(
          msg: 'Upexpected Error, Something went wrong !',
          gravity: ToastGravity.TOP,
        );
        return null;
      }
    } catch (e) {
      print("Yahan tk a gaya hon.: $e");
      Fluttertoast.showToast(
          msg: "Login Failed! $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          fontSize: 16.0);
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.saveUserEmailSharedPreference('');
      await HelperFunctions.saveUserNameSharedPreference('');
      CurrentAppUser.currentUserData.userId = null;
      return await _auth.signOut().whenComplete(() async {
        print("Logged out");
        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
          print("Logged in: $value");
        });
        await HelperFunctions.getUserEmailSharedPreference().then((value) {
          print("Email: $value");
        });
        await HelperFunctions.getUserNameSharedPreference().then((value) {
          print("Full Name: $value");
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
