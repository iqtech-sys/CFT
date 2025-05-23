import 'package:cftracker_app/app/widgets/account/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cftracker_app/app/widgets/home/payment_account_card.dart';
import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';


class AccountTypeCard extends StatefulWidget {
  final AccountType type;
  final String searchTerm;
  final AccountFilter? filter;
   final List<PaymentAccount> accounts;
  const AccountTypeCard({super.key, required this.type,required this.filter,required this.searchTerm,required this.accounts,});

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
    if (_isExpanded && _accounts == null) {
      setState(() => _isLoading = true);
      final repo = DataAccountRepository();
      final all = await repo.getPaymentAccounts();
      _accounts = all.where((acc) => acc.currency == widget.type.id).toList();
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Card container
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Header row
              Row(
                children: [
                  // Tag icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue, // أزرق
                      shape: BoxShape.circle, // دائرة
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        'assets/icons/acc_tag.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Text(
                      widget.type.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Arrow icon (right when closed, up when open)
                  SvgPicture.asset(
                    _isExpanded
                        ? 'assets/icons/arrow-up.svg'
                        : 'assets/icons/arrow-right.svg',
                    width: 18,
                    height: 18,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),

              // Expanded content
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpandedContent(),
                crossFadeState:
                    _isExpanded
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
        child: Text(
          'لا توجد حسابات لهذا النوع',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => PaymentAccountCard(account: data[i]),
    );
  }
}
