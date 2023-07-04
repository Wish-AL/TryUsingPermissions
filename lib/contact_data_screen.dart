import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_inherit.dart';


class ContactData extends StatelessWidget {
  const ContactData({super.key});

  @override
  Widget build(BuildContext context) {
    final contactInfo = MyAppInherit.read<MyContactsModel>(context)?.contactInfo;
    final photo = MyAppInherit.watch<PhotoModel>(context);
    final avatarImage = MyAppInherit.watch<MyContactsModel>(context)?.contactInfo?.avatar;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: (const Text('Contact data')),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {photo?.avatarFromGallery;},
                  child: (contactInfo?.avatar != null)
                  ? CircleAvatar(
                    radius: 50,
                      backgroundImage:MemoryImage(avatarImage!),
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
                Text(contactInfo?.displayName ?? ''),

              ],),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('phone number:'),
                  const SizedBox(width: 20,),
                  Text(contactInfo?.phones?[0].value ?? ''),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
