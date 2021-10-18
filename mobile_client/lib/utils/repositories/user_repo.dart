import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mobile_client/models/user.dart';

class UserRepository {
  late IsarCollection<User> _users;
  UserRepository(this._users);

  User getUserByUsername(String Username) {
    // NOTE : if user didn't exist create a user which isn't uptodate and try to update it
    // if succ
    var isar = GetIt.I<Isar>();

    //return _users.where().usernameEqualTo(username).findFirstSync();
  }
}
