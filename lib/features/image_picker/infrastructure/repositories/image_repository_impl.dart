import '../../domain/entities/picked_image.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_picker_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImagePickerDataSource dataSource;

  ImageRepositoryImpl(this.dataSource);

  @override
  Future<PickedImage?> pickFromCamera() async {
    final path = await dataSource.pickFromCamera();
    if (path == null) return null;

    return PickedImage(
      path: path,
      title: '',
      takenAt: DateTime.now(), // 撮影日時を付与
    );
  }
}
