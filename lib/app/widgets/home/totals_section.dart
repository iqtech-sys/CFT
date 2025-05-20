import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';

class TotalsSection extends StatefulWidget {
  final List<PaymentAccount> accounts;
  const TotalsSection({required this.accounts, Key? key}) : super(key: key);

  @override
  State<TotalsSection> createState() => _TotalsSectionState();
}

class _TotalsSectionState extends State<TotalsSection> {
  bool _expanded = false;

  /// يحسب مجموع كل عملة ويرجّع خريطة <العملة, المجموع>
  Map<String, double> _totalsByCurrency() {
    final Map<String, double> totals = {};
    for (final acc in widget.accounts) {
      totals.update(acc.currency, (value) => value + acc.balance,
          ifAbsent: () => acc.balance);
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    // مجموع كل الأرصدة (كل العملات معًا) – اختياري للعنوان
    final overallTotal = widget.accounts.fold<double>(
      0,
      (sum, acc) => sum + acc.balance,
    );

    final totals = _totalsByCurrency(); // ← هنا التجميع

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ——— رأس القسم ———
          InkWell(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/wallet.svg',
                      width: 24, height: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Total accounts balances',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SvgPicture.asset(
                    _expanded
                        ?'assets/icons/arrow-down.svg'
                        :  'assets/icons/arrow-up.svg',
                    width: 18,
                    height: 18,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),

          // ——— المحتوى المطوي/المفتوح ———
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: totals.entries
                    .map((e) => _CurrencyRow(
                          currency: e.key,
                          total: e.value,
                        ))
                    .toList(),
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

/// صفّ واحد لعملة معيّنة + مجموعها
class _CurrencyRow extends StatelessWidget {
  final String currency;
  final double total;
  const _CurrencyRow({required this.currency, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // أيقونة العملة
          Container(
            width: 46,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                currency == 'USD' ? '\$' : currency,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              currency,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            total.toStringAsFixed(1),
            style: const TextStyle(fontSize: 14, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
