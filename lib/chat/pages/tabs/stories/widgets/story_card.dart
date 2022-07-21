import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/services/auth_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StoryCard extends StatelessWidget {
  bool isAddStory;
  Widget username;
  Widget profileImage;
  Widget? backgroundUrls;
  VoidCallback? onPressed;

  StoryCard({
    Key? key,
    this.isAddStory = false,
    this.backgroundUrls,
    this.onPressed,
    required this.username,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthFirebase _authFirebase = AuthFirebase();
    final FirebaseAuth auth = FirebaseAuth.instance;
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          isAddStory
              ? ImgContainer(
                  stream:
                      _authFirebase.getUserStream(uid: auth.currentUser!.uid),
                )
              : backgroundUrls!,
          Container(
            height: double.infinity,
            width: 130.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black26],
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          Positioned(
            top: 4.0,
            left: 4.0,
            child: isAddStory
                ? Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: const Icon(
                          Icons.add,
                        ),
                        iconSize: 24,
                        color: Colors.blue,
                        onPressed: onPressed // print('Add Story')
                        ),
                  )
                : profileImage,
          ),
          isAddStory
              ? Positioned(
                  bottom: 8.0,
                  left: 8.0,
                  right: 8.0,
                  child: Text(
                    'Add to Story',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ))
              : Positioned(bottom: 8.0, left: 8.0, right: 8.0, child: username)
        ],
      ),
    );
  }
}

class ImgContainer extends StatelessWidget {
  final stream;
  const ImgContainer({required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? _userData;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.hasData && snapshot.data!.data() != null) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              _userData = UserData.fromMap(data);
            }

            if (_userData!.img == null || _userData.img!.isEmpty) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  width: 130,
                  height: double.infinity,
                  child: Image.asset(
                    'assets/images/account.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: _userData.img!,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            }
          }
          return Text(
            "..",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        });
  }
}

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final bool isActive;
  const Avatar({
    Key? key,
    this.imageUrl,
    this.isActive = false,
    bool hasBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[200],
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
      ),
    );
  }
}
