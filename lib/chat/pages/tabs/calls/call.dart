import 'package:connect_chat/Widgets/page_header.dart';
import 'package:connect_chat/Widgets/page_profile_image.dart';
import 'package:connect_chat/Widgets/pop_box.dart';
import 'package:connect_chat/constants/strings.dart';
import 'package:connect_chat/database/repository/log_repository.dart';
import 'package:connect_chat/models/log.dart';
import 'package:connect_chat/pages/profile/profile.dart';
import 'package:connect_chat/pages/tabs/chats/widget/cached_image.dart';
import 'package:connect_chat/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'widget/custom_title.dart';

class CallPage extends StatefulWidget {
  CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  _ago(DateTime t) {
    return timeago.format(t);
  }

  getIcon(String? callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Color(0xFF4bd8a4),
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  getIconStatus(String? callStatus) {
    Icon _icon;
    double _iconSize = 25;
    switch (callStatus) {
      case CALL_STATUS_VIDEO:
        _icon = Icon(
          Icons.video_call,
          size: _iconSize,
          color: Color(0xFF4bd8a4),
        );
        break;

      case CALL_STATUS_AUDIO:
        _icon = Icon(
          Icons.call,
          color: Color(0xFF4bd8a4),
          size: _iconSize,
        );
        break;
      default:
        _icon = Icon(
          Icons.call,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.transparent,
        toolbarHeight: 70.0,
        elevation: 0,
        title: CustomPageHeader(
          title: "Calls",
          suffixWidget: PageProfileImage(
            imageUrl: context.watch<UserProvider>().getUser!.img,
            size: 40.0,
            onlineColor: Color(0xFF4bd8a4),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProfilePage()));
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: FutureBuilder<dynamic>(
              future: LogRepository.getLogs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  List<dynamic> logList = snapshot.data;
                  if (logList.isNotEmpty) {
                    return ListView.builder(
                        itemCount: logList.length,
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          Log _log = logList[i];
                          bool hasDialled =
                              _log.callStatus == CALL_STATUS_DIALLED;
                          return CustomTile(
                            leading: CachedImage(
                              hasDialled ? _log.receiverPic : _log.callerPic,
                              isRound: true,
                              radius: 45,
                            ),
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete this Log?"),
                                content: Text(
                                    "Are you sure you wish to delete this log?"),
                                actions: [
                                  // ignore: deprecated_member_use
                                  FlatButton(
                                    child: Text("YES"),
                                    onPressed: () async {
                                      Navigator.maybePop(context);
                                      await LogRepository.deleteLogs(i);
                                    },
                                  ),
                                  // ignore: deprecated_member_use
                                  FlatButton(
                                    child: Text("NO"),
                                    onPressed: () =>
                                        Navigator.maybePop(context),
                                  ),
                                ],
                              ),
                            ),
                            mini: false,
                            title: Text(
                              hasDialled
                                  ? _log.receiverName.toString()
                                  : _log.callerName.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            icon: getIcon(_log.callStatus),
                            subtitle: Text(
                              (_ago(_log.timestamp!)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            trailing: getIconStatus(_log.status),
                          );
                        });
                  }
                  return PopBox(
                    heading: "All call logs are listed here?",
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
