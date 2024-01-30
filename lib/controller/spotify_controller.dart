import 'package:spotify_viewer/model/spotify_model.dart';

import '../model/spotyfi_response_model.dart';

class SpotifyController {
  final SpotifyModel spotifyModel;

  SpotifyController(this.spotifyModel);

  Future<List<SpotifyItem>> fetchSongs(String query,String dropdownValue) async {
    print('start');
    try {
      print('object');
      return await spotifyModel.fetchRandomSongs(query,dropdownValue);
    } catch (e) {
      // Obsługa błędów, np. wyświetl komunikat o błędzie
      print('Error fetching songs: $e');
      return [];
    }
  }

// Możesz dodać więcej metod dla albumów, wykonawców itp.
}
