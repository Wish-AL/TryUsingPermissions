import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trying_permissions/permission_manager.dart';
import 'package:trying_permissions/phone_list_screen.dart';

extension TitleGetter on PermissionStatus {
  String get statusMessege {
    switch (this) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      default:
        return 'Unknown';
    }
  }
}

void main() {
  runApp(const PhoneNumbersApp());
}

class PhoneNumbersApp extends StatelessWidget {
  const PhoneNumbersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PhoneNumbersApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PermissionStatus? _status;
  final PermissionManager _permissionManager = PermissionManager();

  // void _checkAccess() async {
  //   _status = await _permissionManager.cameraAccessStatus;
  //   // if(_status != PermissionStatus.permanentlyDenied) {
  //   //   _permissionManager.requestCameraPermission;
  //   // } else {
  //   //   showSettingDialog();
  //   // }
  //   if (_status == PermissionStatus.granted) {
  //     final image = ImagePicker.platform.pickImage(source: ImageSource.camera);
  //   }
  //   if (_status == PermissionStatus.permanentlyDenied ||
  //       _status == PermissionStatus.denied) {
  //     showSettingDialog();
  //   } else {
  //     await _permissionManager.requestCameraPermission;
  //   }
  //   setState(() {});
  // }

  void _contactsPermission() async {
    final PermissionStatus? permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PhoneNumbers()));
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      showContactsDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              ' ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _contactsPermission,
        tooltip: 'Contacts',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<PermissionStatus?> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }

  void showSettingDialog() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Vou need permissions to camera access'),
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

  void showContactsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Permissions error'),
              content: const Text('Please enable contacts access '
                  'permission in system settings'),
              actions: <Widget>[
                const CupertinoActionSheetAction(
                    onPressed: openAppSettings, child: Text('Yes')),
                CupertinoActionSheetAction(
                    onPressed: Navigator.of(context).maybePop,
                    child: const Text('No'))
              ],
            ));
  }
}
