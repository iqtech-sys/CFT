import 'package:flutter/material.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:searchfield/searchfield.dart';

class TopUpDialog extends StatelessWidget {
  final PaymentAccount receiveAccount;
  final List<String> suggestions;
  final List<PaymentAccount> incomeAccounts;

  const TopUpDialog({
    Key? key,
    required this.receiveAccount,
    required this.incomeAccounts,
    this.suggestions = const ['10 USD', '20 USD', '50 USD'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedAmount;
    PaymentAccount? selectedIncomeAccount;
    String? selectedValue;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // رأس الـ dialog مع عنوان وزر الإغلاق
            Row(
              children: [
                Text(
                  'Top up',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // سطر الـ "Receive account" مع الحاوية المدوّرة
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Receive account:'),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    receiveAccount.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /* Income account – SearchField */
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SearchField<PaymentAccount>(
                    suggestions:
                        incomeAccounts
                            .map(
                              (acc) => SearchFieldListItem<PaymentAccount>(
                                acc.name,
                                item: acc,
                              ),
                            )
                            .toList(),
                    suggestionState:
                        Suggestion.expand, // يظهر اللائحة أسفل الحقل
                    maxSuggestionsInViewPort: 6,
                    itemHeight: 45,
                    onSuggestionTap: (s) {
                      selectedIncomeAccount = s.item;
                    },
                    searchInputDecoration: SearchInputDecoration(
                      hintText: 'Choose income account',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.2,
                        ),
                      ),
                      suffix: const Icon(Icons.arrow_drop_down_sharp),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // عنوان الحقل التلقائي
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Auto complete list',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 8),

            // حقل الإكمال التلقائي مع أيقونة
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return suggestions.where((option) {
                  return option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              onSelected: (String selection) {
                selectedValue = selection;
              },
              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Amount USD',
                    prefixIcon: const Icon(Icons.attach_money),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // زر الحفظ بعرض كامل وخلفية صفراء
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107), // أصفر مطابق
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  final amount = double.tryParse(
                    selectedAmount ?? selectedValue ?? '',
                  );
                  if (selectedIncomeAccount != null && amount != null) {
                    Navigator.pop(context, {
                      'income': selectedIncomeAccount,
                      'amount': amount,
                    });
                  } else {
                  }
                },

                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
