import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trying_permissions/permission_manager.dart';

class MyAppInherit<Model> extends InheritedWidget {
  final Model model;

  const MyAppInherit({
    super.key,
    required this.model,
    required super.child,
  });

  static Model? watch<Model>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MyAppInherit<Model>>()
        ?.model;
  }

  static Model? read<Model>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MyAppInherit<Model>>()
        ?.widget;
    return widget is MyAppInherit<Model> ? widget.model : null;
  }

  static MyAppInherit<Model>? of<Model>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyAppInherit<Model>>();

  @override
  bool updateShouldNotify(MyAppInherit<Model> oldWidget) =>
      model != oldWidget.model;

}
class MyContactsModel extends ChangeNotifier {
  Iterable<Contact>? contacts;
  Contact? contactInfo;
  void setContactInfo(Contact contact) {
    contactInfo = contact;
  }

  Future<void> getContacts() async {
    contacts = await ContactsService.getContacts();
    notifyListeners();
  }
}
class ContactModel extends ChangeNotifier {
  PermissionStatus? _status;
  final PermissionManager _permissionManager = PermissionManager();
  bool isGranted = false;


  void contactsPermission() async {
    _status = await _permissionManager.contactsAccessStatus;

    if (_status == PermissionStatus.granted) {
      isGranted = true;
      notifyListeners();
    } else {
      _permissionManager.requestContactsPermission;
      //return;
    }

  }

  Future<void> buttonTapToSettingsDialog(BuildContext context) async {
    _status = await _permissionManager.contactsAccessStatus;
    if (_status == PermissionStatus.permanentlyDenied ||
        _status == PermissionStatus.denied) {
      showSettingDialog(context);
    }
    if (_status == PermissionStatus.granted) {
      isGranted = true;
      notifyListeners();
    }
  }

  void showSettingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Vou need permissions to contacts access'),
        content: const Text('Do you want open settings now?'),
        actions: [
          const CupertinoActionSheetAction(
              onPressed: openAppSettings, child: Text('Yes')),
          CupertinoActionSheetAction(
              onPressed: Navigator.of(context).maybePop,
              child: const Text('No'))
        ],
      ),
    );
  }

}

class PhotoModel extends ChangeNotifier {
  var avatarImage;
  PermissionStatus? _status;
  final PermissionManager _permissionManager = PermissionManager();

  Future<void> avatarFromGallery(BuildContext context) async {
    _status = await _permissionManager.photosAccessStatus;
    if (_status == PermissionStatus.granted) {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      avatarImage = await image?.readAsBytes();
      notifyListeners();
    }
    if (_status == PermissionStatus.permanentlyDenied) {
      showSettingDialog(context);
    }
  }

  void showSettingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Vou need permissions to contacts access'),
        content: const Text('Do you want open settings now?'),
        actions: [
          const CupertinoActionSheetAction(
              onPressed: openAppSettings, child: Text('Yes')),
          CupertinoActionSheetAction(
              onPressed: Navigator.of(context).maybePop,
              child: const Text('No'))
        ],
      ),
    );
  }
}
