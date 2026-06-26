import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vnest_app/core/router/app_router.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:vnest_app/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase & notifications may fail on web or without proper config.
  // Don't let that block the UI from rendering.
  try {
    await Firebase.initializeApp();

    if (!kIsWeb) {
      await NotificationService().initialize(AppRouter.router);
      // Using a hardcoded demo user ID for registration
      await NotificationService().registerToken('user_demo_01');
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const VNestApp());
}

class VNestApp extends StatelessWidget {
  const VNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VoltNest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}
