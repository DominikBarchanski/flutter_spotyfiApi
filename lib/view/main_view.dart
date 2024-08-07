import 'package:flutter/material.dart';
import 'package:spotify_viewer/model/spotify_model.dart';
import 'package:spotify_viewer/view/single_item_view.dart';
import '../controller/spotify_controller.dart';
import '../model/fav_service.dart';
import '../model/spotyfi_response_model.dart';
import 'element_view.dart';
import 'fav_view.dart';
import 'single_item_view.dart'; // Ensure this import is correct

class MainView extends StatefulWidget {
  final SpotifyController spotifyController;
  MainView({Key? key, required this.spotifyController}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController?.indexIsChanging ?? false) {
      print('Tab changed to: ${_tabController?.index}');
      setState(() {
        _tabController?.index;
      });
    }
  }

  List<SpotifyItem> items = [];
  String query = '';
  String dropdownValue = 'Album';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Spotify Viewer'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Main'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>[
                          'Album',
                          'Artist',
                          'Playlist',
                          'Track',
                          'Show',
                          'Episode',
                          'Audiobook'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      items = await widget.spotifyController.fetchSongs(query, dropdownValue);
                      setState(() {});
                    } catch (e) {
                      print('Error fetching items: $e');
                    }
                  },
                  child: Text('Search'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SongDetailView(song: item)),
                          );
                        },
                        child: SongTile(
                          key: ValueKey(item.id + _tabController!.index.toString()),
                          item: item,
                          favoritesService: FavoritesService(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            FavoritesView(favoritesService: FavoritesService()),
          ],
        ),
      ),
    );
  }
}
