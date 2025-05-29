// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/entities/home/payment_transaction.dart';

const kBlue = Color(0xFF0070BA);

class AccountTransactionsPage extends StatefulWidget {
  final PaymentAccount account;
  final List<PaymentTransaction> transactions;

  const AccountTransactionsPage({
    Key? key,
    required this.account,
    required this.transactions,
  }) : super(key: key);

  @override
  _AccountTransactionsPageState createState() =>
      _AccountTransactionsPageState();
}

class _AccountTransactionsPageState extends State<AccountTransactionsPage> {
  DateTimeRange? _selectedRange;

  DateTimeRange get _initialRange => DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedRange ?? _initialRange,

      // لا نريد وضع الإدخال، لذا نختار Calendar-Only لإخفاء أيقونة القلم
      initialEntryMode: DatePickerEntryMode.calendarOnly,

      // ------------- تخصيص الـ UI -------------
      builder: (context, child) {
        final base = Theme.of(context);

        return Theme(
          data: base.copyWith(
            useMaterial3: true,

            // لوحة الألوان المخصَّصة
            colorScheme: base.colorScheme.copyWith(
              primary: kBlue, // الدائرة المختارة + زر الحفظ
              onPrimary: Colors.white, // النص على الأزرق
              surfaceTint: kBlue,
            ),

            // رأس المنتقي
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: const Color(0xFFE4E4E4), // رمادي فضي
              headerForegroundColor: Colors.black, // نص أسود/داكن
              todayBorder: BorderSide.none,
            ),

            // زر “Save”
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(kBlue),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: const MaterialStatePropertyAll(CircleBorder()),

                minimumSize: const MaterialStatePropertyAll(Size(64, 64)),
                padding: const MaterialStatePropertyAll(EdgeInsets.all(12)),

                textStyle: const MaterialStatePropertyAll(
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => _selectedRange = picked);
  }

  String _fmt(DateTime d) => DateFormat('yyyy MMM d').format(d);

  Widget _buildDateChip(DateTime d) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(_fmt(d), style: const TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dfDate = DateFormat('MMM d, HH:mm');
    final range = _selectedRange ?? _initialRange;
    final dateRangeLabel = '${_fmt(range.start)} - ${_fmt(range.end)}';

    return Scaffold(
      backgroundColor: Colors.white,
      // ------------- APP BAR -------------
      appBar: AppBar(
        backgroundColor: kBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          'Account transactions ${widget.account.currency}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(color: Colors.white),
      ),

      // ------------- BODY -------------
      body: Column(
        children: [
          // ====== شريط الفلتر ======
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // نص + سهم
                  Expanded(
                    child: InkWell(
                      onTap: _pickDateRange,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              dateRangeLabel,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: kBlue),
                        ],
                      ),
                    ),
                  ),
                  // فاصل رأسي رفيع
                  Container(
                    width: 1,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: Colors.grey.shade300,
                  ),
                  // زر الفلتر
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: kBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _pickDateRange,
                      child: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // شرائط الـ Chips للتاريخ
          if (_selectedRange != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildDateChip(_selectedRange!.start),
                  const SizedBox(width: 8),
                  _buildDateChip(_selectedRange!.end),
                ],
              ),
            ),

          // ===== قائمة المعاملات =====
          Expanded(
            child: ListView.separated(
              itemCount: widget.transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tx = widget.transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // التاريخ
                      Text(
                        dfDate.format(tx.dateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // الوصف
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.type,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tx.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // المبلغ
                          Text(
                            '${tx.amount >= 0 ? '+' : ''}${tx.amount.toStringAsFixed(1)} ${tx.currency}',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  tx.amount >= 0
                                      ? Colors.green
                                      : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
