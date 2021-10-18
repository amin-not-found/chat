import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_client/utils/api_client.dart';
import 'package:mobile_client/widgets/shared/dialog.dart';

class Auth {
  String _refreshToken;
  late String accessToken;
  DateTime? _accessExpiry;
  FlutterSecureStorage storage;
  var refreshTokenUri = Uri.parse(GetIt.I<ApiClient>().refreshUrl());

  Auth({required refreshToken})
      : _refreshToken = refreshToken,
        storage = GetIt.I<FlutterSecureStorage>();

  getNewTokens() async {
    // TODO : don't bother if user isn't logged in
    late String error_title;
    late String error_messsage;

    try {
      var resp = await ApiClient.call(refreshTokenUri, _refreshToken);
      var data = jsonDecode(resp.body);
      if (resp.statusCode < 300) {
        _setAccessToken(data["AccessToken"]);
        _setRefreshToken(data["RefreshToken"]);
        print("Got new auth tokens");
        return;
      }
      print("Oops. auth problem");
      error_title = data["Title"];
      error_messsage = data["Description"];
    } on SocketException {
      return;
    }
    // TODO : give a clear error about not being able to connect and tell user to login again
    var context = GetIt.I<GlobalKey<NavigatorState>>().currentContext;
    // TODO : handle context being null
    if (context != null) {
      showDialog(
          context: context,
          builder: dialogBuilder(error_title, error_messsage, {"Ok": logout}));
    }
  }

  ensureAccess() async {
    print(_accessExpiry);
    // Get new tokens if _accessExpiry is null or is expired
    if (_accessExpiry == null || DateTime.now().isAfter(_accessExpiry!)) {
      await getNewTokens();
    }
  }

  logout() async {
    var storage = GetIt.I<FlutterSecureStorage>();
    await storage.delete(key: "refresh_token");
    GetIt.I<GlobalKey<NavigatorState>>()
        .currentState!
        .pushNamedAndRemoveUntil("/login", (route) => false);
  }

  _setRefreshToken(String newRefreshToken) {
    _refreshToken = newRefreshToken;
    storage.write(key: "refresh_token", value: newRefreshToken);
  }

  _setAccessToken(String newAccessToken) {
    accessToken = newAccessToken;
    var termpAccessExpiry = DateTime.now().add(Duration(seconds: 4 * 60 + 44));
    print(termpAccessExpiry);
    _accessExpiry = DateTime.now()
        .add(Duration(seconds: 4 * 60 + 44)); // 16 seconds less than 5 minues
  }
}
