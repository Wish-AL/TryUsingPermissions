import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

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
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('Contacts')),
      ),
      body: _contacts != null
      ? ListView.builder(
              itemCount: _contacts?.length,
              itemBuilder: (BuildContext context, int index) {
                Contact? contact = _contacts?.elementAt(index);
                return Row(
                  children: [
                    Text(contact?.phones?[0].value ?? ''),
                    Text(contact?.displayName ?? ''),
                  ],
                );
                //This can be further expanded to showing contacts detail
                // onPressed().
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
