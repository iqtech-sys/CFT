import 'package:cftracker_app/app/pages/add_account/add_account_presenter.dart';
import 'package:cftracker_app/data/repositories/account/data_account_type_repo.dart';
import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';
import 'package:cftracker_app/domain/usecase/account/add_account_usecase.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddAccountController extends Controller {

  // final AccountTypeRepository _typeRepo;
  // final PaymentAccountRepository _accRepo;

  List<PaymentAccount> accounts = [];
  bool isAdding = false;
  Exception? addError;

  String? newAccountId;

  String? _newAccountId;

  bool isLoading = false;
  List<AccountType> types = [];

  final AddAccountPresenter _presenter;

  final AccountTypeRepository _typeRepo;
  final PaymentAccountRepository _accRepo;

  AddAccountController() : _presenter = AddAccountPresenter(AddAccountUseCase(DataAccountTypeRepository()),
                                                            GetAccountTypesUseCase(DataAccountTypeRepository())),
                                                            _typeRepo = DataAccountTypeRepository(),
                                                            _accRepo = DataAccountRepository();


  /* ───────────── عمليات الإضافة ───────────── */
  void addAccount(String name, String typeId, String currency) {
    isAdding = true;
    addError = null;
    refreshUI();

    final params = AccountType(
      id:
      DateTime.now().millisecondsSinceEpoch
          .toString(), // أو اتركه فارغًا ويولده الـ repo
      name: name,
      currency: currency,
    );
    _presenter.addAccount(params);
  }

  /* ───────────── عمليات الإضافة ───────────── */
  void _onAddNext(String? id) => _newAccountId = id;

  void _onAddComplete() {
    // أعد جلب القائمة لتظهر البطاقة الجديدة
    _presenter.getAccountTypes();
    isAdding = false;
    refreshUI();
  }




  void _onData(List<AccountType> list) {
    types = list;
    isLoading = false;
    refreshUI();
  }

  void _onError(dynamic e) {
    print('Error: $e');
    types = [];
    isLoading = false;
    refreshUI();
  }

  void _onAddError(e) {
    isAdding = false;
    addError = e;
    refreshUI();
  }

  @override
  void initListeners() {
    isLoading = true;
    refreshUI();

    // أولا: جلب أنواع الحسابات
    _typeRepo
        .getAccountTypes()
        .then((tList) {
      types = tList;
      // ثانياً: جلب الحسابات
      return _accRepo.getPaymentAccounts();
    })
        .then((aList) {
      accounts = aList;
      isLoading = false;
      refreshUI();
    })
        .catchError((e) {
      isLoading = false;
      refreshUI();
    });
  }

}