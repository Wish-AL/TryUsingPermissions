import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trying_permissions/phone_list_widget.dart';
import 'my_inherit.dart';

void main() {
  runApp(PhoneNumbersApp());
}

class PhoneNumbersApp extends StatelessWidget {
  PhoneNumbersApp({super.key});

  final contactModel = ContactModel();

  @override
  Widget build(BuildContext context) {
    return MyAppInherit<ContactModel>(
      model: contactModel,
      child: MyAppInherit<MyContactsModel>(
        model: MyContactsModel(),
        child: MaterialApp(
          title: 'Contacts',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home:
            const MyHomePage(title: 'PhoneNumbersApp'),

        ),
      ),
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
  late bool isGranted = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      MyAppInherit.read<ContactModel>(context)?.contactsPermission();
    });
  }

  @override
  void didChangeDependencies() {
    MyAppInherit.read<ContactModel>(context)?.addListener(() {
      isGranted = MyAppInherit.read<ContactModel>(context)!.isGranted;
      if (isGranted) {
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final contactsPermission = MyAppInherit.watch<ContactModel>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: contactsPermission!.isGranted
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
        floatingActionButton: !contactsPermission.isGranted
            ? FloatingActionButton.extended(
                onPressed: () =>
                    contactsPermission.buttonTapToSettingsDialog(context),
                label: const Text('Contacts'),
                icon: const Icon(Icons.person),
              )
            : const SizedBox(),
      ),
    );
  }
}
