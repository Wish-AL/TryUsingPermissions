import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trying_permissions/permission_manager.dart';
import 'package:trying_permissions/phone_list_widget.dart';

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
  bool isDenied = false;

  void _contactsPermission() async {
    _status = await _permissionManager.contactsAccessStatus;

    if (_status == PermissionStatus.granted) {
      isDenied = true;
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => PhoneNumbers()));
    } else {
      _permissionManager.requestContactsPermission;
      return;
    }
    setState(() {});
  }

  Future<void> buttonTapToSettingsDialog() async {
    _status = await _permissionManager.contactsAccessStatus;
    if (_status == PermissionStatus.permanentlyDenied ||
        _status == PermissionStatus.denied) {
      showSettingDialog();
    }
    if (_status == PermissionStatus.granted) {
      isDenied = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    _contactsPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: isDenied
            ? const PhoneNumbers()
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'You have pushed the button to get contacts:',
                    ),
                  ],
                ),
              ),
        floatingActionButton: !isDenied
            ? FloatingActionButton.extended(
                onPressed: buttonTapToSettingsDialog,
                label: const Text('Contacts'),
                icon: const Icon(Icons.person),
              )
            : const SizedBox(),
      ),
    );
  }

  void showSettingDialog() {
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

class ContactsInherit extends InheritedWidget {
  final ContactModel contacts;
  final PhotoModel photo;

  const ContactsInherit(
      {super.key, required this.photo, required this.contacts, required super.child});

  static ContactsInherit? of(BuildContext context, Object? aspect) =>
      context.dependOnInheritedWidgetOfExactType<ContactsInherit>();

  @override
  bool updateShouldNotify(covariant ContactsInherit oldWidget) =>
    oldWidget.contacts != contacts || oldWidget.photo != photo;

  // @override
  // bool updateShouldNotifyDependent(
  //     covariant ContactModel oldWidget, Set<String> dependencies) {
  //   final isContactsUpdated = (oldWidget.contacts != )
  // }

}

class ContactModel extends ChangeNotifier {

  PermissionStatus? _status;
  final PermissionManager _permissionManager = PermissionManager();
  bool isDenied = false;


  void _contactsPermission() async {
    _status = await _permissionManager.contactsAccessStatus;

    if (_status == PermissionStatus.granted) {
      isDenied = true;
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => PhoneNumbers()));
    } else {
      _permissionManager.requestContactsPermission;
      return;
    }
    //setState(() {});
  }

  Future<void> buttonTapToSettingsDialog(BuildContext context) async {
    _status = await _permissionManager.contactsAccessStatus;
    if (_status == PermissionStatus.permanentlyDenied ||
        _status == PermissionStatus.denied) {
      showSettingDialog(context);
    }
    if (_status == PermissionStatus.granted) {
      isDenied = true;
      //setState(() {});
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
class PhotoModel {
  var avatarImage;
  PermissionStatus? _status;
  final PermissionManager _permissionManager = PermissionManager();

  Future<void> avatarFromGallery(BuildContext context) async {
    _status = await _permissionManager.photosAccessStatus;
    if (_status == PermissionStatus.granted) {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      avatarImage = await image?.readAsBytes();
      //setState(() {});
    }
    if (_status == PermissionStatus.permanentlyDenied){
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

