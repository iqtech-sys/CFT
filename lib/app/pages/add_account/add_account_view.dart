import 'package:cftracker_app/app/pages/add_account/add_account_controller.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/entities/add_account/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:searchfield/searchfield.dart';

/// 2) نجعلها CleanView مربوطة بالكونترولر
class AddAccountView extends CleanView {
  const AddAccountView({Key? key}) : super(key: key);

  @override
  _AddAccountViewState createState() => _AddAccountViewState();
}

class _AddAccountViewState
    extends CleanViewState<AddAccountView, AddAccountController> {
  late AddAccountController con;

  _AddAccountViewState() : super(AddAccountController());

  final _formKey = GlobalKey<FormState>();
  String? _accountName;
  Currency? _selectedCurrency;        
  AccountType? _selectedType;
    final TextEditingController _currencyCtrl = TextEditingController();


  // لون فضي موحّد
  final Color _grey = Colors.grey;

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Add account'),
        titleTextStyle: const TextStyle(
          color: Colors.white, // نص العنوان أبيض
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ControlledWidgetBuilder<AddAccountController>(
        builder: (context, controller) {
          this.con = controller;
          OutlineInputBorder _border(Color color) => OutlineInputBorder(
            borderSide: BorderSide(color: color),
            borderRadius: BorderRadius.circular(4),
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 1) Account name
                    TextFormField(
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
                          child: SvgPicture.asset(
                            'assets/icons/acc.svg',
                            width: 24,
                            height: 24,
                            color: _grey, // الأيقونة فضية
                          ),
                        ),
                      ),
                      onSaved: (v) => _accountName = v,
                      validator:
                          (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),

                    const SizedBox(height: 12),

                    // 2) Account type
                    DropdownButtonFormField<AccountType>(
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
                            height: 24,
                            color: _grey, // الأيقونة فضية
                          ),
                        ),
                      ),
                      items:
                          controller.types
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t.name),
                                ),
                              )
                              .toList(),
                      onChanged: (t) => _selectedType = t,
                      validator: (v) => v == null ? 'Required' : null,
                    ),

                    const SizedBox(height: 12),

                    // 3) Currency
                    SearchField<Currency>(
                      controller: _currencyCtrl,
                      enabled: true,
                      maxSuggestionsInViewPort: 6,
                      itemHeight: 45,
                      suggestionsDecoration:  SuggestionDecoration(
                        elevation: 2,
                        color: Colors.white,
                      ),
                      // 3-أ) جميع العملات كمقترحات
                      suggestions: controller.currencies
                          .map(
                            (c) => SearchFieldListItem<Currency>(
                              '${c.symbol} – ${c.name}',
                              item: c,                               // الضروري
                            ),
                          )
                          .toList(),

                      // 3-ب) فلترة المقترحات أثناء الكتابة
                      onSearchTextChanged: (value) {
                        return controller.currencies
                            .where((c) =>
                                c.symbol.toLowerCase().contains(value!.toLowerCase()) ||
                                c.name.toLowerCase().contains(value.toLowerCase()))
                            .map(
                              (c) => SearchFieldListItem<Currency>(
                                '${c.symbol} – ${c.name}',
                                item: c,
                              ),
                            )
                            .toList();
                      },

                      // 3-ج) ما يحدث عند اختيار عملة
                      onSuggestionTap: (SearchFieldListItem<Currency> e) {
                        _selectedCurrency = e.item;
                        _currencyCtrl.text = e.item!.symbol;
                        setState(() {});        // لإعادة البناء إذا لزم
                      },

                      // 3-د) Decoration يشابه الحقول الأخرى
                      searchInputDecoration: SearchInputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Currency',
                        labelStyle: TextStyle(color: _grey),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/icons/moneys.svg',
                            width: 24,
                            height: 24,
                            color: _grey,
                          ),
                        ),
                        border: _border(_grey),
                        enabledBorder: _border(_grey),
                        focusedBorder: _border(_grey),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 32,
                          color: Colors.black,
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),

                      // 3-هـ) التحقق من صحة الإدخال
                      validator: (value) {
                        if (_selectedCurrency == null) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // زر Save
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        // داخل AddAccountView - (استرجِع الكود السابق)
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            controller.addAccount(
                              _accountName!,
                              _selectedType!.id,
                              _selectedCurrency!.symbol,
                            );
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, // خلفية صفراء
                          foregroundColor: Colors.black, // نص أسود
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}
