import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/initials.dart';
import '../controllers/contacts_controller.dart';
import '../models/contact.dart';

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    super.key,
    required this.contact,
    this.onTap,
  });

  final Contact contact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initials = initialsFromName(contact.name);
    return ListTile(
      onTap: onTap,
      leading: Hero(
        tag: 'contact-avatar-${contact.id}',
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(initials),
        ),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.phone),
      trailing: IconButton(
        icon: Icon(
          contact.isFavorite ? Icons.star : Icons.star_border,
          color:
              contact.isFavorite ? Theme.of(context).colorScheme.primary : null,
        ),
        onPressed: () =>
            context.read<ContactsController>().toggleFavorite(contact),
      ),
    );
  }
}
