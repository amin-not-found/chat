import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mobile_client/models/room.dart';
import 'package:mobile_client/screens/chat.dart';
import 'package:mobile_client/widgets/conversations/conversation_list.dart';
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

  Stream<List<Room>> convsQuery() {
    if (!GetIt.I.isRegistered<IsarCollection<Room>>()) {
      return Stream.empty();
    }
    return GetIt.I<IsarCollection<Room>>()
        .where()
        .build()
        .watch(initialReturn: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.all(50),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: convsQuery(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ConversationList(
                        convs: snapshot.data as List<Room>,
                        goToConversation: goToConversation,
                      );
                    }
                    return CircularProgressIndicator();
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: ChatNavigation(),
    );
  }
}
