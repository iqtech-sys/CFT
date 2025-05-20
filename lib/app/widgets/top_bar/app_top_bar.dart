// lib/app/widgets/top_bar/app_top_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// شريط علوي أزرق فيه أيقونة البروفايل على اليسار وشعار CFT على اليمين
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0070C0),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
leading: Padding(
  padding: const EdgeInsets.only(left: 16),
  child: IconButton(
    alignment: Alignment.center,
    iconSize: 24,
    padding: EdgeInsets.zero,
    icon: SvgPicture.asset(
      'assets/icons/profile_fill.svg',
      color: Colors.white,
      width: 24,
      height: 24,
    ),
    onPressed: () { /* TODO */ },
  ),
),

      title: const SizedBox(), // للمحافظة على ال titleSpacing
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SvgPicture.asset(
            'assets/icons/CFT_logo.svg',
            width: 100,   // عدّل العرض حسب حجم الشعار لديك
            height: 24,
            // no color: نفّذ كما في الأصل (ألوان الشعار محفوظة في الملف)
          ),
        ),
      ],
    );
  }
}
