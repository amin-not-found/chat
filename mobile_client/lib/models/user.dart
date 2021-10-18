import 'package:isar/isar.dart';

@Collection()
class User {
  @Id()
  int? id;
  // TODO : figure out how to know if someone changed their nameی
  late String name;
  @Index(indexType: IndexType.hash)
  late String username;
  bool isUptoDate = false;
  // idk if this back link has much of a use at the moment
  //@Backlink(to: "sender")
  // TODO : Make a relationship between rooms and users
  //var rooms = IsarLinks<Message>();
}
