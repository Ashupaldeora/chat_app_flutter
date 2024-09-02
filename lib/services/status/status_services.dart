import 'package:flutter/material.dart';

import '../firestore/firestore_services.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  // Singleton instance
  static final AppLifecycleObserver _instance =
      AppLifecycleObserver._internal();

  factory AppLifecycleObserver() {
    return _instance;
  }

  AppLifecycleObserver._internal();

  // Start listening to app lifecycle changes
  void startListening() {
    WidgetsBinding.instance.addObserver(this);
  }

  // Stop listening to app lifecycle changes
  void stopListening() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isOnline = state == AppLifecycleState.resumed;
    FireStoreService().updateIsOnline(isOnline);
  }
}
