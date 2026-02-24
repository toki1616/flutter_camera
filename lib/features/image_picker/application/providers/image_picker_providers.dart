import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../save/json_save/domain/entities/save_file_name.dart';
import '../../../save/json_save/infrastructure/datasources/json_save_utils.dart';

import '../../domain/entities/picked_image.dart';
import '../../domain/usecases/pick_image_from_camera.dart';
import '../../infrastructure/datasources/image_picker_datasource.dart';
import '../../infrastructure/repositories/image_repository_impl.dart';

final imagePickerDataSourceProvider =
Provider((ref) => ImagePickerDataSource());

final imageRepositoryProvider = Provider((ref) {
  return ImageRepositoryImpl(ref.watch(imagePickerDataSourceProvider));
});

final pickImageFromCameraProvider = Provider((ref) {
  return PickImageFromCamera(ref.watch(imageRepositoryProvider));
});

/// ---- タイトルごとに画像をグルーピングする Notifier ----
/// state = { "旅行": [PickedImage, PickedImage], "仕事": [...] }
class PickedImagesNotifier
    extends StateNotifier<Map<String, List<PickedImage>>> {
  PickedImagesNotifier(this._pickImage) : super({}) {
    _load(); // ← 起動時にロード
  }

  final PickImageFromCamera _pickImage;

  /// JSON からロード
  Future<void> _load() async {
    final data = await SaveUtils.load(SaveFileName.images.fileName);
    if (data == null) return;

    final map = <String, List<PickedImage>>{};

    data.forEach((key, list) {
      map[key] = (list as List)
          .map((e) => PickedImage.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    state = map;
  }

  /// JSON に保存
  Future<void> _save() async {
    final jsonMap = state.map((key, list) =>
        MapEntry(key, list.map((e) => e.toJson()).toList()));

    await SaveUtils.save(SaveFileName.images.fileName, jsonMap);
  }

  /// 画像追加
  Future<void> addImage(String title) async {
    final img = await _pickImage();
    if (img == null) return;

    final newImage = PickedImage(
      path: img.path,
      title: title,
      takenAt: img.takenAt,
    );

    state = {
      ...state,
      title: [...(state[title] ?? []), newImage],
    };

    await _save();
  }
}

final pickedImagesProvider = StateNotifierProvider<
    PickedImagesNotifier, Map<String, List<PickedImage>>>((ref) {
  return PickedImagesNotifier(ref.watch(pickImageFromCameraProvider));
});
