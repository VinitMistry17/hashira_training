import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const soulForgedApp());
}

class soulForgedApp extends StatelessWidget {
  const soulForgedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soul Forged Hashira',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.white),
          bodyLarge: TextStyle(
              color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
