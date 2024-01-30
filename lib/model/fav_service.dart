import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_viewer/model/spotyfi_response_model.dart';

class FavoritesService {
  static const _favoritesKey = 'favorites';

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey)?.toSet() ?? {};
  }

  Future<void> addFavorite(String type, String id,SpotifyItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.add('$type-$id-${jsonEncode( SpotifyItem.toJson(item))}');
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }

  Future<void> removeFavorite(String type, String id,SpotifyItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove('$type-$id-${jsonEncode( SpotifyItem.toJson(item))}');
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }

  Future<bool> isFavorite(String type, String id,SpotifyItem item) async {
    final favorites = await getFavorites();
    return favorites.contains('$type-$id-${jsonEncode( SpotifyItem.toJson(item))}');
  }
}