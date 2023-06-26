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
  var avatarImage;
  @override
  void initState() {
    avatarImage = widget.contactInfo!.avatar!;
    super.initState();
  }

  void avatarFromGallery() async {
    final PermissionStatus? permissionStatus = await _getPhotosPermission();
    if (permissionStatus == PermissionStatus.granted) {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      avatarImage = await image?.readAsBytes();
      setState(() {});

    }
    if (permissionStatus == PermissionStatus.permanentlyDenied){
      showSettingDialog();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('Contact data')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GestureDetector(
                onTap: avatarFromGallery,
                child: (widget.contactInfo?.avatar != null)
                ? CircleAvatar(
                  radius: 50,
                    backgroundImage:MemoryImage(avatarImage),
                    )
                : const CircleAvatar(
                  radius: 50,
                    child: Text('no avatar')),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              const Text('First Name:'),
              const SizedBox(width: 20,),
              Text(widget.contactInfo?.displayName ?? ''),

            ],),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('phone number:'),
                const SizedBox(width: 20,),
                Text(widget.contactInfo?.phones?[0].value ?? ''),
              ],
            ),
          )
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
        permission != PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.photos].request();
      return permissionStatus[Permission.photos];
    } else {
      return permission;
    }
  }
}
