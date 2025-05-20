// ignore_for_file: deprecated_member_use

import 'package:cftracker_app/app/widgets/home/accounts_section.dart';
import 'package:cftracker_app/app/widgets/search_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../widgets/top_bar/app_top_bar.dart';
import '../../widgets/home/totals_section.dart';
import 'home_controller.dart';

class HomeView extends CleanView {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends CleanViewState<HomeView, HomeController> {
  _HomeViewState() : super(HomeController());

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: const AppTopBar(),
      body: ControlledWidgetBuilder<HomeController>(
        builder: (context, controller) {
          return Column(
            children: [
              SearchBox(
                hasFilter: controller.isFilterActive != null,
                onFilterTap: () => _showFilterSheet(context, controller),
              ),

              const SizedBox(height: 4),
              Expanded(child: SingleChildScrollView(child: AccountsSection(accounts: controller.accounts))),
              TotalsSection(accounts: controller.accounts),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  ButtonStyle filterButtonStyle({
    required bool selected,
    required Color color,
    required Color selectedTextColor,
    required double width ,
    required double height ,
  }) {
    return ElevatedButton.styleFrom(
      minimumSize: Size(width, height),
      elevation: 0,
      backgroundColor:
          selected
        ? color.withOpacity(0.1)
        : const Color(0xffd1d5d6),
      foregroundColor:
          selected
              ? color
              : const Color(0xff707271),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _showFilterSheet(BuildContext context, HomeController controller) {
    double buttonWidth = MediaQuery.of(context).size.height*0.21;
    double buttonHeight = MediaQuery.of(context).size.width*0.15;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Container(
            height: MediaQuery.of(context).size.height * 0.2, // 25% من الشاشة
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // زر Active
                  ElevatedButton(
                    style: filterButtonStyle(
                      selected: controller.isFilterActive == true,
                      color: Colors.blue, // اللون الأساسي للـ Active
                      selectedTextColor: Colors.blue,
                      width: buttonWidth,
                      height: buttonHeight,
                    ),
                    onPressed: () {
                      final newValue =
                          controller.isFilterActive == true ? null : true;
                      controller.setFilter(newValue);
                      Navigator.pop(context);
                    },
                    child: const Text('Active'),
                  ),
                  const SizedBox(width: 16),
                  // زر Inactive
                  ElevatedButton(
                    style: filterButtonStyle(
                      selected: controller.isFilterActive == false,
                      color: Colors.blue, // اللون الأساسي للـ Inactive
                      selectedTextColor: Colors.blue,
                      width: buttonWidth,
                      height: buttonHeight,
                    ),
                    onPressed: () {
                      final newValue =
                          controller.isFilterActive == false ? null : false;
                      controller.setFilter(newValue);
                      Navigator.pop(context);
                    },
                    child: const Text('Inactive'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
