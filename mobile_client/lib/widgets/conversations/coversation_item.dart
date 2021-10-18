import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final String title;
  final Function(String) goToConversation;

  ConversationItem({required this.title, required this.goToConversation});

  @override
  Widget build(BuildContext context) {
    return (OutlinedButton(
      child: Text(title),
      onPressed: () => goToConversation(title),
    ));
  }
}
