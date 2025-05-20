import 'package:cftracker_app/data/repositories/home/data_account_repo.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';
import 'package:cftracker_app/domain/usecase/home/get_payment_accounts_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../domain/entities/home/payment_account.dart';
import 'home_presenter.dart';

class HomeController extends Controller {
  final HomePresenter _presenter;
  List<PaymentAccount> accounts = [];
  final PaymentAccountRepository accountRepository;
    bool? isFilterActive; // true = Active، false = Inactive

  void loadAccounts() {
    _presenter.getAccounts();
  }
  void setFilter(bool? active) {
    isFilterActive = active;
    refreshUI();
  }
  HomeController()
      :  accountRepository =DataAccountRepository(),
      _presenter = HomePresenter(
            GetPaymentAccountsUseCase(DataAccountRepository()));

  @override
  void initListeners() {
    _presenter
      ..getAccountsOnNext = _onAccountsRetrieved
      ..getAccountsOnError = _onError ;

    _presenter.getAccounts();
  }
  void _onAccountsRetrieved(List<PaymentAccount> list) {
    accounts = list;
    refreshUI();
  }

  void _onError(dynamic e) {
    print('Error: $e');
    refreshUI();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }
  

}
