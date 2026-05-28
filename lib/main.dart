import 'package:dental/screens/loading_screen.dart';
import 'package:dental/screens/prediction_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'constants/theme.dart';
import 'package:provider/provider.dart';
import 'backend/providers.dart';
import 'screens/documentation_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModelProvider()),
        ChangeNotifierProvider(create: (context) => MouthModelProvider()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        title: "Dental Image Segmentation",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/prediction': (context) => const PredictionScreen(),
          '/loading': (context) => LoadingScreen(),
          '/documentation': (context) => DocumentationScreen(),
        },
      ),
    );
  }
}
