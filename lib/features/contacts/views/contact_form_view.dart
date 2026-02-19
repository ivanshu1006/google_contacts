import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../controllers/contacts_controller.dart';
import '../models/contact.dart';

class ContactFormView extends HookWidget {
  const ContactFormView({super.key, this.contactId});

  final int? contactId;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContactsController>();
    final existing =
        contactId == null ? null : controller.getById(contactId!);

    final nameController = useTextEditingController(text: existing?.name ?? '');
    final phoneController =
        useTextEditingController(text: existing?.phone ?? '');
    final emailController =
        useTextEditingController(text: existing?.email ?? '');
    final notesController =
        useTextEditingController(text: existing?.notes ?? '');
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final isEditing = existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit contact' : 'New contact'),
      ),
      body: Form(
        key: formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: notesController,
                      textInputAction: TextInputAction.done,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _saveContact(
                        context,
                        controller,
                        formKey,
                        existing,
                        nameController.text,
                        phoneController.text,
                        emailController.text,
                        notesController.text,
                      ),
                      child: Text(isEditing ? 'Save changes' : 'Add contact'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveContact(
    BuildContext context,
    ContactsController controller,
    GlobalKey<FormState> formKey,
    Contact? existing,
    String name,
    String phone,
    String email,
    String notes,
  ) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();
    if (existing == null) {
      final contact = Contact(
        name: name.trim(),
        phone: phone.trim(),
        email: email.trim().isEmpty ? null : email.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await controller.addContact(contact);
    } else {
      final updated = existing.copyWith(
        name: name.trim(),
        phone: phone.trim(),
        email: email.trim().isEmpty ? null : email.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
        updatedAt: now,
      );
      await controller.updateContact(updated);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
