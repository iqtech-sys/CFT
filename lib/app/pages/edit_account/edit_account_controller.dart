import 'dart:convert';
import 'package:cftracker_app/data/repositories/account/data_account_type_repo.dart';
import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/entities/add_account/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EditAccountController extends Controller {
  EditAccountController();

  /* الحالة */
  List<AccountType> types      = [];
  List<Currency>    currencies = [];

  bool isBusy = false;

  final _typeRepo = DataAccountTypeRepository();
  final _accRepo  = DataAccountRepository();    // تنفيذ وهمي للتجربة

  @override
  void initListeners() => _initData();

  Future<void> _initData() async {
    isBusy = true; refreshUI();
    types = await _typeRepo.getAccountTypes();
    await _loadCurrencies();
    isBusy = false; refreshUI();
  }

  Future<void> _loadCurrencies() async {
    final jsonStr = await rootBundle.loadString('assets/currencies.json');
    final list = (json.decode(jsonStr)['Currencies'] as List)
        .map((e) => Currency.fromJson(e))
        .toList();
    currencies = list;
  }

  /* تعديل */
  Future<void> editAccount({
    required String id,
    required String name,
    required String typeId,
    required String currency,
  }) async {
    // TODO: استدعِ UseCase التعديل الفعلي هنا
    print('EDIT  -> $id  $name  $typeId  $currency');
  Navigator.pop(getContext(), true); 
  }

  /* تعطيل */
  Future<void> deactivateAccount(String id) async {
  print('DEACTIVATE  -> $id');
  Navigator.pop(getContext(), true); }
}
