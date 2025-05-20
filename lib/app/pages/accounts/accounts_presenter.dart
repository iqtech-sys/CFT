import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class AccountsPresenter extends Presenter {
  Function? onNext;
  Function? onComplete;
  Function? onError;

  final GetAccountTypesUseCase _useCase;
  AccountsPresenter(this._useCase);

  void getAccountTypes() =>
      _useCase.execute(_AccountsObserver(this), null);

  @override
  void dispose() => _useCase.dispose();
}

class _AccountsObserver extends Observer<List<AccountType>> {
  final AccountsPresenter presenter;
  _AccountsObserver(this.presenter);

  @override
  void onComplete() => presenter.onComplete?.call();

  @override
  void onError(e) => presenter.onError?.call(e);

  @override
  void onNext(List<AccountType>? response) =>
      presenter.onNext?.call(response);
}
