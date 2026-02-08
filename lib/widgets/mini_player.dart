import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../utils/asset_helper.dart';
import '../screens/player/full_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  final AudioPlayer player;
  final String title;
  final String author;
  final String? imageUrl;

  const MiniPlayer({
    super.key,
    required this.player,
    this.title = "Select a song",
    this.author = "Unknown Artist",
    this.imageUrl,
  });

  void _showFullPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FullPlayerScreen(
        player: player,
        title: title, // Sends the current title to the full screen
        author: author, // Sends the current author to the full screen
        imageUrl: imageUrl, // Sends the current cover to the full screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;

        // The mini player is hidden until a song duration is loaded
        if (player.duration == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => _showFullPlayer(context),
          child: Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Song Cover Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              PixelAsset.getWidget(PixelAsset.jam, size: 40),
                        )
                      : PixelAsset.getWidget(PixelAsset.jam, size: 40),
                ),
                const SizedBox(width: 12),

                // Title and Author
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        author,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Play/Pause Toggle
                IconButton(
                  icon: PixelAsset.getWidget(
                    playing ? PixelAsset.pause : PixelAsset.play,
                    size: 32,
                  ),
                  onPressed: () {
                    if (playing) {
                      player.pause();
                    } else {
                      player.play();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
