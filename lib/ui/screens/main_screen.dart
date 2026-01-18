import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:news24_kg/ui/screens/favorite_screen.dart';
import 'package:news24_kg/ui/screens/home_screen.dart';
import 'package:news24_kg/ui/screens/settings_screen.dart';

import '../../core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        10,
        0,
        10,
        40,
      ), // Отступы, чтобы панель "плавала"
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(
          24,
          25,
          25,
          1.0,
        ), // Темный фон панели из видео
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: GNav(
        rippleColor: Colors.white10,
        hoverColor: Colors.white10,
        haptic: true,
        tabBorderRadius: 30, // Скругление активной "капсулы"
        gap: 4,
        color: Colors.grey, // Цвет неактивных иконок
        activeColor: AppColors.white, // Цвет иконки и текста при нажатии
        iconSize: 24,
        tabBackgroundColor: AppColors.red, // Красный фон активной вкладки
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        tabs: [
          GButton(
            icon: Icons.grid_view_rounded,
            text: 'ГЛАВНАЯ',
            textStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GButton(
            icon: Icons.favorite_border_rounded,
            text: 'ИЗБРАННОЕ',
            textStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GButton(
            icon: Icons.settings_outlined,
            text: 'НАСТРОЙКИ',
            textStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
