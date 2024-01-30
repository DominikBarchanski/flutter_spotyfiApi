import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_viewer/model/spotify_model.dart';
import 'package:spotify_viewer/view/main_view.dart';

import 'controller/spotify_controller.dart';
import 'model/fav_service.dart';
import 'model/spotyfi_connection.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FavoritesService favoritesService = FavoritesService();
  int _favoritesKey = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProviderScope(
        child: MyHomePage(title: 'Spotify Viewer Home Page'),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenManager = SpotyfyTokenManager.instance;
    final spotifyModel = SpotifyModel(tokenManager: tokenManager);

    return FutureBuilder(
      future: initializeTokenManager(tokenManager),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final spotifyController = SpotifyController(spotifyModel);
          return MainView(spotifyController: spotifyController, key: UniqueKey());
        }
      },
    );
  }

  Future<void> initializeTokenManager(SpotyfyTokenManager tokenManager) async {
    if (tokenManager.accessToken.isEmpty) {
      await tokenManager.initializeToken();
    }
  }
}


