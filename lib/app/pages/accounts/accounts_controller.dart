import 'package:cftracker_app/app/pages/accounts/accounts_presenter.dart';
import 'package:cftracker_app/app/widgets/account/filter_bottom_sheet.dart';
import 'package:cftracker_app/data/repositories/account/data_account_type_repo.dart';
import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';
import 'package:cftracker_app/domain/usecase/account/add_account_usecase.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';

class AccountsController extends Controller {
  bool isAdding = false;
  String? newAccountId;
  Exception? addError;
  String? _newAccountId;


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

  final AccountsPresenter _presenter;
  List<AccountType> types = [];

  AccountsController()
    : _presenter = AccountsPresenter(
        GetAccountTypesUseCase(DataAccountTypeRepository()),
        AddAccountUseCase(DataAccountTypeRepository()),
      ),
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

  void setFilter(AccountFilter? newFilter) {
    _selectedFilter = newFilter;
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

  void _onAddNext(String? id) => _newAccountId = id;

  void _onAddComplete() {
    // أعد جلب القائمة لتظهر البطاقة الجديدة
    _presenter.getAccountTypes();
    isAdding = false;
    refreshUI();
  }

  void _onAddError(e) {
    isAdding = false;
    addError = e;
    refreshUI();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }
}
