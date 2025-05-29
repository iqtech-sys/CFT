import 'package:cftracker_app/app/pages/edit_account/edit_account_controller.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/entities/add_account/currency.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:searchfield/searchfield.dart';

class EditAccountView extends CleanView {
  const EditAccountView({Key? key, required this.account}) : super(key: key);

  final PaymentAccount account;           // ★ الحساب القادم من القائمة

  @override
  _EditAccountViewState createState() => _EditAccountViewState();
}

class _EditAccountViewState
    extends CleanViewState<EditAccountView, EditAccountController> {
  _EditAccountViewState()
      : super(
          EditAccountController(),         // ▶ controller
        );

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl      = TextEditingController();
  final _currencyCtrl  = TextEditingController();

  Currency?    _selectedCurrency;
  AccountType? _selectedType;

  final Color _grey = Colors.grey;

  @override
  void initState() {
    super.initState();
    // ◀ تعبئة الحقول بالقيم الحالية
    _nameCtrl.text      = widget.account.name;
    _currencyCtrl.text  = widget.account.currency;
  }

  @override
  Widget get view => Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Edit account',),
                  titleTextStyle: const TextStyle(
          color: Colors.white, // نص العنوان أبيض
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        ),
        body: ControlledWidgetBuilder<EditAccountController>(
          builder: (context, con) {
          if (con.isBusy) {
            return Column(
              children: [
                SizedBox(
                  height: 3,
                  child: const LinearProgressIndicator(minHeight: 3),
                ),

              ],
            );
          }
            // لإنشاء حدود موحّدة
            OutlineInputBorder _border(Color c) =>
                OutlineInputBorder(borderSide: BorderSide(color: c));

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /* 1) الاسم */
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Account name',
                          labelStyle: TextStyle(color: _grey),
                          border: _border(_grey),
                          enabledBorder: _border(_grey),
                          focusedBorder: _border(_grey),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset('assets/icons/acc.svg',
                                width: 24, color: _grey),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 12),

                      /* 2) النوع */
                      DropdownButtonFormField<AccountType>(
                        value: con.types
                            .firstWhere((t) => t.id == widget.account.typeId),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Account type',
                          labelStyle: TextStyle(color: _grey),
                          border: _border(_grey),
                          enabledBorder: _border(_grey),
                          focusedBorder: _border(_grey),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                                'assets/icons/footer_accounts.svg',
                                width: 24,
                                color: _grey),
                          ),
                        ),
                        items: con.types
                            .map((t) =>
                                DropdownMenuItem(value: t, child: Text(t.name)))
                            .toList(),
                        onChanged: (v) => _selectedType = v,
                      ),

                      const SizedBox(height: 12),

                      /* 3) العملة */
                      SearchField<Currency>(
                        controller: _currencyCtrl,
                        itemHeight: 45,
                        maxSuggestionsInViewPort: 6,
                        suggestionsDecoration:
                             SuggestionDecoration(elevation: 2),
                        suggestions: con.currencies
                            .map((c) => SearchFieldListItem('${c.symbol} – ${c.name}',
                                item: c))
                            .toList(),
                        onSearchTextChanged: (txt) => con.currencies
                            .where((c) =>
                                c.symbol
                                    .toLowerCase()
                                    .contains(txt!.toLowerCase()) ||
                                c.name
                                    .toLowerCase()
                                    .contains(txt.toLowerCase()))
                            .map((c) => SearchFieldListItem(
                                  '${c.symbol} – ${c.name}',
                                  item: c,
                                ))
                            .toList(),
                        onSuggestionTap: (s) {
                          _selectedCurrency = s.item;
                          _currencyCtrl.text = s.item!.symbol;
                        },
                        searchInputDecoration: SearchInputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Currency',
                          labelStyle: TextStyle(color: _grey),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset('assets/icons/moneys.svg',
                                width: 24, color: _grey),
                          ),
                          border: _border(_grey),
                          enabledBorder: _border(_grey),
                          focusedBorder: _border(_grey),
                          suffix: const Icon(Icons.arrow_drop_down_sharp,
                              size: 32, color: Colors.black),
                        ),
                        validator: (_) =>
                            (_selectedCurrency ?? widget.account.currency)
                                    .toString()
                                    .isEmpty
                                ? 'Required'
                                : null,
                      ),

                      const SizedBox(height: 24),

                      /* زر Edit */
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              con.editAccount(
                                id: widget.account.id,
                                name: _nameCtrl.text.trim(),
                                typeId:
                                    (_selectedType ?? con.types.firstWhere((t) => t.id == widget.account.typeId)).id,
                                currency: _selectedCurrency?.symbol ??
                                    widget.account.currency,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black),
                          child: const Text('Edit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),

                      /* علامة توضيحية */
                      const Text('To deactivate the account',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),

                      const SizedBox(height: 8),

                      /* زر Deactivate */
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => con.deactivateAccount(widget.account.id),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              foregroundColor: Colors.white),
                          child: const Text('Deactivate'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}
