import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_client/screens/chat.dart';
import 'package:mobile_client/widgets/conversations/coversation_item.dart';
import '../widgets/shared/chat_nav.dart';

class Conversations extends StatefulWidget {
  Conversations();

  @override
  State<StatefulWidget> createState() {
    return _ConversationsState();
  }
}

class _ConversationsState extends State<Conversations> {
  late List<String> convs;

  goToConversation(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Chat();
    }));
  }

  @override
  initState() {
    convs = ["Global"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.all(50),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: convs.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: ConversationItem(
                      title: convs[index],
                      goToConversation: goToConversation,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: ChatNavigation(),
    );
  }
}
