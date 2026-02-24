import 'package:camera/camera.dart';

import '../../domain/entities/captured_image.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_datasource.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraDatasource datasource;

  CameraRepositoryImpl(this.datasource);

  @override
  Future<CapturedImage?> takePicture() async {
    final file = await datasource.takePicture();
    if (file == null) return null;

    return CapturedImage(file.path);
  }
}
