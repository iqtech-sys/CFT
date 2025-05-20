
import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/usecase/home/get_payment_accounts_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomePresenter extends Presenter {

  Function? getAccountsOnNext;
  Function? getAccountsOnComplete;
  Function? getAccountsOnError;
  final GetPaymentAccountsUseCase _getAccountsUseCase;

  HomePresenter(this._getAccountsUseCase);

  void getAccounts() {
    _getAccountsUseCase.execute(_GetAccountsUseCaseObserver(this),null);
  }

  @override
  void dispose() {
    _getAccountsUseCase.dispose();
  }
}

class _GetAccountsUseCaseObserver extends Observer<List<PaymentAccount>> {
  final HomePresenter _presenter;
  _GetAccountsUseCaseObserver(this._presenter);

  @override
  void onComplete() {_presenter.getAccountsOnComplete?.call();}

  @override
  void onError(error) {_presenter.getAccountsOnError?.call(error);}

  @override
  void onNext(List<PaymentAccount>? response) {_presenter.getAccountsOnNext?.call(response);}
}
