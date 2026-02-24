class PickedImage {
  final String path;
  final String title;
  final DateTime takenAt;

  const PickedImage({
    required this.path,
    required this.title,
    required this.takenAt,
  });

  // JSON 変換を追加
  Map<String, dynamic> toJson() => {
    "path": path,
    "title": title,
    "takenAt": takenAt.toIso8601String(),
  };

  factory PickedImage.fromJson(Map<String, dynamic> json) => PickedImage(
    path: json["path"],
    title: json["title"],
    takenAt: DateTime.parse(json["takenAt"]),
  );
}