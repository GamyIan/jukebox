import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/asset_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _browseSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBrowseSongs();
  }

  Future<void> _fetchBrowseSongs() async {
    try {
      // Fetches 5 random songs from your database table
      final data = await supabase.from('songs').select().limit(5);

      setState(() {
        _browseSongs = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Home Fetch Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Color(0xFF121212),
            floating: true,
            automaticallyImplyLeading: false,
            title: Text(
              "BROWSE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                letterSpacing: 2.0,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DISCOVER NEW SOUNDS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1DB954),
                      ),
                    )
                  else
                    ..._browseSongs.map((song) => _buildSongRow(song)),

                  const SizedBox(height: 40),

                  // FIXED PIXEL JAM BUTTON
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DB954),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1DB954).withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement Jam Lobby Logic
                        },
                        icon: PixelAsset.getWidget(PixelAsset.jam, size: 32),
                        label: const Text(
                          "START JAM SESSION",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Space for MiniPlayer
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongRow(Map<String, dynamic> song) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            song['cover_url'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                PixelAsset.getWidget(PixelAsset.jam, size: 40),
          ),
        ),
        title: Text(
          song['title'].toString().toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Increased from 16
            letterSpacing: 1.2,
          ),
        ),
        subtitle: Text(
          song['author'].toString().toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14, // Increased from 12
          ),
        ),
        trailing: PixelAsset.getWidget(PixelAsset.play, size: 24),
      ),
    );
  }
}
