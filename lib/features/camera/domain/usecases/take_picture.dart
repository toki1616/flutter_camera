import '../entities/captured_image.dart';
import '../repositories/camera_repository.dart';

class TakePicture {
  final CameraRepository repository;

  TakePicture(this.repository);

  Future<CapturedImage?> call() {
    return repository.takePicture();
  }
}
