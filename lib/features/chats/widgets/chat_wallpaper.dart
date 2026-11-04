import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Tiled doodle wallpaper behind the chat thread — the same artwork as the
/// portal's conversation canvas (original line-art doodles + Lumenta mark
/// figures). The asset is a transparent 3x raster of the portal's
/// `src/assets/chat-doodle.svg` (420pt tile); regenerate it after changing
/// the portal pattern:
///
///   rsvg-convert -z 3 ../portal/src/assets/chat-doodle.svg \
///     -o assets/images/chat_wallpaper.png
///
/// Light mode paints the artwork's own warm/brand-green strokes on paper;
/// dark mode recolours it to a faint light tone so it stays a texture.
class ChatWallpaper extends StatelessWidget {
  const ChatWallpaper({required this.child, super.key});

  final Widget child;

  static const asset = 'assets/images/chat_wallpaper.png';

  /// Raster density of [asset] — keeps the tile at 420 logical px.
  static const _assetScale = 3.0;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark ? AppColors.deepForest : AppColors.paper,
        image: DecorationImage(
          image: const AssetImage(asset),
          repeat: ImageRepeat.repeat,
          scale: _assetScale,
          alignment: Alignment.topLeft,
          colorFilter: dark
              ? ColorFilter.mode(
                  AppColors.onDarkHigh.withValues(alpha: 0.06),
                  BlendMode.srcIn,
                )
              : null,
        ),
      ),
      child: child,
    );
  }
}
