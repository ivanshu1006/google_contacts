import 'package:flutter/material.dart';

class AppSnackbar {
  AppSnackbar._();

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
        ),
      );
  }
}
