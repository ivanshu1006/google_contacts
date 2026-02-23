import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/routes_constant.dart';
import '../controllers/contacts_controller.dart';
import '../models/contact.dart';
import 'contact_list_tile.dart';

class ContactList extends StatelessWidget {
  const ContactList({
    super.key,
    required this.contacts,
    required this.isLoading,
  });

  final List<Contact> contacts;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contacts.isEmpty) {
      return Center(
        child: Text(
          'No contacts yet',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ContactsController>().loadContact(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final contactId = contact.id;
          return ContactListTile(
            contact: contact,
            onTap: contactId == null
                ? null
                : () => context.pushNamed(
                      RouteConstants.contactDetailName,
                      pathParameters: {'id': contactId},
                    ),
          );
        },
      ),
    );
  }
}
