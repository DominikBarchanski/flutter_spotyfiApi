import 'package:flutter/material.dart';
import '../model/fav_service.dart';
import '../model/spotyfi_response_model.dart';

class SongTile extends StatefulWidget {
  final SpotifyItem item;
  final FavoritesService favoritesService;

  SongTile({Key? key, required this.item, required this.favoritesService}) : super(key: key);

  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  void _checkFavorite() async {
    _isFavorite = await widget.favoritesService.isFavorite(widget.item.type, widget.item.id, widget.item);
    setState(() {});
  }

  void _toggleFavorite() {
    if (_isFavorite) {
      widget.favoritesService.removeFavorite(widget.item.type, widget.item.id, widget.item);
    } else {
      widget.favoritesService.addFavorite(widget.item.type, widget.item.id, widget.item);
    }
    _isFavorite = !_isFavorite;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String subtitle = '';
    if (widget.item is Track) {
      final track = widget.item as Track;
      subtitle = 'Artist: ${track.artist.join(', ')}\nDuration: ${track.durationMs / 1000}s\nExplicit: ${track.explicit ? 'Yes' : 'No'}';
    } else if (widget.item is Album) {
      final album = widget.item as Album;
      subtitle = 'Artist: ${album.artistName.join(', ')}\nTotal Tracks: ${album.totalTracks}\nRelease Date: ${album.releaseDate}';
    } else if (widget.item is Artist) {
      final artist = widget.item as Artist;
      subtitle = 'Genres: ${artist.genres.join(', ')}\nFollowers: ${artist.followers}\nPopularity: ${artist.popularity}';
    } else if (widget.item is Playlist) {
      final playlist = widget.item as Playlist;
      subtitle = 'Description: ${playlist.description}\nOwner: ${playlist.owner}';
    } else if (widget.item is Show) {
      final show = widget.item as Show;
      subtitle = 'Publisher: ${show.publisher}\nGenres: ${show.genres.join(', ')}';
    } else if (widget.item is Episode) {
      final episode = widget.item as Episode;
      subtitle = 'Show: ${episode.showName}\nDuration: ${episode.durationMs / 1000}s\nRelease Date: ${episode.releaseDate}';
    } else if (widget.item is Audiobook) {
      final audiobook = widget.item as Audiobook;
      subtitle = 'Authors: ${audiobook.authors.join(', ')}\nPublisher: ${audiobook.publisher}\nTotal Chapters: ${audiobook.totalChapters}';
    }

    return ListTile(
      leading: widget.item.imageUrl.isNotEmpty && widget.item.imageUrl.last.isNotEmpty
          ? Image.network(widget.item.imageUrl.last)
          : Text('No image'),
      title: Text(widget.item.name),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : null,
        ),
        onPressed: _toggleFavorite,
      ),
    );
  }
}
