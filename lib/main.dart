import 'package:flutter/material.dart';
import 'package:news24_kg/ui/screens/home_screen.dart';
import 'package:news24_kg/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'controller/providers/news_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NewsProvider())],
      child: MaterialApp(
        title: 'News KG',
        theme: ThemeData(
          appBarTheme: AppBarThemeData(backgroundColor: AppColors.background),
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
