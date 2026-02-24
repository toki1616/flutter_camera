import 'package:camera/camera.dart';

class CameraDatasource {
  CameraController? _controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      await initialize();
    }
    return _controller!.takePicture();
  }
}
