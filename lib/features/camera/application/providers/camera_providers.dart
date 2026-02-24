import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/take_picture.dart';
import '../../domain/repositories/camera_repository.dart';
import '../../infrastructure/datasources/camera_datasource.dart';
import '../../infrastructure/repositories/camera_repository_impl.dart';

final cameraDatasourceProvider = Provider((ref) => CameraDatasource());

final cameraRepositoryProvider = Provider<CameraRepository>((ref) {
  return CameraRepositoryImpl(ref.read(cameraDatasourceProvider));
});

final takePictureProvider = Provider((ref) {
  return TakePicture(ref.read(cameraRepositoryProvider));
});
