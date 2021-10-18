import 'package:isar/isar.dart';
import 'package:mobile_client/models/room.dart';

@Collection()
class UnsentMessage {
  @Id()
  late int id;
  var room = IsarLink<Room>();
  late String content;
  @Index()
  late DateTime time;
}
