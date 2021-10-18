import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_client/utils/api_client.dart';
import 'package:mobile_client/utils/auth.dart';
import 'package:mobile_client/utils/messages/message_handler.dart';
import 'package:mobile_client/utils/repositories/user_repo.dart';
import 'package:mobile_client/utils/theme.dart';
import 'package:isar/isar.dart';
import 'package:mobile_client/isar.g.dart';
import 'package:mobile_client/utils/messages/websocket.dart';

typedef Username = String;

// Just a helper function to prevent me from writing the same code every time i want to register a sigleton
checkRegisterSignleton<T extends Object>(
    Future<T> Function() objectCreator) async {
  if (!GetIt.instance.isRegistered<T>()) {
    GetIt.instance.registerSingleton(await objectCreator());
  }
}

Future<String> initialize(BuildContext context) async {
  //// Navigator key
  // so that current context can be available for stuff like dialogs
  await checkRegisterSignleton(() async => GlobalKey<NavigatorState>());

  //// Settings
  await checkRegisterSignleton(() async => FlutterSecureStorage());
  var storage = GetIt.I<FlutterSecureStorage>();
  //storage.delete(key: "encryption_key"); // just for testing
  var encryptionKey = await storage.read(key: "encryption_key");

  // we can't just return without setting the theme
  // but we also need to get theme from storage

  //// Theme
  await checkRegisterSignleton(() async => await AppTheme.getTheme());

  if (encryptionKey == null) {
    return "/passwd";
  }

  // We migh need ApiClient for auth. so here must be a good place
  await checkRegisterSignleton(() async => ApiClient());

  //// Authentication
  var _refreshToken = await storage.read(key: "refresh_token");
  //await storage.delete(key: "refresh_token"); // Jsut for testing
  if (_refreshToken == null) {
    return "/signup";
  }

  await checkRegisterSignleton(() async {
    var authHandler = Auth(refreshToken: _refreshToken);
    await authHandler.getNewTokens();
    return authHandler;
  });

  //// Database

  if (!GetIt.instance.isRegistered<Isar>()) {
    var isar = await openIsar(
        encryptionKey: Uint8List.fromList(encryptionKey.codeUnits));
    // TODO : maybe give some of these collection as function argument instead
    GetIt.instance.registerSingleton(isar);
    GetIt.instance.registerSingleton(isar.users);
    GetIt.instance.registerSingleton(isar.rooms);
    GetIt.instance.registerSingleton(isar.unsentMessages);
    GetIt.instance.registerSingleton(isar.messages);
  }

  //// Websocket
  await checkRegisterSignleton(() async => MessageHandler());

  return "/";
}
