import 'package:image_picker/image_picker.dart';

class ImagePickerDataSource {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    return picked?.path;
  }
}
