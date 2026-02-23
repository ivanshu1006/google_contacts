import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/routes_constant.dart';
import '../../../utils/initials.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../widgets/k_app_bar.dart';
import '../../../widgets/k_dialog.dart';
import '../controllers/contacts_controller.dart';
import '../models/contact.dart';
import '../widgets/info_tile.dart';

class ContactDetailView extends StatelessWidget {
  const ContactDetailView({super.key, required this.contactId});

  final String? contactId;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContactsController>();
    final contact = contactId == null ? null : controller.getById(contactId!);

    if (contact == null) {
      return const Scaffold(
        appBar: KAppBar(title: 'Contact'),
        body: Center(child: Text('Contact not found.')),
      );
    }

    return Scaffold(
      appBar: KAppBar(
        title: 'Contact Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, contact),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.pushNamed(
              RouteConstants.contactEditName,
              pathParameters: {'id': '${contact.id}'},
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Hero(
                      tag: 'contact-avatar-${contact.id}',
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          initialsFromName(contact.name),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    contact.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  InfoTile(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: contact.phone,
                    trailing: IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () => _call(context, contact.phone),
                    ),
                  ),
                  if (contact.email != null && contact.email!.isNotEmpty)
                    InfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: contact.email!,
                    ),
                  if (contact.notes != null && contact.notes!.isNotEmpty)
                    InfoTile(
                      icon: Icons.notes_outlined,
                      label: 'Notes',
                      value: contact.notes!,
                      isMultiline: true,
                    ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => controller.toggleFavorite(contact),
                    icon: Icon(
                        contact.isFavorite ? Icons.star : Icons.star_border),
                    label: Text(
                      contact.isFavorite
                          ? 'Remove favorite'
                          : 'Add to favorites',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Contact contact) async {
    final controller = context.read<ContactsController>();
    final shouldDelete = await KDialog.instance.openDialog<bool>(
      dialog: AlertDialog(
        title: const Text('Delete contact?'),
        content: Text('This will remove ${contact.name} from your contacts.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && contact.id != null) {
      await controller.deleteContact(contact.id!);
      if (context.mounted) context.pop();
    }
  }

  Future<void> _call(BuildContext context, String phone) async {
    final normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      AppSnackbar.show('Unable to open the dialer.');
    }
  }
}
