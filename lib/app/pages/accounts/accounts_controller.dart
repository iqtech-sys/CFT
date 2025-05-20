import 'package:cftracker_app/data/repositories/account/data_account_type_repo.dart';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'accounts_presenter.dart';

class AccountsController extends Controller {
  final AccountsPresenter _presenter;
  List<AccountType> types = [];

  AccountsController()
      : _presenter = AccountsPresenter(
          GetAccountTypesUseCase(DataAccountTypeRepository()),
        );

  @override
  void initListeners() {
    _presenter
      ..onNext = _onData
      ..onError = _onError;

    _presenter.getAccountTypes();//
  }

  void _onData(List<AccountType> list) {
    types = list;
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
