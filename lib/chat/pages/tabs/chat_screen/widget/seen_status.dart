import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class SeenStatus extends StatelessWidget {
  final bool? isMe;
  final bool? isSeen;
  final DateTime? timestamp;
  const SeenStatus({
    this.isSeen,
    this.isMe,
    this.timestamp,
    Key? key,
  }) : super(key: key);

  _ago() {
    return timeago.format(timestamp!);
  }

  Widget _buildStatus(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            _ago(),
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).accentColor.withOpacity(0.6),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        if (isMe!)
          Icon(
            Icons.done_all,
            color: isSeen!
                ? Color(0xFF4bd8a4)
                : Theme.of(context).accentColor.withOpacity(0.35),
            size: 18,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _buildStatus(context),
    );
  }
}
