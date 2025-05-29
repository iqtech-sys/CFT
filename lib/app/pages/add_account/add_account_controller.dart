import 'dart:convert';

import 'package:cftracker_app/app/pages/add_account/add_account_presenter.dart';
import 'package:cftracker_app/data/repositories/account/data_account_type_repo.dart';
import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/entities/add_account/currency.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';
import 'package:cftracker_app/domain/usecase/account/add_account_usecase.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter/services.dart' show rootBundle;          // <-- جديد
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/material.dart';

class AddAccountController extends Controller {
  /* ─────────── بيانات الحالة ─────────── */
  List<AccountType>      types      = [];
  List<PaymentAccount>   accounts   = [];
  List<Currency>         currencies = [];

  bool       isLoading  = true;     // تحميل الأنواع + العملات
  bool       isAdding   = false;    // أثناء إضافة حساب
  Exception? addError;
  String?    newAccountId;

  /* ─────────── Repos & Presenter ─────────── */
  final AccountTypeRepository      _typeRepo;
  final PaymentAccountRepository   _accRepo;
  final AddAccountPresenter        _presenter;

  AddAccountController()
      : _typeRepo   = DataAccountTypeRepository(),
        _accRepo    = DataAccountRepository(),
        _presenter  = AddAccountPresenter(
                        AddAccountUseCase(DataAccountTypeRepository()),
                        GetAccountTypesUseCase(DataAccountTypeRepository()),
                      ) {
    _presenter
      ..onAddNext     = _onAddNext
      ..onAddError    = _onAddError
      ..onAddComplete = _onAddComplete
      ..onNext        = _onData
      ..onError       = _onError;
  }

  /* ─────────── دورة الحياة ─────────── */
  @override
  void initListeners() {
    _loadEverything();   // تجميع كل المطلوب
  }

  Future<void> _loadEverything() async {
    isLoading = true;
    refreshUI();

    try {
      // 1) أنواع الحسابات
      types    = await _typeRepo.getAccountTypes();

      // 2) الحسابات الموجودة
      accounts = await _accRepo.getPaymentAccounts();

      // 3) ملف العملات من الـ assets
      await _loadCurrenciesFromAsset();
    } catch (e) {
      _onError(e);
    }

    isLoading = false;
    refreshUI();
  }

  Future<void> _loadCurrenciesFromAsset() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/currencies.json');
      final data    = json.decode(jsonStr) as Map<String, dynamic>;
      final list    = data['Currencies'] as List<dynamic>;

      currencies = list
          .map((m) => Currency.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // في حال وجود خطأ في الملف سنترك القائمة فارغة
      currencies = [];
    }
  }

  /* ─────────── إضافة حساب جديد ─────────── */
  void addAccount(String name, String typeId, String currency) {
    isAdding = true;
    refreshUI();

    final params = AccountType(
      id:  DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      currency: currency,          // الرمز المختار (مثل AED)
    );

    _presenter.addAccount(params);
  }

  /* ─────────── Callbacks من الـ Presenter ─────────── */
  void _onData(List<AccountType> list) {
    // يُستعمل فقط لو أردت جلب الأنواع عبر الـ UseCase
    types = list;
    refreshUI();
  }

  void _onError(dynamic e) {
    types = [];
    addError = e is Exception ? e : Exception(e.toString());
    refreshUI();
  }

  /* إضافة */
  void _onAddNext(String? id) => newAccountId = id;

  void _onAddComplete() {
    isAdding = false;
    refreshUI();
    Navigator.pop(getContext(), true);   // رجوع للصفحة السابقة مع success
  }

  void _onAddError(e) {
    isAdding = false;
    addError = e is Exception ? e : Exception(e.toString());
    refreshUI();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }
}
