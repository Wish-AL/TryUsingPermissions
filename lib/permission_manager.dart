import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Future<PermissionStatus> get cameraAccessStatus {
    return Permission.camera.status;
  }
  Future<void> get requestCameraPermission async {
    await [Permission.camera].request();
  }
}