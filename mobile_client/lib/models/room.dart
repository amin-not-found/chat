import 'package:isar/isar.dart';
import 'package:mobile_client/models/message.dart';

@Collection()
class Room {
  @Id()
  int? id;

  @Index(indexType: IndexType.hash)
  late String name;

  @Backlink(to: "room")
  var messsages = IsarLinks<Message>();

  Room();

  // TODO : change implentation because after room is implented in server, id should be room's id on server
  Room.createToom({required this.name});
}
