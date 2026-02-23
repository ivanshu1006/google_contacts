import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frappe_flutter_app/constants/app_colors.dart';
import 'package:provider/provider.dart';

import 'features/contacts_firebase/controllers/contacts_controller.dart';
import 'features/contacts_firebase/data/contacts_repository.dart';
import 'firebase_options.dart';
import 'router.dart';
import 'widgets/app_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ContactsController>(
          create: (_) => ContactsController(ContactsRepository()),
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
