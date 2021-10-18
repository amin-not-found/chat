import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  final Function(String) updateText;
  final Function() sendMessage;
  final TextEditingController textController;
  ChatBox({
    required this.updateText,
    required this.sendMessage,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          decoration: InputDecoration(hintText: "Type a message"),
          autofocus: true,
          onChanged: updateText,
          controller: textController,
          maxLines: null,
        )),
        FloatingActionButton(
          onPressed: sendMessage,
          child: Icon(Icons.send),
        )
      ],
    );
  }
}
