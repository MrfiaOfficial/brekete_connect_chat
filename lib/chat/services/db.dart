import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_chat/constants/strings.dart';
import 'package:connect_chat/models/media_model.dart';
import 'package:connect_chat/models/message.dart';

class DB {
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection(ALL_MESSAGES_COLLECTION);
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  Stream<DocumentSnapshot> getUserContactsStream(String? uid) {
    return _usersCollection.doc(uid).snapshots();
  }

  Future<DocumentSnapshot> getUser(String? id) {
    return _usersCollection.doc(id).get();
  }

  Future<DocumentSnapshot> addToPeerContacts(
      String? peerId, String? newContact) async {
    // DocumentReference doc;
    DocumentSnapshot docSnapshot;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(peerId);
    try {
      docSnapshot = await documentReference.get();
      var peerContacts = [];
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      data['contacts'].forEach((elem) => peerContacts.add(elem));
      peerContacts.add(newContact);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.get(documentReference);
        transaction.update(documentReference, {'contacts': peerContacts});
      });
    } catch (error) {
      print(
          '****************** DB addToPeerContacts error **********************');
      print(error);
      throw error;
    }

    return docSnapshot;
  }

  void addNewMessage(String? groupId, DateTime timeStamp, dynamic data) {
    try {
      _messagesCollection
          .doc(groupId)
          .collection(CHATS_COLLECTION)
          .doc(timeStamp.millisecondsSinceEpoch.toString())
          .set(data);
    } catch (error) {
      print('****************** DB addNewMessage error **********************');
      print(error);
      throw error;
    }
  }

  Future<QuerySnapshot> getChatItemData(String? userId, [int limit = 20]) {
    try {
      return _messagesCollection
          .doc(userId)
          .collection(CONVERSATION_COLLECTION)
          .orderBy('timeStamp', descending: true)
          .limit(limit)
          .get();
    } catch (error) {
      print(
          '****************** DB getChatItemData error **********************');
      throw error;
    }
  }

  void updateContacts(String userId, dynamic contacts) {
    try {
      _usersCollection
          .doc(userId)
          .set({'contacts': contacts}, SetOptions(merge: true));
    } catch (error) {
      print(
          '****************** DB updateContacts error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getSnapshotsAfter(
      String? groupChatId, DocumentSnapshot? lastSnapshot) {
    try {
      return _messagesCollection
          .doc(groupChatId!)
          .collection(CHATS_COLLECTION)
          .startAfterDocument(lastSnapshot!)
          .orderBy('timeStamp', descending: true)
          .snapshots();
    } catch (error) {
      print(
          '****************** DB getSnapshotsAfter error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getSnapshotsWithLimit(String? groupChatId,
      [int? limit = 10]) {
    try {
      return _messagesCollection
          .doc(groupChatId)
          .collection(CHATS_COLLECTION)
          .limit(limit!)
          .orderBy('timeStamp', descending: true)
          .snapshots();
    } catch (error) {
      print(
          '****************** DB getSnapshotsWithLimit error **********************');
      print(error);
      throw error;
    }
  }

  Future<QuerySnapshot> getNewChats(
      String groupChatId, DocumentSnapshot lastSnapshot,
      [int limit = 20]) {
    try {
      return _messagesCollection
          .doc(groupChatId)
          .collection(CHATS_COLLECTION)
          .startAfterDocument(lastSnapshot)
          .limit(20)
          .orderBy('timeStamp', descending: true)
          .get();
    } catch (error) {
      print(
          '****************** DB getSnapshotsAfter error **********************');
      print(error);
      throw error;
    }
  }

  void addMediaUrl(String? groupId, String? url, Message? mediaMsg) {
    try {
      _messagesCollection
          .doc(groupId)
          .collection(MEDIA_COLLECTION)
          .doc(mediaMsg!.timeStamp)
          .set(MediaModel.fromMsgToMap(mediaMsg));
    } catch (error) {
      print('****************** DB addMediaUrl error **********************');
      print(error);
      throw error;
    }
  }

  void updateMessageField(dynamic snapshot, String? field, dynamic value) {
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        // DocumentSnapshot freshDoc = await transaction.get(snapshot.reference);
        transaction.update(snapshot.reference, {'$field': value});
      });
    } catch (error) {
      print(
          '****************** DB updateMessageField error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getChatMediaStream(String? groupId) {
    try {
      return _messagesCollection
          .doc(groupId)
          .collection(MEDIA_COLLECTION)
          .snapshots();
    } catch (error) {
      print('****************** DB getChatMedia error **********************');
      print(error);
      throw error;
    }
  }

  Stream<QuerySnapshot> getMediaCount(String? groupId) {
    try {
      return _messagesCollection
          .doc(groupId)
          .collection(MEDIA_COLLECTION)
          .snapshots();
    } catch (error) {
      print('****************** DB getMediaCount error **********************');
      print(error);
      throw error;
    }
  }

  void updateUserInfo(String userId, Map<String, dynamic> data) async {
    try {
      _usersCollection.doc(userId).set(data, SetOptions(merge: true));
    } catch (error) {
      print(
          '****************** DB updateUserInfo error **********************');
      print(error);
      throw error;
    }
  }
}
