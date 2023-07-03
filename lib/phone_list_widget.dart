import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'contact_data_screen.dart';
import 'my_inherit.dart';

class PhoneNumbers extends StatefulWidget {
  const PhoneNumbers({super.key});

  @override
  State<PhoneNumbers> createState() => _PhoneNumbersState();
}

class _PhoneNumbersState extends State<PhoneNumbers> {
  @override
  void initState() {
    super.initState();
    setState(() {
      MyAppInherit.read<MyContactsModel>(context)?.getContacts();
    });
  }

  @override
  void didChangeDependencies() {
    MyAppInherit.read<MyContactsModel>(context)?.addListener(() {
      if (MyAppInherit.read<MyContactsModel>(context)?.contacts != null) {
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = MyAppInherit.watch<MyContactsModel>(context)?.contacts;
    return contacts != null
        ? ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              Contact? contact = contacts.elementAt(index);
              return GestureDetector(
                onTap: () {
                  MyAppInherit.watch<MyContactsModel>(context)
                      ?.setContactInfo(contact);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAppInherit<PhotoModel>(
                        model: PhotoModel(),
                        child: const ContactData(),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(contact.phones?[0].value ?? ''),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(contact.displayName ?? ''),
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
