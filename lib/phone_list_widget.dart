import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'contact_data_screen.dart';

class PhoneNumbers extends StatefulWidget {
  const PhoneNumbers({super.key});

  @override
  State<PhoneNumbers> createState() => _PhoneNumbersState();
}

class _PhoneNumbersState extends State<PhoneNumbers> {
  Iterable<Contact>? _contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _contacts != null
        ? ListView.builder(
            itemCount: _contacts?.length,
            itemBuilder: (BuildContext context, int index) {
              Contact? contact = _contacts?.elementAt(index);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ContactData(contactInfo: contact)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(contact?.phones?[0].value ?? ''),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(contact?.displayName ?? ''),
                    ],
                  ),
                ),
              );
             },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
