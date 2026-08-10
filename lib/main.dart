import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Elivapp());
}

class Elivapp extends StatelessWidget {
  const Elivapp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Elivapp',

      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.splash,

      getPages: AppRoutes.pages,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF001F3E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8FF5A),
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}