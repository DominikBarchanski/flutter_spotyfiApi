import 'package:flutter/material.dart';
import '../model/spotify_model.dart';
import '../model/spotyfi_response_model.dart';

class SongDetailView extends StatelessWidget {
  final SpotifyItem song;

  SongDetailView({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.name),
      ),
      body: Center(
        child: Column(
          children: [
            song.imageUrl.isEmpty
                ? Text('No image')
                : Image.network(song.imageUrl[0], height: 300, width: 300),
            Text('Name: ${song.name}'),
            if (song is Album) Text('Total Tracks: ${(song as Album).totalTracks}'),
            if (song is Album) Text('Artist: ${(song as Album).artistName.join(', ')}'),
            if (song is Track) Text('Artist: ${(song as Track).artist.join(', ')}'),
            if (song is Playlist) Text('Description: ${(song as Playlist).description}'),
            if (song is Show) Text('Publisher: ${(song as Show).publisher}'),
            if (song is Episode) Text('Show Name: ${(song as Episode).showName}'),
          ],
        ),
      ),
    );
  }
}
