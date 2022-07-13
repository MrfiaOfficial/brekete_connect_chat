import 'package:connect_chat/Widgets/page_header.dart';
import 'package:connect_chat/Widgets/page_profile_image.dart';
import 'package:connect_chat/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget> actions;
  final String? tiltleName;

  const AppBarWidget({
    Key? key,
    this.title,
    required this.actions,
    required this.tiltleName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: (title is String)
          ? Text(
              title!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : CustomPageHeader(
              title: tiltleName!,
              textColor: Theme.of(context).accentColor,
              backgroundColor: Theme.of(context).backgroundColor,
              suffixWidget: PageProfileImage(
                imageUrl: context.watch<UserProvider>().getUser!.img,
                size: 40.0,
                onlineColor: Colors.green,
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            ),
      actions: actions,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 70.0,
      elevation: 0,
      actions: actions,
      title: title,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
