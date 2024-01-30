import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_viewer/model/spotyfi_connection.dart';
import 'package:spotify_viewer/model/spotyfi_response_model.dart';

class SpotifyModel {
  final SpotyfyTokenManager tokenManager;

  SpotifyModel({required this.tokenManager});

  Future<void> initialize() async {
    await tokenManager.initializeToken();
  }

  Future<List<SpotifyItem>> fetchRandomSongs(String query,String dropdownValue) async {
    String token = tokenManager.accessToken;
    String type = 'track';
    dropdownValue = dropdownValue.toLowerCase();
    var response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=$dropdownValue'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    type = dropdownValue+'s';
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print(data.keys);
      List<dynamic> items = data[type]['items'];
      return items.map((item) => SpotifyItem.fromJson(item)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load songs');
    }
  }

// Podobne metody dla albumów, wykonawców itp.
}
