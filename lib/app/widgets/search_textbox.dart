// lib/app/widgets/home/search_bar.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBox extends StatelessWidget {
  final String hint;
  final VoidCallback? onFilterTap;
  final bool hasFilter;
  const SearchBox({
    this.hint = 'Search',
    this.onFilterTap,
    this.hasFilter = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = hasFilter ? Colors.green : Colors.grey[600];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8, right: 12),
            child: Icon(
              Icons.search,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),

          // بدّل الـ IconButton بـ Container + InkWell
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // background عند hover لو حبيت:
                // color: Colors.grey.shade100,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onFilterTap,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/filter_icon.svg',
                    width: 20,
                    height: 20,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 36, minHeight: 36),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.blue.shade700, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
