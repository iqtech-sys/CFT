import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../home/home_view.dart';
import '../accounts/accounts_view.dart';
import '../invoices/invoices_view.dart';
import '../allocations/allocations_view.dart';
import '../more/more_view.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  // صفحات التبويبات
  final _pages =  [
    HomeView(),
    AccountsView(),
    InvoicesView(),
    AllocationsView(),
    MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onItemTapped: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
