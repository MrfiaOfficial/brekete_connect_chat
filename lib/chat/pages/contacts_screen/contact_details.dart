import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/Widgets/media_view.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/pages/tabs/chat_screen/widget/app_bar.dart';
import 'package:brekete_connect/chat/services/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chat_media_screen.dart';

class ContactDetails extends StatelessWidget {
  final UserData? contact;
  final String? groupId;

  const ContactDetails({Key? key, this.contact, this.groupId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 5),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            leading: CBackButton(),
            title: Text(
              'Contact Info',
              style: TextStyle(
                  color: Theme.of(context).accentColor.withOpacity(0.87),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            color: Theme.of(context).backgroundColor.withOpacity(0.03),
          ),
          width: size.width,
          child: ListView(
            children: [
              _Image(contact: contact),
              _ContactInfo(contact: contact),
              SizedBox(height: 20),
              _ChatInfo(groupId: groupId!),
              SizedBox(height: 20),
              _Actions(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.2)),
          bottom: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.2)),
        ),
      ),
      child: Column(
        children: [
          _ActionsTile(title: 'Share Contact'),
          Divider(
              height: 0,
              color: Theme.of(context).accentColor.withOpacity(0.1),
              indent: 20), // 20 (left padding + icon size)
          _ActionsTile(title: 'Export Chat'),
          Divider(
              height: 0,
              color: Theme.of(context).accentColor.withOpacity(0.1),
              indent: 20), // 20 (left padding + icon size)
          _ActionsTile(title: 'Clear Chat'),
        ],
      ),
    );
  }
}

class _ActionsTile extends StatelessWidget {
  final String? title;
  const _ActionsTile({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Theme.of(context).backgroundColor.withOpacity(0.1),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          width: size.width,
          child: Text(
            title!,
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).accentColor.withOpacity(0.87),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final UserData? contact;
  const _ContactInfo({
    Key? key,
    this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.2)),
          bottom: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _NamedIcons(contact: contact),
          SizedBox(height: 10),
          _About(contact: contact),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ChatInfo extends StatelessWidget {
  final String? groupId;
  const _ChatInfo({
    Key? key,
    @required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.1)),
          bottom: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          _MediaAndLinks(groupId: groupId),
          Divider(
              height: 0,
              color: Theme.of(context).accentColor.withOpacity(0.3),
              indent: 65), // 65 (left padding + icon size)
          _MediaTile(
              icon: Icons.star,
              iconColor: Theme.of(context).backgroundColor.withOpacity(0.4),
              title: 'Starred Messages',
              end: 'None'),
          Divider(
            height: 0,
            color: Theme.of(context).accentColor.withOpacity(0.1),
            indent: 65,
          ),
          _MediaTile(
            icon: Icons.search,
            iconColor: Theme.of(context).backgroundColor.withOpacity(0.1),
            title: 'Chat Search',
            end: '',
          ),
        ],
      ),
    );
  }
}

class _MediaAndLinks extends StatefulWidget {
  final groupId;
  const _MediaAndLinks({
    Key? key,
    this.groupId,
  }) : super(key: key);

  @override
  __MediaAndLinksState createState() => __MediaAndLinksState();
}

class __MediaAndLinksState extends State<_MediaAndLinks> {
  late DB db;
  late Stream<QuerySnapshot> mediaStream;

  @override
  void initState() {
    super.initState();
    db = DB();
    mediaStream = db.getMediaCount(widget.groupId);
  }

  void navToMedia() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatMediaScreen(widget.groupId),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: navToMedia,
        highlightColor: Theme.of(context).backgroundColor.withOpacity(0.1),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.image,
                size: 35,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 10),
              Text(
                'Media, Links, and Docs',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).accentColor.withOpacity(0.9),
                ),
              ),
              Spacer(),
              StreamBuilder(
                stream: mediaStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CupertinoActivityIndicator();
                  else if (snapshot.data!.docs.length == 0)
                    return Text(
                      '0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor.withOpacity(0.9),
                      ),
                    );
                  else
                    return Text(
                      '${snapshot.data!.docs.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor.withOpacity(0.9),
                      ),
                    );
                },
              ),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).accentColor.withOpacity(0.9),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? title;
  final String? end;
  final Function? onTap;
  const _MediaTile({
    Key? key,
    this.icon,
    this.iconColor,
    this.title,
    this.end,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap,
        highlightColor: Theme.of(context).backgroundColor.withOpacity(0.7),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 35,
                color: iconColor,
              ),
              SizedBox(width: 10),
              Text(
                title!,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).accentColor.withOpacity(0.9),
                ),
              ),
              Spacer(),
              Text(end!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                  )),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).accentColor.withOpacity(0.9),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _About extends StatelessWidget {
  final UserData? contact;
  const _About({
    Key? key,
    this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact!.description ?? 'Not Available.',
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).accentColor.withOpacity(0.9)),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _NamedIcons extends StatelessWidget {
  final UserData? contact;
  const _NamedIcons({
    Key? key,
    this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).accentColor.withOpacity(0.7)))),
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      margin: const EdgeInsets.only(
        left: 20,
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact!.username!,
                style: TextStyle(
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Text(
                contact!.email ?? 'No Available',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).accentColor.withOpacity(0.9),
                ),
              ),
            ],
          ),
          Spacer(),
          _Icon(icon: Icons.message, onTap: () => Navigator.of(context).pop()),
          SizedBox(width: 5),
          _Icon(icon: Icons.videocam),
          SizedBox(width: 5),
          _Icon(icon: Icons.call),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  const _Icon({
    Key? key,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor.withOpacity(0.7)),
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final UserData? contact;
  const _Image({
    Key? key,
    required this.contact,
  }) : super(key: key);

  void navToImageView(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MediaView(url: contact!.img, type: MediaType.Photo),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (contact!.img == null || contact!.img == '') {
      return Container(
        width: size.width,
        color: Theme.of(context).accentColor.withOpacity(0.7),
        height: size.height * 0.3,
        child: Icon(
          Icons.person,
          size: size.height * 0.25,
          color: Theme.of(context).accentColor.withOpacity(0.87),
        ),
      );
    }
    return GestureDetector(
      onTap: () => navToImageView(context),
      child: Container(
        width: size.width,
        height: size.height * 0.3,
        child: Hero(
          tag: contact!.img!,
          child: CachedNetworkImage(
            imageUrl: contact!.img!,
            fit: BoxFit.cover,
          ),
        ),
      ),
      // ),
    );
  }
}
