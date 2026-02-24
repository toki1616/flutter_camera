import '../entities/picked_image.dart';

abstract class ImageRepository {
  Future<PickedImage?> pickFromCamera();
}
