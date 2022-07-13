import 'dart:io';
import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_chat/configs/giphy_apiKey.dart';
import 'package:connect_chat/models/ChatData.dart';
import 'package:connect_chat/models/reply_message.dart';
import 'package:connect_chat/models/user_model.dart';
import 'package:connect_chat/pages/callScreen/pickup/pickup_layout.dart';
import 'package:connect_chat/pages/tabs/calls/widget/custom_title.dart';
import 'package:connect_chat/constants/strings.dart';
import 'package:connect_chat/models/message.dart';
import 'package:connect_chat/pages/tabs/chat_screen/widget/selected_media_preview.dart';
import 'package:connect_chat/providers/chat.dart';
import 'package:connect_chat/services/auth_firebase.dart';
import 'package:connect_chat/services/db.dart';
import 'package:connect_chat/utility/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:giphy_get/giphy_get.dart';

import 'widget/app_bar.dart';
import 'widget/chat_bubble.dart';
import 'widget/media_uploading_bubble.dart';
import 'widget/reply_message_preview.dart';

enum LoaderStatus {
  STABLE,
  LOADING,
}

class ChatScreen extends StatefulWidget {
  final ChatData chatData;
  ChatScreen({Key? key, required this.chatData});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _textFieldFocusNode = FocusNode();
  GlobalKey textFieldKey = GlobalKey();
  final DB db = DB();
  LoaderStatus loaderStatus = LoaderStatus.STABLE;
  // keep track of last fetched message to get messages only after this message
  DocumentSnapshot? lastSnapshot;
  final AuthFirebase _authFirebase = AuthFirebase();

  bool isWriting = false;
  bool showEmojiPicker = false;
  bool isFetchingNewChats = false;
  Message? msgToReply;
  Message? mediaMsg;

  late GiphyGif currentGif;

  // Giphy Client
  late GiphyClient client;
  late File _selectedMedia;

  // Random ID
  String? randomId = "";
  late FocusNode bodyFocusNode;

  late ScrollController _scrollController;

  String? _extensionfile;
  String? _fileName;
  String? _fileSize;
  UserData? receiver;
  UserData? sender;
  String? userId;
  String? peerId;
  String? groupChatId;

  // for handling media selection
  MediaType? pickedMediaType;
  bool _mediaSelected = false;
  bool replied = false;

