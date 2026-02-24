enum SaveFileName {
  images,
}

extension SaveFileNameExt on SaveFileName {
  String get fileName {
    switch (this) {
      case SaveFileName.images:
        return "images";
    }
  }
}