abstract class SpotifyItem {
  final String name;
  final String type;
  final List<String> imageUrl;
  final String id;

  SpotifyItem(
      {required this.name,
      required this.type,
      required this.imageUrl,
      required this.id});

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
        throw Exception('Nieznany typ elementu');
    }
  }

  static List<String> imgFromJsonList(Map<String, dynamic> jsonList) {
    print(jsonList);
    if (jsonList['images'] == null) {
      return [];
    }
    return (jsonList['images'] as List)
        .map((image) => image['url'] as String)
        .toList();
  }

  static List<String> artistFromJsonList(Map<String, dynamic> jsonList) {
    print(jsonList);
    if (jsonList['artists'] == null) {
      return [];
    }
    return (jsonList['artists'] as List)
        .map((name) => name['name'] as String)
        .toList();
  }

  static Map<String, dynamic> toJson(SpotifyItem item) {
    return {'name': item.name, 'type': item.type, 'id': item.id};
  }
}

class Track extends SpotifyItem {
  final List<String> artist;

  Track(
      {required String name,
      required String type,
      required List<String> imageUrl,
      required String id,
      required this.artist})
      : super(name: name, type: type, imageUrl: imageUrl, id: id);

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'],
      artist: SpotifyItem.artistFromJsonList(json),
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'],
      id: json['id'],
    );
  }
}

class Album extends SpotifyItem {
  final List<String> artistName;
  final String totalTracks;

  Album(
      {required String name,
      required String type,
      required List<String> imageUrl,
      required String id,
      required this.totalTracks,
      required this.artistName})
      : super(name: name, type: type, imageUrl: imageUrl, id: id);

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      artistName: SpotifyItem.artistFromJsonList(json),
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'],
      id: json['id'],
      totalTracks: json['total_tracks'].toString(),
    );
  }
}

class Artist extends SpotifyItem {
  Artist(
      {required String id,
      required String name,
      required String type,
      required List<String> imageUrl})
      : super(name: name, type: type, imageUrl: imageUrl, id: id);

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'],
      id: json['id'],
    );
  }
}

class Playlist extends SpotifyItem {
  final String description;

  Playlist(
      {required String name,
      required String type,
      required String id,
      required List<String> imageUrl,
      required this.description})
      : super(name: name, type: type, imageUrl: imageUrl, id: id);

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      name: json['name'],
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'],
      description: json['description'],
      id: json['id'],
    );
  }
}

class Show extends SpotifyItem {
  final String publisher;

  Show(
      {required String name,
      required String type,
      required List<String> imageUrl,
      required String id,
      required this.publisher})
      : super(name: name, type: type, imageUrl: imageUrl, id: id);

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      name: json['name'],
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'],
      publisher: json['publisher'],
      id: json['id'],
    );
  }
}

class Episode extends SpotifyItem {
  final String showName;

  Episode(
      {required String name,
      required String type,
      required List<String> imageUrl,
      required String id,
      required this.showName})
      : super(name: name, type: type, imageUrl: imageUrl, id: id);

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      name: json['name'],
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'],
      showName: json['show']['name'],
      id: json['id'],
    );
  }
}

class Audiobook extends SpotifyItem {
  Audiobook(
      {required String name,
      required String type,
      required String id,
      required List<String> imageUrl})
      : super(name: name, type: type, imageUrl: imageUrl, id: id);

  factory Audiobook.fromJson(Map<String, dynamic> json) {
    return Audiobook(
      name: json['name'],
      imageUrl: SpotifyItem.imgFromJsonList(json),
      type: json['type'],
      id: json['id'],
    );
  }
}
