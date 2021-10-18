import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO : smth about this implentation doesn't feel right
// it seems like nav should be static and other parts should move

class ChatNavigation extends StatelessWidget {
  final Map<String, int> screens = {'/': 0, '/settings': 1};
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    currentScreen = screens[ModalRoute.of(context)?.settings.name] ?? 0;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_box), label: "Settings")
      ],
      currentIndex: currentScreen,
      onTap: (int n) {
        // If users haven't pressed button for route they already are using
        String wantedScreen = n < 1 ? '/' : '/settings';
        if (n != currentScreen) {
          Navigator.pushNamed(context, wantedScreen);
        }
      },
    );
  }
}
