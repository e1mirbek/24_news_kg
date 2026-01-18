import 'package:flutter/material.dart';
import 'package:news24_kg/core/theme/app_colors.dart';

class AppIconButton extends StatelessWidget {
  final String icon;
  final void Function()? onPressed;
  const AppIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        // Делаем эффект нажатия идеально круглым
        customBorder: const CircleBorder(),
        // Или настраиваем цвет всплеска (опционально)
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(
            icon,
            width: 20.0,
            height: 20.0,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
