import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news24_kg/controller/cubit/news/news_cubit.dart';
import 'package:news24_kg/data/services/rss_service.dart';
import 'package:news24_kg/repository/news_repository.dart';
import 'package:news24_kg/ui/screens/home_screen.dart';
import 'package:news24_kg/core/theme/app_colors.dart';
import 'package:news24_kg/ui/screens/main_screen.dart';

void main() {
  final rssService = RssService();
  final repository = NewsRepository(rssService: rssService);
  runApp(
    RepositoryProvider.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NewsCubit(repository)..fetchNews()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News KG',
      theme: ThemeData(
        appBarTheme: AppBarThemeData(backgroundColor: AppColors.background),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
