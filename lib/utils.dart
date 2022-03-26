import 'dart:ui';

/// Transforms an hex String to a Color, String should be like #AARRGGBB
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0x66000000);

ImageProvider getImageWidget(String coverUrl) {
  if (coverUrl.startsWith("http")) {
    return NetworkImage(coverUrl);
  } else {
    return AssetImage(coverUrl);
  }
}
