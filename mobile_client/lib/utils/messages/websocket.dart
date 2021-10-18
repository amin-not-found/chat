import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mobile_client/utils/api_client.dart';
import 'package:mobile_client/utils/auth.dart';

class WebsocketClient {
  late Function(dynamic) _msgHandler;

  WebsocketClient(this._msgHandler) {
    initWebSocketConnection();
  }

  late String wsUrl;
  final authController = GetIt.I<Auth>();
  final db = GetIt.I<Isar>();

  StreamController<String> streamController =
      new StreamController.broadcast(sync: true);
  WebSocket? channel;

  initWebSocketConnection() async {
    print("conecting...");
    this.channel = await connectWs();
    print("socket connection initializied");
    this.channel?.done.then((dynamic _) => _onDisconnected());
    broadcastMessages();
  }

  sendMessage(Map<String, String> msg) {
    this.channel?.add(jsonEncode(msg));
    //final newMsg = Message{};
  }

  broadcastMessages() {
    this.channel?.listen((streamData) {
      receiveMessage(streamData);
    }, onDone: () {
      print("conecting aborted");
      initWebSocketConnection();
    }, onError: (e) {
      print('Server error: $e');
      initWebSocketConnection();
    });
  }

  receiveMessage(dynamic data) {
    var json = jsonDecode(data);
    _msgHandler(json);
  }

  connectWs() async {
    try {
      await authController.ensureAccess();
      wsUrl = GetIt.I<ApiClient>().websocketUrl() + authController.accessToken;
      return await WebSocket.connect(wsUrl);
    } catch (e) {
      print("Error! can not connect WS connectWs " + e.toString());
      await Future.delayed(Duration(milliseconds: 10000));
      return await connectWs();
    }
  }

  void _onDisconnected() {
    initWebSocketConnection();
  }
}
