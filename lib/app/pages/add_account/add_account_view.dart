import 'package:cftracker_app/app/pages/add_account/add_account_controller.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 2) نجعلها CleanView مربوطة بالكونترولر
class AddAccountView extends CleanView {

  const AddAccountView({Key? key}) : super(key: key);

  @override
  _AddAccountViewState createState() => _AddAccountViewState();
}
class _AddAccountViewState extends CleanViewState<AddAccountView, AddAccountController> {

  late AddAccountController con;


  _AddAccountViewState() : super(AddAccountController());

  final _formKey = GlobalKey<FormState>();
  String? _accountName;
  String? _currency;
  AccountType? _selectedType;

  final List<String> _currencies = ['USD', 'EUR', 'GBP'];

  // لون فضي موحّد
  final Color _grey = Colors.grey;

  @override
  Widget get view {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),           // أيقونة الرجوع بيضاء
        title: const Text('Add account'),
        titleTextStyle: const TextStyle(
          color: Colors.white,                                          // نص العنوان أبيض
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
                            color: _grey,                             // الأيقونة فضية
                          ),
                        ),
                      ),
                      onSaved: (v) => _accountName = v,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
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
                            color: _grey,                             // الأيقونة فضية
                          ),
                        ),
                      ),
                      items: controller.types
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
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Currency',
                        labelStyle: TextStyle(color: _grey),
                        border: _border(_grey),
                        enabledBorder: _border(_grey),
                        focusedBorder: _border(_grey),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/icons/moneys.svg',
                            width: 24,
                            height: 24,
                            color: _grey,                             // الأيقونة فضية
                          ),
                        ),
                      ),
                      items: _currencies
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => _currency = v,
                      validator: (v) => v == null ? 'Required' : null,
                    ),

                    const SizedBox(height: 24),

                    // زر Save
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState!.save();
                            controller.addAccount(
                              _accountName!,
                              _selectedType!.id,
                              _currency!,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,             // خلفية صفراء
                          foregroundColor: Colors.black,              // نص أسود
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
