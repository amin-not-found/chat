import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mobile_client/models/room.dart';
import 'package:mobile_client/widgets/conversations/coversation_item.dart';

class ConversationList extends StatelessWidget {
  final List<Room> convs;
  final Function(String) goToConversation;

  ConversationList({required this.convs, required this.goToConversation}) {
    if (convs.isEmpty) {
      manageEmptyRoomList();
    }
  }
  manageEmptyRoomList() async {
    // TODO : change default behavior when room list is empty
    Room defaultRoom = Room.createToom(name: "Gloabl");
    var isar = GetIt.I<Isar>();
    var rooms = GetIt.I<IsarCollection<Room>>();
    await isar.writeTxn((isar) async => await rooms.put(defaultRoom));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: convs.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: ConversationItem(
            title: convs[index].name,
            goToConversation: goToConversation,
          ),
        );
      },
    );
  }
}
