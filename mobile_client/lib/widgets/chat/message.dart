import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../dto/message.dart';

class Message extends StatelessWidget {
  MessageDTO msg;
  CrossAxisAlignment crossAxisAlignment;
  Color? color;
  //static DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  static DateFormat dateFormat = DateFormat("HH:mm");

  Message({required this.msg})
      : crossAxisAlignment =
            (msg.sent! ? CrossAxisAlignment.end : CrossAxisAlignment.start),
        color = (msg.sent! ? Colors.indigo[400] : Colors.red[400]);
  // no idea on how to change color with theme(i need access to primarySwatch)

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          child: Text(msg.sender),
          padding: EdgeInsets.all(4),
        ),
        Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(9)),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(
                  msg.content,
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  dateFormat.format(msg.timeSent),
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ))
      ],
    ));
  }
}
