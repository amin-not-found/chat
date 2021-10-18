import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mobile_client/dto/message.dart';
import 'package:mobile_client/models/unsent_message.dart';
import 'package:mobile_client/models/message.dart';
import 'package:mobile_client/utils/messages/websocket.dart';

class MessageHandler {
  late WebsocketClient _client;
  IsarCollection<UnsentMessage> _unsentMessages;
  IsarCollection<Message> _messages;
  Function(MessageDTO)? _msgCallback;

  MessageHandler()
      : _unsentMessages = GetIt.I<IsarCollection<UnsentMessage>>(),
        _messages = GetIt.I<IsarCollection<Message>>() {
    _client = WebsocketClient(_handleMessage);
  }

  setMsgCallback(Function(MessageDTO) msgCallback) {
    _msgCallback = msgCallback;
  }

  sendMessage(String text) {
    var msg = {"type": "text", "content": text};
    _client.sendMessage(msg);
  }

  _handleMessage(dynamic json) {
    switch (json['Type']) {
      case "text":
        _handleTextMessage(json);
        break;
      case "server_delivery":
        _handleServerDelivery(json);
        break;
      default:
    }
  }

  _handleTextMessage(dynamic json) {
    // set Sender
    // set Room
    var new_msg = Message()
      ..id = json["Id"]
      ..content = json["Content"]
      ..time = DateTime.parse(json["Time"]);
    if (_msgCallback != null) {
      _msgCallback!(MessageDTO.fromTimeStr(
          content: json['Content'],
          sender: json['Sender'],
          time: json['Time']));
    }
  }

  _handleServerDelivery(dynamic json) {
    var id = int.tryParse(json["Content"]);
    if (id != null) {
      _unsentMessages.delete(id);
    }
  }
}