  @override
  void initState() {
    super.initState();
    print('initcalled =============');
    _textEditingController = TextEditingController();
    bodyFocusNode = FocusNode();
    _textFieldFocusNode = FocusNode();
    _scrollController = ScrollController();
    _selectedMedia = File('');
    client = GiphyClient(apiKey: GIPHY_API_KEY!, randomId: '');
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      client.getRandomId().then((value) {
        setState(() {
          randomId = value;
        });
      });
    });
    // get user and chat details
    userId = widget.chatData.userId;
    peerId = widget.chatData.peerId;
    groupChatId = widget.chatData.groupId;
    initDataSender();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void initDataSender() async {
    UserData? userData = await _authFirebase.getUserDetails();
    setState(() {
      sender = UserData(
        userId: userData.userId,
        username: userData.username,
        img: userData.img,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    bodyFocusNode.dispose();
    super.dispose();
  }

  void onMessageSend(String? content, MessageType? type,
      {MediaType? mediaType, ReplyMessage? replyDetails}) async {
    // clear text field
    if (content != '') _textEditingController.clear();
    // create timestamp
    DateTime time = DateTime.now();
    final newMessage = Message(
      content: content,
      fromId: userId,
      toId: peerId,
      sendDate: time,
      timeStamp: time.millisecondsSinceEpoch.toString(),
      isSeen: false,
      type: type,
      mediaType: mediaType,
      mediaUrl: null,
      uploadFinished: false,
      reply: replyDetails,
    );
    // add message to messages list
    widget.chatData.messages.insert(0, newMessage);
    // set media message
    if (type == MessageType.Media) mediaMsg = newMessage;
    // add message to database only if its text message
    // media message should be added after uploading and getting its media url
    if (type == MessageType.Text) {
      db.addNewMessage(
        groupChatId!,
        time,
        Message.toMap(newMessage),
      );
    }

    final userContacts = Provider.of<Chat>(context, listen: false).getContacts;
    // add user to contacts if not already in contacts
    if (!userContacts.contains(peerId!)) {
      Provider.of<Chat>(context, listen: false).addToContacts(peerId!);
      db.updateContacts(userId!, userContacts);
      // add to peer contacts too
      var userRef = await db.addToPeerContacts(peerId!, userId!);
      Map<String, dynamic> data = userRef.data()! as Map<String, dynamic>;
      UserData person = UserData.fromMap(data);
      ChatData initChatData = ChatData(
        userId: userId,
        peerId: peerId,
        groupId: groupChatId,
        peer: person,
        messages: [newMessage],
      );
      Provider.of<Chat>(context, listen: false).addToInitChats(initChatData);
    } else {
      Provider.of<Chat>(context, listen: false).bringChatToTop(groupChatId!);
    }
  }

  void _onUploadFinished(String? url) {
    if (mediaMsg != null) {
      var msg = widget.chatData.messages.firstWhere(
        (elem) => elem.sendDate == mediaMsg!.sendDate,
      );
      if (msg != null) {
        msg.mediaUrl = url;
        msg.uploadFinished = true;
        final time = DateTime.now();
        if (mediaMsg!.mediaType == MediaType.File) {
          msg.fileName = _fileName;
          msg.extensionfile = _extensionfile;
          msg.fileSize = _fileSize;
        }
        // add message to database after grabbing it's media url
        db.addNewMessage(
          groupChatId,
          time,
          Message.toMap(msg),
        );
        db.addMediaUrl(groupChatId, url, mediaMsg);
      }
    }
  }

  void _onUploadgiphy(String? url) {
    DateTime time = DateTime.now();
    final newMessage = Message(
      content: '',
      fromId: userId,
      toId: peerId,
      sendDate: time,
      timeStamp: time.millisecondsSinceEpoch.toString(),
      isSeen: false,
      type: MessageType.Media,
      mediaType: MediaType.Photo,
      mediaUrl: url,
      uploadFinished: true,
      reply: null,
    );
    widget.chatData.messages.insert(0, newMessage);
    // add message to database after grabbing it's media url
    db.addNewMessage(
      groupChatId!,
      time,
      Message.toMap(newMessage),
    );
  }

  void onReplied(Message msg) async {
    _textFieldFocusNode.requestFocus();
    msgToReply = msg;
    replied = true;
    textFieldKey.currentState!.setState(() {});
  }

  void onSend(String? msgContent,
      {MessageType? type, MediaType? mediaType, ReplyMessage? replyDetails}) {
    // if not media is not selected add new message as text message
    if (type == MessageType.Text) {
      if (msgContent!.isEmpty) return;
      _textEditingController.clear();
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      // send new message
      onMessageSend(msgContent, MessageType.Text, replyDetails: replyDetails);
    } else {
      if (msgContent!.trim().isEmpty) msgContent = null;
      onMessageSend(msgContent, MessageType.Media,
          mediaType: mediaType, replyDetails: replyDetails);
      setState(() {
        _mediaSelected = false;
      });
    }
    if (replyDetails != null) {
      replied = false;
      msgToReply = null;
    }
    FocusScope.of(context).requestFocus(_textFieldFocusNode);
  }

  Stream<QuerySnapshot> stream() {
    var snapshots;
    if (lastSnapshot != null) {
      // lastSnapshot is set as the last message recieved or sent
      // if it is set(users interacted) fetch only messages added after this message
      snapshots = db.getSnapshotsAfter(groupChatId!, lastSnapshot!);
    } else {
      // otherwise fetch a limited number of messages(10)
      snapshots = db.getSnapshotsWithLimit(groupChatId!, 10);
    }
    return snapshots;
  }

  void getOptionAttach() {
    // Hide keyboard when sticker appear
    _textFieldFocusNode.unfocus();
    setState(() {
      showEmojiPicker = false;
    });
  }

  showKeyboard() => _textFieldFocusNode.requestFocus();

  // this help to hide the keyboard
  hideKeyboard() => _textFieldFocusNode.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = !showEmojiPicker;
    });
  }

  // updates seen status of peer messages
  void handleSeenStatusUpdateWhenFromPeer() {
    int index = -1;
    for (int i = 0; i < widget.chatData.messages.length; i++) {
      final item = widget.chatData.messages[i];
      if (i == widget.chatData.messages.length - 1) {
        index = i;
        break;
      } else {
        if (item.fromId == userId && item.isSeen) {
          index = i;
          break;
        }
      }
    }
    if (index != -1)
      for (int i = index; i >= 0; i--)
        widget.chatData.messages[i].isSeen = true;
  }

  void handleSeenStatusWhenFromMe(Message? newMsg) {
    int index = -1;
    for (int i = 0; i < widget.chatData.messages.length; i++) {
      if (i == widget.chatData.messages.length - 1) {
        index = i;
        break;
      } else {
        if (widget.chatData.messages[i].fromId == userId &&
            widget.chatData.messages[i].isSeen) {
          index = i;
          break;
        }
      }
    }
    if (index != -1) {
      bool s =
          newMsg!.sendDate!.isAfter(widget.chatData.messages[index].sendDate);

      if (s && newMsg.isSeen!)
        for (int i = index; i >= 0; i--)
          if (widget.chatData.messages[i].fromId == userId)
            widget.chatData.messages[i].isSeen = true;
    }
  }

  void addNewMessages(AsyncSnapshot<QuerySnapshot> snapshots) {
    if (snapshots.hasData) {
      int length = snapshots.data!.docs.length;
      print(length);
      if (length != 0) {
        // set lastSnapshot to last message fetched to later use
        // for fetching new messages only after this snapshot
        lastSnapshot = snapshots.data!.docs[length - 1];
      }
      // TODO fix seen update if from last snapshot***
      for (int i = 0; i < snapshots.data!.docs.length; i++) {
        final snapshot = snapshots.data!.docs[i];
        Map<String, dynamic> dataMessage =
            snapshot.data()! as Map<String, dynamic>;
        print(dataMessage);
        Future.doWhile(() {
          Message? newMsg = Message.fromMap(dataMessage);
          if (widget.chatData.messages.isNotEmpty) {
            // add message to the list only if it's after the first item in the list
            if (newMsg.sendDate!
                .isAfter(widget.chatData.messages[0].sendDate)) {
              widget.chatData.messages.insert(0, newMsg);
              // // play notification sound
              // Utils.playSound('mp3/newMessage.mp3');
              // if message is from peer update seen status of all unseen messages
              if (newMsg.fromId == peerId) {
                handleSeenStatusUpdateWhenFromPeer();
              }
            } else {
              // if new snapshot is a message from this user, find the last seen message index
              if (newMsg.fromId == userId && newMsg.isSeen!) {
                handleSeenStatusWhenFromMe(newMsg);
              }
              // }
            }
          }
          return false;
        }).then((value) {
          // Update isSeen of the message only if message is from peer
          if (snapshot['fromId'] == peerId && !snapshot['isSeen']) {
            db.updateMessageField(snapshot, 'isSeen', true);
          }
        });
      }
    }
  }

  bool _onNotification(Notification? notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels >=
          notification.metrics.maxScrollExtent - 40) {
        if (loaderStatus == LoaderStatus.STABLE) {
          loaderStatus = LoaderStatus.LOADING;
          Stream.fromFuture(widget.chatData.fetchNewChats().then(
            (_) {
              loaderStatus = LoaderStatus.STABLE;
              setState(() {
                isFetchingNewChats = false;
              });
            },
          ));
        }
      }
    }
    return true;
  }

  void _openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'xls',
        'pdf',
        'txt',
        'doc',
        'xlsx',
        'pps',
      ],
    );
    if (result != null) {
      PlatformFile files = result.files.first;
      File file = File(result.files.single.path!);
      setState(() {
        pickedMediaType = MediaType.File;
        _selectedMedia = file;
        _mediaSelected = true;
        _fileName = files.name.toString();
        _extensionfile = files.extension.toString();
        _fileSize = files.size.toString();
        Navigator.maybePop(context);
      });
      onSend(
        '',
        type: MessageType.Media,
        mediaType: pickedMediaType,
        replyDetails: null,
      );
    } else {
      Flushbar(
        message: "No file selected.",
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.black,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PreferredSize(
              preferredSize: _mediaSelected
                  ? Size.fromHeight(0)
                  : Size.fromHeight(kToolbarHeight),
              child: MyAppBar(
                peer: widget.chatData.peer,
                groupId: widget.chatData.groupId,
                sender: sender,
              )),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(bodyFocusNode);
            },
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Stack(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: stream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        addNewMessages(snapshot);
                        return LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            children: [
                              Flexible(
                                child: _Messages(
                                  scrollController: _scrollController,
                                  chatData: widget.chatData,
                                  onNotification: _onNotification,
                                  selectedMedia: _selectedMedia,
                                  onReplied: onReplied,
                                  onUploadFinished: _onUploadFinished,
                                  extensionfile: _extensionfile,
                                  fileName: _fileName,
                                  fileSize: _fileSize,
                                ),
                              ),
                              _buildTextInputField(),
                              (showEmojiPicker
                                  ? Container(
                                      height: 250,
                                      child: emojiContainer(),
                                    )
                                  : Container()),
                            ],
                          );
                        });
                      }),
                  Positioned(
                    right: 0,
                    bottom: 150,
                    child: _ToBottom(controller: _scrollController),
                  ),
                  if (_mediaSelected && pickedMediaType != MediaType.File)
                    SelectedMediaPreview(
                      file: _selectedMedia,
                      onClosed: () => setState(() => _mediaSelected = false),
                      onSend: onSend,
                      textEditingController: _textEditingController,
                      pickedMediaType: pickedMediaType,
                    ),
                ],
              ),
            ),
          )),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        // Do something when emoji is tapped
        setState(() {
          isWriting = true;
        });

        _textEditingController.text = _textEditingController.text + emoji.emoji;
      },
      onBackspacePressed: () {
        // Backspace-Button tapped logic
        // Remove this line to also remove the button in the UI
      },
      config: Config(
          columns: 7,
          emojiSizeMax: 32.0,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.RECENT,
          bgColor: Theme.of(context).backgroundColor,
          indicatorColor: Theme.of(context).dividerColor,
          iconColor: Colors.grey,
          iconColorSelected: Theme.of(context).dividerColor,
          progressIndicatorColor: Theme.of(context).dividerColor,
          backspaceColor: Theme.of(context).dividerColor,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecents: Text("No Recents"),
          //noRecentsStyle: const TextStyle(fontSize: 20, color: Colors.black26),
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL),
    );
  }

  giphyContainer() async {
    GiphyGif? gif = await GiphyGet.getGif(
      context: context, //Required
      apiKey: GIPHY_API_KEY!, //Required.
      lang: GiphyLanguage.english, //Optional - Language for query.
      randomID: randomId!, // Optional - An ID/proxy for a specific user.
      searchText: "Search GIPHY", //Optional - AppBar search hint text.
      tabColor: Colors.teal, // Optional- default accent color.
    );
    if (gif != null) {
      _onUploadgiphy(gif.images!.original!.url);
    }
  }

  Widget _buildTextInputField() {
    return StatefulBuilder(
        key: textFieldKey,
        builder: (ctx, thisState) {
          setWritingTo(bool val) {
            setState(() {
              isWriting = val;
            });
          }

          bool reply = false;
          Message? repliedMessage;
          // update state when message is being replied
          thisState(() {
            reply = replied;
            repliedMessage = msgToReply;
          });

          send() {
            ReplyMessage? replyDetails;
            if (repliedMessage != null) {
              replyDetails = ReplyMessage();
              replyDetails.replierId = userId;
              replyDetails.repliedToId = repliedMessage!.fromId;
              if (repliedMessage!.type == MessageType.Text)
                replyDetails.content = repliedMessage!.content;
              else
                replyDetails.content = repliedMessage!.mediaUrl;
              replyDetails.type = repliedMessage?.type;
            }
            onSend(_textEditingController.text,
                type: MessageType.Text, replyDetails: replyDetails);

            // reset state
            thisState(() {
              reply = false;
              repliedMessage = null;
            });
          }

          addMediaModal(context) {
            //  showKeyboard();
            hideEmojiContainer();
            showModalBottomSheet(
                context: context,
                elevation: 0,
                backgroundColor: Theme.of(context).backgroundColor,
                builder: (context) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: <Widget>[
                            TextButton(
                              child: Icon(
                                Icons.close,
                              ),
                              onPressed: () => Navigator.maybePop(context),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Content and tools",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ListView(
                          children: <Widget>[
                            ModalTile(
                              title: "Media",
                              subtitle: "Share Photos from gallery",
                              icon: Icons.image,
                              onTap: () =>
                                  pickImage(source: ImageSource.gallery),
                            ),
                            ModalTile(
                              title: "File",
                              subtitle: "Share files",
                              icon: Icons.tab,
                              onTap: () => _openFile(),
                            ),
                            ModalTile(
                              title: "Video",
                              subtitle: "Share Video",
                              icon: Icons.videocam_outlined,
                              onTap: () =>
                                  pickVideo(source: ImageSource.gallery),
                            ),
                            ModalTile(
                              title: "Location",
                              subtitle: "Share a location",
                              icon: Icons.add_location,
                              onTap: () {},
                            ),
                            ModalTile(
                              title: "Contact",
                              subtitle: "Share contacts",
                              icon: Icons.contacts,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          }

          Widget _buildReplyMessage() {
            return AnimatedContainer(
              padding: const EdgeInsets.only(left: 20),
              duration: Duration(milliseconds: 200),
              height: reply ? 70 : 0,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: reply
                      ? BorderSide(
                          color: Theme.of(context).accentColor.withOpacity(0.2))
                      : BorderSide(color: Colors.transparent),
                ),
              ),
              child: replied
                  ? ReplyMessagePreview(
                      onCanceled: () => thisState(() {
                        replied = false;
                        repliedMessage = null;
                        reply = false;
                        msgToReply = null;
                      }),
                      repliedMessage: repliedMessage,
                      peerName: widget.chatData.peer.username,
                      reply: reply,
                      userId: userId,
                    )
                  : Container(width: 0, height: 0),
            );
          }

          return Container(
            decoration: BoxDecoration(
              // color: kBlackColor2,
              // border: Border.all(color: kBorderColor3),
              borderRadius: reply
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    )
                  : BorderRadius.circular(25),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                _buildReplyMessage(),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () => addMediaModal(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        splashColor:
                            Theme.of(context).accentColor.withOpacity(0.1),
                        highlightColor:
                            Theme.of(context).accentColor.withOpacity(0.1),
                        onPressed: () {
                          if (!showEmojiPicker) {
                            // keyboard is visible
                            hideKeyboard();
                            showEmojiContainer();
                          } else {
                            //keyboard is hidden
                            showKeyboard();
                            hideEmojiContainer();
                          }
                        },
                        icon: Icon(
                          showEmojiPicker
                              ? Icons.keyboard
                              : Icons.face_outlined,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(left: 8, right: 5),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                              maxLines: 4,
                              minLines: 1,
                              onChanged: (val) {
                                (val.length > 0 && val.trim() != "")
                                    ? setWritingTo(true)
                                    : setWritingTo(false);
                              },
                              onTap: () {
                                setState(() {
                                  showEmojiPicker = false;
                                  // isShowOptionAttach = false;
                                });
                              },
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).accentColor,
                              ),
                              controller: _textEditingController,
                              focusNode: _textFieldFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              cursorColor: Theme.of(context).accentColor,
                              keyboardAppearance: Brightness.dark,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              onSubmitted: (_) {}),
                        ),
                      ),
                      isWriting
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                  child: Container(
                                    child: Icon(
                                      Icons.gif,
                                      size: 30,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  onTap: () => giphyContainer()),
                            ),
                      isWriting
                          ? Container()
                          : GestureDetector(
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).accentColor,
                              ),
                              onTap: () =>
                                  pickImage(source: ImageSource.camera)),
                      isWriting
                          ? Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.1)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 24,
                                  color: Theme.of(context).accentColor,
                                ),
                                onPressed: () => send(),
                              ))
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future pickImage({required ImageSource? source}) async {
    var pickedFile = await Utils.pickedImage(context, source);
    if (pickedFile != null) {
      setState(() {
        pickedMediaType = MediaType.Photo;
        _selectedMedia = File(pickedFile.path);
        _mediaSelected = true;
        Navigator.maybePop(context);
      });
    } else {
      Flushbar(
        message: 'No image selected.',
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.black,
      )..show(context);
    }
  }

  Future pickVideo({required ImageSource? source}) async {
    var pickedFile = await Utils.pickedVideo(context, source);
    if (pickedFile != null) {
      setState(() {
        pickedMediaType = MediaType.Video;
        _selectedMedia = File(pickedFile.path);
        _mediaSelected = true;
        Navigator.maybePop(context);
      });
    } else {
      Flushbar(
        message: 'No video selected.',
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.black,
      )..show(context);
    }
  }
}

