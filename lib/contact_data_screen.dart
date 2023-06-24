import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactData extends StatefulWidget {
  final Contact? contactInfo;
  const ContactData({super.key, required this.contactInfo});

  @override
  State<ContactData> createState() => _ContactDataState();
}

class _ContactDataState extends State<ContactData> {
  void changeAvatar() {

  }
  void _contactsPermission() async {
    final PermissionStatus? permissionStatus = await _getPhotosPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //final image = ImagePicker.platform.pickImage(source: ImageSource.);
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      showSettingDialog();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('Contacts')),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: changeAvatar,
            child: (widget.contactInfo?.avatar != null)
            ? CircleAvatar(
                backgroundImage:MemoryImage(widget.contactInfo!.avatar!),
                child: Text('data'))
            : CircleAvatar(
                child: Text('data')),
          ),
          Row(children: [
            Text(widget.contactInfo?.displayName ?? ''),
            Text(widget.contactInfo?.phones?[0].value ?? ''),
          ],),
        ],
      ),
    );
  }
  void showSettingDialog() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Vou need permissions to image access'),
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
  Future<PermissionStatus?> _getPhotosPermission() async {
    final PermissionStatus permission = await Permission.photos.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }
}
