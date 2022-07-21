import 'package:brekete_connect/chat/models/ChatData.dart';
import 'package:brekete_connect/chat/models/message.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Chat with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // AuthFirebase _authMethods = AuthFirebase();

  final db = DB();

  List<ChatData> _chats = [];
  List<String> _contacts = [];

  String? _userId;
  UserData? _userDetails;

  bool _isLoading = true;

  bool get isLoading {
    return _isLoading;
  }

  List<ChatData> get chats {
    return _chats;
  }

  UserData? get userDetails {
    return _userDetails;
  }

  String? get getUserId {
    return _userId;
  }

  List<dynamic> get getContacts {
    return _contacts;
  }

  String? getGroupId(String contact) {
    String groupId;
    if (_userId.hashCode <= contact.hashCode)
      groupId = '$_userId-$contact';
    else
      groupId = '$contact-$_userId';

    return groupId;
  }

  Future<dynamic> getUserDetailsAndContacts() async {
    // UserData? userData = await _authMethods.getUserDetails();
    final userData = await db.getUser(_auth.currentUser!.uid);
    Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
    _userId = _auth.currentUser!.uid;
    _userDetails = UserData.fromJson(data);
    data['contacts'].forEach((elem) {
      _contacts.add(elem);
    });
    notifyListeners();
    return true;
  }

  Future<ChatData> getChatData(String? peerId) async {
    String? groupId = getGroupId(peerId!);
    final peer = await db.getUser(peerId);
    Map<String, dynamic> data = peer.data() as Map<String, dynamic>;
    final UserData? person = UserData.fromJson(data);
    final messagesData = await db.getChatItemData(groupId!);

    int unreadCount = 0;
    List<Message> messages = [];
    messagesData.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var tmp = Message.fromMap(data);
      print(tmp);
      messages.add(tmp);
      if (tmp.fromId == peerId && !tmp.isSeen!) unreadCount++;
    });
    var lastDoc;
    if (messagesData.docs.isNotEmpty)
      lastDoc = messagesData.docs[messagesData.docs.length - 1];
    ChatData chatData = ChatData(
      userId: userDetails!.userId,
      peerId: person!.userId,
      groupId: groupId,
      peer: person,
      messages: messages,
      lastDoc: lastDoc,
      unreadCount: unreadCount,
    );
    print(chatData);
    return chatData;
  }

  Future<bool> fetchChats() async {
    _isLoading = true;
    _chats.clear();
    Future.forEach(_contacts, (contact) async {
      final chatData = await getChatData(contact.toString());
      _chats.add(chatData);
    }).then((_) {
      _isLoading = false;
      notifyListeners();
    });
    return true;
  }

  void clear() {
    _isLoading = false;
    _chats.clear();
    notifyListeners();
  }

  // updates the order of chats when a new message is recieved
  void bringChatToTop(String groupId) {
    if (_chats.isNotEmpty && _chats[0].groupId != groupId) {
      // bring latest interacted contact and chat to top
      var ids = groupId.split('-');
      var peerId = ids.firstWhere((element) => element != _userId);

      var cIndex = _contacts.indexWhere((element) => element == peerId);
      _contacts.removeAt(cIndex);
      _contacts.insert(0, peerId);

      db.updateUserInfo(_userId!, {'contacts': _contacts});

      var index = _chats.indexWhere((element) => element.groupId == groupId);
      var temp = _chats[index];
      _chats.removeAt(index);
      _chats.insert(0, temp);
      notifyListeners();
    }
  }

  void addToInitChats(ChatData chatData) {
    if (_chats.contains(chatData)) return;
    _chats.insert(0, chatData);
    notifyListeners();
  }

  void addToContacts(String? uid) {
    _contacts.add(uid!);
    notifyListeners();
  }

  void handleMessagesNotFromContacts(List<dynamic> newContacts) async {
    if (newContacts.length > _contacts.length) {
      for (int i = _contacts.length; i < newContacts.length; ++i) {
        final chatData = await getChatData(newContacts[i]);
        _chats.insert(0, chatData);
        _contacts.insert(0, newContacts[i]);
      }
      notifyListeners();
      db.updateContacts(userDetails!.userId!, _contacts);
    }
  }
}