class _ToBottom extends StatefulWidget {
  final ScrollController controller;
  const _ToBottom({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  __ToBottomState createState() => __ToBottomState();
}

class __ToBottomState extends State<_ToBottom> {
  bool reachedThereshold = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (widget.controller.position.pixels >= 600) {
        if (!reachedThereshold) {
          setState(() {
            reachedThereshold = true;
          });
        }
      }
      if (widget.controller.position.pixels < 600) {
        if (reachedThereshold) {
          setState(() {
            reachedThereshold = false;
          });
        }
      }
    });
  }

  void onTap() {
    widget.controller.animateTo(widget.controller.position.minScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  Widget _buildIcon() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: CupertinoButton(
        color: Colors.transparent,
        padding: const EdgeInsets.all(0),
        onPressed: onTap,
        child: Container(
          child: Icon(Icons.arrow_drop_down_outlined,
              size: 20, color: Theme.of(context).backgroundColor),
          // padding: const EdgeInsets.all(3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return reachedThereshold ? _buildIcon() : Container(height: 0, width: 0);
  }
}

class ModalTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ModalTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onLongPress: () {},
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).backgroundColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Theme.of(context).accentColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle!,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _Messages extends StatelessWidget {
  final ScrollController scrollController;
  final ChatData chatData;
  final NotificationListenerCallback? onNotification;
  final File? selectedMedia;
  final Function onUploadFinished;
  final Function? onReplied;
  final String? extensionfile;
  final String? fileName;
  final String? fileSize;

  const _Messages({
    Key? key,
    required ScrollController scrollController,
    required this.chatData,
    required this.onNotification,
    this.fileName,
    this.extensionfile,
    this.fileSize,
    this.selectedMedia,
    required this.onUploadFinished,
    required this.onReplied,
  })  : scrollController = scrollController,
        super(key: key);

  Widget _buildMessageItem(Message? message, bool withoutAvatar, bool last,
      bool first, bool isMiddle) {
    if (message!.type == MessageType.Media) {
      if (message.mediaUrl == null || !message.uploadFinished!)
        return MediaUploadingBubble(
          groupId: chatData.groupId!,
          file: selectedMedia!,
          time: message.sendDate!,
          onUploadFinished: onUploadFinished,
          message: message,
          mediaType: message.mediaType!,
          fileName: fileName,
          extensionfile: extensionfile,
          fileSize: fileSize,
        );
      else
        return ChatBubble(
          message: message,
          isMe: message.fromId == chatData.userId,
          peer: chatData.peer,
          withoutAvatar: withoutAvatar,
          onReply: onReplied,
        );
    }
    return ChatBubble(
      message: message,
      isMe: message.fromId == chatData.userId,
      peer: chatData.peer,
      withoutAvatar: withoutAvatar,
      onReply: onReplied,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification!,
      child: ListView.separated(
        addAutomaticKeepAlives: true,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        reverse: true,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        itemCount: chatData.messages.length,
        itemBuilder: (ctx, i) {
          int? length = chatData.messages.length;
          return _buildMessageItem(
              chatData.messages[i],
              ChatOps.withoutAvatar(
                  i, length, chatData.messages, chatData.peerId!),
              ChatOps.isLast(i, length, chatData.messages),
              ChatOps.isFirst(i, length, chatData.messages),
              ChatOps.isMiddle(i, length, chatData.messages));
        },
        separatorBuilder: (_, i) {
          final msgs = chatData.messages;
          int length = msgs.length;
          if ((i != length && msgs[i].fromId != msgs[i + 1].fromId) ||
              msgs[i].reply != null) return SizedBox(height: 15);
          return SizedBox(height: 5);
        },
      ),
    );
  }
}

class ChatOps {
  // show peer avatar only once in a series of nessages
  static bool withoutAvatar(
      int i, int length, List<dynamic> messages, String? peerId) {
    bool c1 = i != 0 && messages[i - 1].fromId == peerId;
    bool c2 = i != 0 && messages[i - 1].type != MessageType.Media;
    return c1 && c2;
  }

  // for adding border radius to all sides except for bottomRight/bottomLeft
  // if last message in a series from same user
  static bool isLast(int i, int length, List<dynamic> messages) {
    bool c1 = i != 0 && messages[i - 1].fromId == messages[i].fromId;
    bool c2 = i != 0 && messages[i - 1].type != MessageType.Media;
    return i == length - 1 || c1 && c2;
  }

  // for adding border radius to only topLeft/bottomLeft or topRight/bottomRight
  // if message is in the series of messages of one user
  static bool isMiddle(int i, int length, List<dynamic> messages) {
    bool c1 = i != 0 && messages[i - 1].fromId == messages[i].fromId;
    bool c2 = i != length - 1 && messages[i + 1].fromId == messages[i].fromId;
    return c1 && c2;
  }

  // opposite of isLast
  static bool isFirst(int i, int length, List<dynamic> messages) {
    bool c1 = i != 0 && messages[i - 1].fromId != messages[i].fromId;
    bool c2 = i != length - 1 && messages[i + 1].fromId == messages[i].fromId;
    return i == 0 || (c1 && c2);
  }
}
