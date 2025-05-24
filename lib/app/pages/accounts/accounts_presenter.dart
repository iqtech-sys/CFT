import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class AccountsPresenter extends Presenter {
  // للمجموعات
  final GetAccountTypesUseCase _useCase;
  Function? onNext;
  Function? onError;
  Function? onComplete;



  // البناء يأخذ use cases الاثنين
  AccountsPresenter(this._useCase);


  @override
  void dispose() {
    // تأكد من تحرير الاثنين
    _useCase.dispose();

  }
}

class _AccountsObserver extends Observer<List<AccountType>> {
  final AccountsPresenter presenter;

  _AccountsObserver(this.presenter);

  @override
  void onComplete() => presenter.onComplete?.call();

  @override
  void onError(e) => presenter.onError?.call(e);

  @override
  void onNext(List<AccountType>? response) {
    if (response == null) return;
    presenter.onNext?.call(response);
  }
}
