import 'package:cftracker_app/app/pages/accounts/accounts_presenter.dart';
import 'package:cftracker_app/app/widgets/account/filter_bottom_sheet.dart';
import 'package:cftracker_app/data/repositories/account/data_account_type_repo.dart';
import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';

class AccountsController extends Controller {



    String _searchTerm = '';
  AccountFilter? _selectedFilter;

  // getters ليستعملها الـ View
  String  get searchTerm      => _searchTerm;
  AccountFilter? get selectedFilter => _selectedFilter;

  /// قائمة الحسابات بعد تطبيق البحث + الفلتر
  List<PaymentAccount> get filteredAccounts {
    Iterable<PaymentAccount> out = accounts;

    /* أولاً: الفلترة */
    switch (_selectedFilter) {
      case AccountFilter.active:
        out = out.where((a) => a.isActive);
        break;
      case AccountFilter.inactive:
        out = out.where((a) => !a.isActive);
        break;
      case AccountFilter.positive:
        out = out.where((a) => a.balance >= 0);
        break;
      case AccountFilter.negative:
        out = out.where((a) => a.balance < 0);
        break;
      case null:
        break;
    }

    /* ثانياً: البحث (يُطبَّق فوق نتيجة الفلتر) */
    if (_searchTerm.isNotEmpty) {
      final q = _searchTerm.toLowerCase();
      out = out.where((a) =>
          a.name.toLowerCase().contains(q) ||
          a.currency.toLowerCase().contains(q));
    }

    return out.toList();
  }
  

  final AccountTypeRepository _typeRepo;
  final PaymentAccountRepository _accRepo;

  List<PaymentAccount> accounts = [];

    bool isLoading = false;
    List<AccountType> types = [];

  final AccountsPresenter _presenter;


  AccountsController()
    : _presenter = AccountsPresenter(GetAccountTypesUseCase(DataAccountTypeRepository())),
      _typeRepo = DataAccountTypeRepository(),
      _accRepo = DataAccountRepository();

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

  void setSearch(String term) {
    _searchTerm = term.trim();
    refreshUI();
  }

  
  /// خصم مبلغ من حساب Income وإضافته إلى حساب الاستقبال
  void topUp({
    required String receiveId,
    required String incomeId,
    required double amount,
  }) {
    // أنشئ قائمة جديدة مع تعديل الرصيد (لأن الحقول final)
    accounts = accounts.map((acc) {
      if (acc.id == incomeId)  return acc.copyWith(balance: acc.balance - amount);
      if (acc.id == receiveId) return acc.copyWith(balance: acc.balance + amount);
      return acc;
    }).toList();

    refreshUI();
  }

  void setFilter(AccountFilter? newFilter) {
    _selectedFilter = newFilter;
    refreshUI();
  }





  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }
}
