import 'package:cftracker_app/app/pages/account_transactions/account_transactions_page.dart';
import 'package:cftracker_app/app/pages/edit_account/edit_account_view.dart';
import 'package:cftracker_app/app/widgets/home/TopUpDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';

class PaymentAccountCard extends StatelessWidget {
  final PaymentAccount account;
  final List<PaymentAccount> incomeAccounts;
  final void Function(PaymentAccount acc, double amt) onTopUp;
  const PaymentAccountCard({
    required this.account,
    Key? key,
    required this.incomeAccounts,
    required this.onTopUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 24,
              child: Text(
                account.currency == 'USD' ? '\$' : account.currency,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    account.balance.toStringAsFixed(1),
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
            ),

            _SvgActionButton(
              'assets/icons/add.svg',
              backgroundColor: Colors.blue,
              iconColor: Colors.white,
              size: 36,
              onTap: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder:
                      (_) => TopUpDialog(
                        receiveAccount: account,
                        incomeAccounts: incomeAccounts,
                      ),
                );

                if (result != null) {
                  final inc = result['income'] as PaymentAccount;
                  final amt = result['amount'] as double;
                  onTopUp(inc, amt);
                }
              },
            ),

            _SvgActionButton(
              'assets/icons/edit.svg',
              size: 36,
              onTap: () async {
                final updated = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => EditAccountView(account: account),
                  ),
                );
              },
            ),
            _SvgActionButton(
              'assets/icons/transactions.svg',
              size: 36,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => AccountTransactionsPage(
                          account: account,
                          transactions: [],
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SvgActionButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const _SvgActionButton(
    this.assetPath, {
    this.onTap,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.iconColor = Colors.black54,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SvgPicture.asset(
              assetPath,
              width: size * 0.6,
              height: size * 0.6,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
