import 'package:flutter/material.dart';
import 'package:frappe_flutter_app/constants/app_colors.dart';
import 'package:provider/provider.dart';

import 'features/contacts/controllers/contacts_controller.dart';
import 'features/contacts/data/contacts_database.dart';
import 'features/contacts/repositories/contacts_repository.dart';
import 'router.dart';
import 'widgets/app_snackbar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ContactsDatabase>(
          create: (_) => ContactsDatabase.instance,
        ),
        ProxyProvider<ContactsDatabase, ContactsRepository>(
          update: (_, db, __) => ContactsRepository(db),
        ),
        ChangeNotifierProvider<ContactsController>(
          create: (context) =>
              ContactsController(context.read<ContactsRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: AppSnackbar.messengerKey,
      title: 'Contacts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
