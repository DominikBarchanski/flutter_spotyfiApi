import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spotify_viewer/view/element_view.dart';
import '../model/fav_service.dart';
import '../model/spotyfi_response_model.dart';
import 'single_item_view.dart';

class FavoritesView extends StatefulWidget {
  final FavoritesService favoritesService;

  FavoritesView({Key? key, required this.favoritesService}) : super(key: key);

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late Future<Set<String>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = widget.favoritesService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<String>>(
      future: _favoritesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final favorites = snapshot.data!;
          return ListView(
            children: favorites.map((favorite) {
              final split = favorite.split('-');
              final type = split[0];
              final id = split[1];
              Map<String, dynamic> song = jsonDecode(split[2]);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongDetailView(song: SpotifyItem.fromJson(song)),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('Type: $type'),
                  subtitle: Text('Name: ${song['name']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      widget.favoritesService
                          .removeFavorite(type, id, SpotifyItem.fromJson(song))
                          .then((_) {
                        setState(() {
                          _favoritesFuture = widget.favoritesService.getFavorites();
                        });
                      });
                    },
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
