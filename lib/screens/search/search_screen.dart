import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_audio/just_audio.dart';
import '../../utils/asset_helper.dart';

class SearchScreen extends StatefulWidget {
  final AudioPlayer player;
  final Function(Map<String, dynamic>) onSongSelect;

  const SearchScreen({
    super.key,
    required this.player,
    required this.onSongSelect,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _songs = [];
  bool _isLoading = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInitialSongs();
  }

  Future<void> _fetchInitialSongs() async {
    setState(() => _isLoading = true);
    try {
      // Specifically fetching from your 'songs' table
      final data = await supabase.from('songs').select();
      debugPrint(
        "Songs Found: ${data.length}",
      ); // Look for this in your console

      setState(() {
        _songs = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Fetch Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: "SEARCH...",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PixelAsset.getWidget(PixelAsset.search, size: 20),
            ),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (val) => _fetchInitialSongs(), // Simple refresh for now
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1DB954)),
            )
          : _songs.isEmpty
          ? Center(
              child: Text(
                "NO SONGS FOUND\nCHECK SUPABASE RLS",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _songs.length,
              padding: const EdgeInsets.only(bottom: 100),
              itemBuilder: (context, index) {
                final song = _songs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      song['cover_url'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          PixelAsset.getWidget(PixelAsset.jam, size: 50),
                    ),
                  ),
                  title: Text(
                    song['title'].toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    song['author'].toString().toUpperCase(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: PixelAsset.getWidget(PixelAsset.play, size: 28),
                  onTap: () => widget.onSongSelect(song),
                );
              },
            ),
    );
  }
}
