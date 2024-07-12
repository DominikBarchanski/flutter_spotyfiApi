import 'package:flutter/material.dart';

abstract class SpotifyItem {
  final String name;
  final String type;
  final List<String> imageUrl;
  final String id;
  final Uri? uri;
  final int? popularity;
  final String? releaseDate;

  SpotifyItem({
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.id,
    this.uri,
    this.popularity,
    this.releaseDate,
  });

  factory SpotifyItem.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'track':
        return Track.fromJson(json);
      case 'album':
        return Album.fromJson(json);
      case 'artist':
        return Artist.fromJson(json);
      case 'playlist':
        return Playlist.fromJson(json);
      case 'show':
        return Show.fromJson(json);
      case 'episode':
        return Episode.fromJson(json);
      case 'audiobook':
        return Audiobook.fromJson(json);
      default:
        throw Exception('Unknown item type');
    }
  }

  static List<String> imgFromJsonList(Map<String, dynamic> jsonList) {
    if (jsonList['images'] == null) {
      return [];
    }
    return (jsonList['images'] as List)
        .map((image) => image['url'] as String)
        .toList();
  }

  static List<String> artistFromJsonList(Map<String, dynamic> jsonList) {
    if (jsonList['artists'] == null) {
      return [];
    }
    return (jsonList['artists'] as List)
        .map((artist) => artist['name'] as String)
        .toList();
  }

  static Map<String, dynamic> toJson(SpotifyItem item) {
    return {
      'name': item.name,
      'type': item.type,
      'id': item.id,
      'uri': item.uri?.toString(),
      'popularity': item.popularity,
      'release_date': item.releaseDate,
    };
  }
}

class Track extends SpotifyItem {
  final List<String> artist;
  final int durationMs;
  final bool explicit;

  Track({
    required String name,
    required String type,
    required List<String> imageUrl,
    required String id,
    required this.artist,
    required this.durationMs,
    required this.explicit,
    Uri? uri,
    int? popularity,
    String? releaseDate,
  }) : super(
    name: name,
    type: type,
    imageUrl: imageUrl,
    id: id,
    uri: uri,
    popularity: popularity,
    releaseDate: releaseDate,
  );

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'] ?? 'Unknown Track',
      artist: SpotifyItem.artistFromJsonList(json),
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'] ?? 'track',
      id: json['id'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      explicit: json['explicit'] ?? false,
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
      popularity: json['popularity'],
      releaseDate: json['album']?['release_date'],
    );
  }
}

class Album extends SpotifyItem {
  final List<String> artistName;
  final String totalTracks;
  final String albumType;
  final String label;

  Album({
    required String name,
    required String type,
    required List<String> imageUrl,
    required String id,
    required this.totalTracks,
    required this.artistName,
    required this.albumType,
    required this.label,
    Uri? uri,
    int? popularity,
    String? releaseDate,
  }) : super(
    name: name,
    type: type,
    imageUrl: imageUrl,
    id: id,
    uri: uri,
    popularity: popularity,
    releaseDate: releaseDate,
  );

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'] ?? 'Unknown Album',
      artistName: SpotifyItem.artistFromJsonList(json),
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'] ?? 'album',
      id: json['id'] ?? '',
      totalTracks: json['total_tracks']?.toString() ?? '0',
      albumType: json['album_type'] ?? 'album',
      label: json['label'] ?? 'Unknown Label',
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
      popularity: json['popularity'],
      releaseDate: json['release_date'],
    );
  }
}

class Artist extends SpotifyItem {
  final int followers;
  final List<String> genres;

  Artist({
    required String id,
    required String name,
    required String type,
    required List<String> imageUrl,
    required this.followers,
    required this.genres,
    Uri? uri,
    int? popularity,
  }) : super(
    name: name,
    type: type,
    imageUrl: imageUrl,
    id: id,
    uri: uri,
    popularity: popularity,
  );

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'] ?? 'Unknown Artist',
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'] ?? 'artist',
      id: json['id'] ?? '',
      followers: json['followers']?['total'] ?? 0,
      genres: (json['genres'] as List?)?.map((genre) => genre as String).toList() ?? [],
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
      popularity: json['popularity'],
    );
  }
}

class Playlist extends SpotifyItem {
  final String description;
  final String owner;

  Playlist({
    required String name,
    required String type,
    required String id,
    required List<String> imageUrl,
    required this.description,
    required this.owner,
    Uri? uri,
  }) : super(
    name: name,
    type: type,
    imageUrl: imageUrl,
    id: id,
    uri: uri,
  );

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      name: json['name'] ?? 'Unknown Playlist',
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'] ?? 'playlist',
      description: json['description'] ?? '',
      id: json['id'] ?? '',
      owner: json['owner']?['display_name'] ?? 'Unknown Owner',
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
    );
  }
}

class Show extends SpotifyItem {
  final String publisher;
  final List<String> genres;

  Show({
    required String name,
    required String type,
    required List<String> imageUrl,
    required String id,
    required this.publisher,
    required this.genres,
    Uri? uri,
  }) : super(
    name: name,
    type: type,
    imageUrl: imageUrl,
    id: id,
    uri: uri,
  );

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      name: json['name'] ?? 'Unknown Show',
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'] ?? 'show',
      publisher: json['publisher'] ?? 'Unknown Publisher',
      id: json['id'] ?? '',
      genres: (json['genres'] as List?)?.map((genre) => genre as String).toList() ?? [],
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
    );
  }
}

class Episode extends SpotifyItem {
  final String showName;
  final int durationMs;

  Episode({
    required String name,
    required String type,
    required List<String> imageUrl,
    required String id,
    required this.showName,
    required this.durationMs,
    Uri? uri,
    String? releaseDate,
  }) : super(
    name: name,
    type: type,
    imageUrl: imageUrl,
    id: id,
    uri: uri,
    releaseDate: releaseDate,
  );

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      name: json['name'] ?? 'Unknown Episode',
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'] ?? 'episode',
      showName: json['show']?['name'] ?? 'Unknown Show',
      id: json['id'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
      releaseDate: json['release_date'],
    );
  }
}

class Audiobook extends SpotifyItem {
  final List<String> authors;
  final String publisher;
  final int totalChapters;

  Audiobook({
    required String name,
    required String type,
    required String id,
    required List<String> imageUrl,
    required this.authors,
    required this.publisher,
    required this.totalChapters,
    Uri? uri,
  }) : super(
    name: name,
    type: type,
    imageUrl: imageUrl,
    id: id,
    uri: uri,
  );

  factory Audiobook.fromJson(Map<String, dynamic> json) {
    return Audiobook(
      name: json['name'] ?? 'Unknown Audiobook',
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'] ?? 'audiobook',
      id: json['id'] ?? '',
      authors: (json['authors'] as List?)?.map((author) => author['name'] as String).toList() ?? [],
      publisher: json['publisher'] ?? 'Unknown Publisher',
      totalChapters: json['total_chapters'] ?? 0,
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
    );
  }
}
