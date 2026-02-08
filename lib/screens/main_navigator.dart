import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../utils/asset_helper.dart';
import '../widgets/mini_player.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final AudioPlayer _player = AudioPlayer();

  // Global State for the currently playing track
  String _currentTitle = "Select a song";
  String _currentAuthor = "No artist selected";
  String? _currentImageUrl;

  /// Handshake function:
  /// This is called by SearchScreen when a user taps a song row.
  void _handleSongSelection(Map<String, dynamic> song) async {
    setState(() {
      // Mapping directly to your DB headers: title, author, cover_url
      _currentTitle = song['title'] ?? "Unknown Title";
      _currentAuthor = song['author'] ?? "Unknown Artist";
      _currentImageUrl = song['cover_url'];
    });

    try {
      // Using the direct file_url string from your Supabase table
      final String? audioUrl = song['file_url'];
      if (audioUrl != null && audioUrl.isNotEmpty) {
        await _player.setUrl(audioUrl);
        _player.play();
      }
    } catch (e) {
      debugPrint("Playback Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load audio track.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _player.dispose(); // Always clean up the player to save memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // IndexedStack preserves the state of each tab so you don't
          // lose your search results when switching to Home.
          IndexedStack(
            index: _currentIndex,
            children: [
              const HomeScreen(),
              SearchScreen(player: _player, onSongSelect: _handleSongSelection),
              const ProfileScreen(),
            ],
          ),

          // Persistent MiniPlayer at the bottom of the screen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayer(
              player: _player,
              title: _currentTitle,
              author: _currentAuthor,
              imageUrl: _currentImageUrl,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF1DB954), // Spotify Green
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: PixelAsset.getWidget(PixelAsset.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: PixelAsset.getWidget(PixelAsset.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: PixelAsset.getWidget(PixelAsset.profile),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
