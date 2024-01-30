import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpotyfyTokenManager {
  static final SpotyfyTokenManager _instance = SpotyfyTokenManager._internal();
  String _accessToken = "";
  String clientId = "e4c6e0a5e74a491681031e3d47682b63";
  String clientSecret = "9da427fd75b949ea9f2e09ed0fa4b12f";


  factory SpotyfyTokenManager({required String clientId, required String clientSecret}) {
    _instance.clientId = clientId;
    _instance.clientSecret = clientSecret;
    return _instance;
  }

  SpotyfyTokenManager._internal();

  Future<void> initializeToken() async {

  var res = await http.post(
    Uri.parse("https://accounts.spotify.com/api/token"),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: "grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}"
  );
  var jsonResponse = jsonDecode(res.body);
  var accessToken = jsonResponse['access_token'];

  if (accessToken == null) {
    throw Exception('Access token is null');
  } else {
    _accessToken = accessToken;
    print(_accessToken);
  }
}

  String get accessToken => _accessToken;

  Future<void> refreshToken() async {
    // Logic to refresh the token if expired
  }

  static SpotyfyTokenManager get instance => _instance;
}
