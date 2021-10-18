import 'dart:convert';

import 'package:http/http.dart' as http;

class ConnectionStatus {
  bool connected;
  String err;
  ConnectionStatus({required this.connected, required this.err});
}

class ApiClient {
  // TODO : implement a method to check internet connection

  //// Local
  final host = "192.168.1.5:8080";
  final isSecure = false;

  //// Heroku
/*   final host = "aminchatserver.herokuapp.com";
  final isSecure = true; */

  final loginRoute = "/signin";
  final signupRoute = "/signup";
  final refreshRoute = "/refresh";

  static ConnectionStatus canConnect() {
    return ConnectionStatus(connected: true, err: "");
  }

  static Future<http.Response> call(Uri uri, Object? data) async {
    // TODO : handle connection error(sspecially connection to server)
    return await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
  }

  String websocketUrl() {
    var protocol = "ws" + (isSecure ? "s" : "");
    return protocol + "://" + host + "/ws?token=";
  }

  String httpProtocol() {
    return "http" + (isSecure ? "s" : "") + "://";
  }

  String signupUrl() {
    return httpProtocol() + host + signupRoute;
  }

  String loginUrl() {
    return httpProtocol() + host + loginRoute;
  }

  String refreshUrl() {
    return httpProtocol() + host + refreshRoute;
  }
}
