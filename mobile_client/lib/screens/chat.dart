import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mobile_client/dto/message.dart';
import 'package:mobile_client/utils/messages/message_handler.dart';
import 'package:mobile_client/widgets/chat/chat_box.dart';
import 'package:mobile_client/widgets/chat/message.dart';

class Chat extends StatefulWidget {
  late final Isar db;
  Chat() : db = GetIt.I<Isar>();

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<Chat> {
  List<MessageDTO> messages = [];
  String username = "";
  String text = "";

  late MessageHandler msgHandler;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  setUsername() async {
    var storage = GetIt.I<FlutterSecureStorage>();
    var tempUname = await storage.read(key: "username").toString();
    setState(() {
      username = tempUname;
    });
  }

  getNewMessage(MessageDTO msg) {
    setState(() {
      msg.sent = msg.sender == username;
      messages.add(msg);
      goToBottom();
    });
  }

  sendMessage() {
    msgHandler.sendMessage(text);
    textController.clear();
  }

  updateText(String newText) {
    setState(() {
      text = newText;
      goToBottom();
    });
  }

  goToBottom() {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent +
            MediaQuery.of(context).viewInsets.bottom,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  @override
  initState() {
    super.initState();

    setUsername();

    msgHandler = GetIt.I<MessageHandler>();
    msgHandler.setMsgCallback(getNewMessage);

    print(widget.db.name);

    messages = [
      MessageDTO.fromTimeStr(
          content: "hi",
          sender: "Amin",
          sent: false,
          time: "2021-06-24T13:52:08.292049758+04:30"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      MessageDTO msg = messages[index];
                      return Container(
                        padding: EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        child: Message(
                          msg: msg,
                        ),
                      );
                    },
                  )),
            ),
            ChatBox(
              updateText: updateText,
              sendMessage: sendMessage,
              textController: textController,
            ),
          ],
        ),
      ),
    );
  }
}
