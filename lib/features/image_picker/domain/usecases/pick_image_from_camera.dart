import '../entities/picked_image.dart';
import '../repositories/image_repository.dart';

class PickImageFromCamera {
  final ImageRepository repository;

  PickImageFromCamera(this.repository);

  Future<PickedImage?> call() {
    return repository.pickFromCamera();
  }
}
