import 'package:flutter/material.dart';

class PixelAsset {
  // Navigation Icons
  static const String home = 'home_icon.png';
  static const String search = 'search_icon.png';
  static const String profile = 'profile_icon.png';
  static const String jam = 'jam_icon.png';
  static const String connect = 'connect_icon.png';

  // Playback Controls
  static const String play = 'play_button.png';
  static const String pause = 'pause_button.png';
  static const String next = 'next_button.png';
  static const String previous = 'previous_button.png';

  // Miscellaneous
  static const String logout = 'logout_button.png';
  static const String power = 'power_button.png';
  static const String back = 'left_arrow.png';
  static const String title = 'titleSprite.png';

  // The reusable widget helper
  static Widget getWidget(String assetName, {double size = 28, Color? color}) {
    return Image.asset(
      'assets/$assetName',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      // This ensures the pixel art stays sharp and not blurry
      filterQuality: FilterQuality.none,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.broken_image, size: size, color: Colors.grey),
    );
  }
}
