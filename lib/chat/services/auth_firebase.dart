import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/enum/user_state.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/utility/utilityStatus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);
  GoogleSignIn _googleSignIn = GoogleSignIn();

  //********get Current user data****** */
  Future<UserData> getUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(auth.currentUser!.uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return UserData.fromMap(data);
  }

  Future<UserData> getUserDetailsReciever(String? userId) async {
    DocumentSnapshot documentSnapshot = await _userCollection.doc(userId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return UserData.fromMap(data);
  }

  Future<List<UserData>> fetchAllUsers() async {
    List<UserData> userList = <UserData>[];
    QuerySnapshot querySnapshot = await _firestore
        .collection(USERS_COLLECTION)
        .where("UserId", isNotEqualTo: auth.currentUser!.uid)
        .get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      userList.add(UserData.fromMap(data));
    });
    return userList;
  }

  Future<List<UserData>> fetchAllConversation(uid) async {
    List<UserData> convesationList = <UserData>[];
    QuerySnapshot querySnapshot = await _firestore
        .collection(USERS_COLLECTION)
        .where("UserId", isEqualTo: uid)
        .get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      convesationList.add(UserData.fromMap(data));
    });
    return convesationList;
  }

  Future<UserData?> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return UserData.fromMap(data);
    } catch (e) {
      return null;
    }
  }

  void setUserState({required String? userId, required UserState userState}) {
    int stateNum = UtilityStatus.stateToNum(userState);
    _userCollection.doc(userId).update({
      'Status': stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({required String? uid}) =>
      _userCollection.doc(uid).snapshots();

  Future<bool> authenticateUser(UserCredential user) async {
    QuerySnapshot result = await _userCollection
        .where(EMAIL_FIELD, isEqualTo: user.user!.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
