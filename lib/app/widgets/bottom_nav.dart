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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onItemTapped,
      selectedItemColor: Theme.of(context).primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/footer_home.svg',
            width: 24, height: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/footer_accounts.svg',
            width: 24, height: 24,
          ),
          label: 'Accounts',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/footer_invoices.svg',
            width: 24, height: 24,
          ),
          label: 'Invoices',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/footer_budgets.svg',
            width: 24, height: 24,
          ),
          label: 'Allocations',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/footer_more.svg',
            width: 24, height: 24,
          ),
          label: 'More',
        ),
      ],
    );
  }
}
