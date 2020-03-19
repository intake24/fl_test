import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Intake24AuthClient {
  final String _apiBaseUrl;
  final BaseClient _client;

  String _refreshToken;
  String _accessToken;

  Intake24AuthClient(this._apiBaseUrl, this._client);

  Future<void> sign_in(String username, String password) {
    return _client
        .post(_apiBaseUrl + "/signin",
            headers: {"content-type": "application/json"},
            body: json.encode({"email": username, "password": password}))
        .then((response) {
      if (response.statusCode == 200) {
        _refreshToken = json.decode(response.body)["refreshToken"];
        return Future.value();
      } else if (response.statusCode == 401) {
        return Future.error("User name or password not recognized");
      } else
        return Future.error("HTTP error ${response.statusCode}");
    }, onError: (e) {
      print("HTTP client error: $e");
    });
  }
}
