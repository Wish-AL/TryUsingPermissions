import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Future<PermissionStatus> get contactsAccessStatus {
    return Permission.contacts.status;
  }
  Future<void> get requestContactsPermission async {
    await [Permission.contacts].request();
  }
}