import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    const inactiveColor = Colors.grey;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: onItemTapped,
        selectedItemColor: primary,
        unselectedItemColor: inactiveColor,
        showUnselectedLabels: true,
        items: [
          _buildItem(
            iconPath: 'assets/icons/footer_home.svg',
            label: 'Home',
            index: 0,
            activeColor: primary,
            inactiveColor: inactiveColor,
          ),
          _buildItem(
            iconPath: 'assets/icons/footer_accounts.svg',
            label: 'Accounts',
            index: 1,
            activeColor: primary,
            inactiveColor: inactiveColor,
          ),
          _buildItem(
            iconPath: 'assets/icons/footer_invoices.svg',
            label: 'Invoices',
            index: 2,
            activeColor: primary,
            inactiveColor: inactiveColor,
          ),
          _buildItem(
            iconPath: 'assets/icons/footer_budgets.svg',
            label: 'Allocations',
            index: 3,
            activeColor: primary,
            inactiveColor: inactiveColor,
          ),
          _buildItem(
            iconPath: 'assets/icons/footer_more.svg',
            label: 'More',
            index: 4,
            activeColor: primary,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildItem({
    required String iconPath,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        color: currentIndex == index ? activeColor : inactiveColor,
      ),
      label: label,
    );
  }
}
