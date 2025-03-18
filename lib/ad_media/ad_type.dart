import 'dart:ui';

enum AdType {
  banner,
  carousel,
}

extension AdTypeExtension on AdType {
  Size get size {
    switch (this) {
      case AdType.banner:
        return const Size(320, 110);
      case AdType.carousel:
        return const Size(320, 115);
    }
  }
}
