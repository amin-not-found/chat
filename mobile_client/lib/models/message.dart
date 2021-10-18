import 'package:isar/isar.dart';
import 'package:mobile_client/dto/message.dart';
import 'package:mobile_client/models/user.dart';
import 'package:mobile_client/models/room.dart';

@Collection()
class Message {
  @Id()
  late int id;

  var sender = IsarLink<User>();
  var room = IsarLink<Room>();

  late String content;
  @Index()
  late DateTime time;

  MessageDTO toDto() {
    // TODO : Not sure about using ! here
    return MessageDTO(
        content: content, sender: sender.value!.username, timeSent: time);
  }
  //Message(String username, String roomId){

  //}
}
