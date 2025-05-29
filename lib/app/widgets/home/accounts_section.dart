// lib/app/widgets/home/accounts_section.dart
import 'package:flutter/material.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'payment_account_card.dart';

class AccountsSection extends StatelessWidget {
  final List<PaymentAccount> accounts;

  /// كل حسابات الـ Income (INC) لتُمرَّر إلى البطاقات
  final List<PaymentAccount> incomeAccounts;

  /// Callback يُنفَّذ عند نجاح Top-up
  final void Function(PaymentAccount incomeAcc, double amount) onTopUp;

  const AccountsSection({
    Key? key,
    required this.accounts,
    required this.incomeAccounts,   // ★ جديد
    required this.onTopUp,          // ★ جديد
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Payment accounts',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        if (accounts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text('No payment accounts available'),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => PaymentAccountCard(
              account: accounts[i],
              incomeAccounts: incomeAccounts,   // ✔️
              onTopUp: onTopUp,                 // ✔️
            ),
          ),
      ],
    );
  }
}
