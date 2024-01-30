import 'package:flutter/material.dart';
import '../model/fav_service.dart';
import '../model/spotyfi_response_model.dart';

class SongTile extends StatefulWidget {
  final SpotifyItem song;
  final FavoritesService favoritesService;

  SongTile({Key? key, required this.song, required this.favoritesService}) : super(key: key);

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
    _isFavorite = await widget.favoritesService.isFavorite(widget.song.type, widget.song.id,widget.song);
    setState(() {});
  }

  void _toggleFavorite() {
    if (_isFavorite) {
      widget.favoritesService.removeFavorite(widget.song.type, widget.song.id,widget.song);
    } else {
      widget.favoritesService.addFavorite(widget.song.type, widget.song.id,widget.song);
    }
    _isFavorite = !_isFavorite;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.song.imageUrl.isNotEmpty && widget.song.imageUrl.last.isNotEmpty
          ? Image.network(widget.song.imageUrl.last)
          : Text('No image'),
      title: Text(widget.song.name),
      subtitle: Text("Artist: ${widget.song.name}"),
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