import 'package:flutter/material.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'payment_account_card.dart';

/// يعرض عنوان "Payment accounts" وقائمة البطاقات
class AccountsSection extends StatelessWidget {
  final List<PaymentAccount> accounts;
  const AccountsSection({required this.accounts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Payment accounts',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // المفتوح (عندما لا تكون هناك حسابات)
        if (accounts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text('No payment accounts available'),
          )
        else
          // قائمة البطاقات
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => PaymentAccountCard(account: accounts[i]),
          ),
      ],
    );
  }
}
