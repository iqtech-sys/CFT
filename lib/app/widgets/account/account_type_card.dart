import 'package:flutter/material.dart';
import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';

class AccountTypeCard extends StatefulWidget {
  final AccountType type;            // العملة أو نوع الحساب

  const AccountTypeCard({super.key, required this.type});

  @override
  State<AccountTypeCard> createState() => _AccountTypeCardState();
}

class _AccountTypeCardState extends State<AccountTypeCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isLoading = false;
  List<PaymentAccount>? _accounts;

  Future<void> _toggle() async {
    setState(() => _isExpanded = !_isExpanded);

    // أول مرة نفتح فيها الكارد نحمِّل البيانات
    if (_isExpanded && _accounts == null) {
      setState(() => _isLoading = true);
      final repo = DataAccountRepository();
      final all = await repo.getPaymentAccounts();
      _accounts =
          all.where((acc) => acc.currency == widget.type.id).toList();
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // رأس الكارد
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.account_balance_wallet,
                        color: Colors.blueAccent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.type.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? .5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ],
              ),

              // محتوى الكارد المتوسِّع
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpandedContent(),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final data = _accounts ?? [];

    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('لا توجد حسابات لهذا النوع',
            style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _AccountRow(acc: data[i]),
    );
  }
}

// صف حساب منفصل لإعادة الاستخدام
class _AccountRow extends StatelessWidget {
  final PaymentAccount acc;
  const _AccountRow({required this.acc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                acc.currency == 'USD' ? '\$' : acc.currency,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(acc.name, style: const TextStyle(fontSize: 14))),
          Text('${acc.balance.toStringAsFixed(1)} ${acc.currency}',
              style: const TextStyle(fontSize: 14, color: Colors.green)),
        ],
      ),
    );
  }
}
