import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/usecase/account/add_account_usecase.dart';
import 'package:cftracker_app/domain/usecase/account/edit_account_usecase.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EditAccountPresenter extends Presenter {

  // للمجموعات
  final GetAccountTypesUseCase _useCase;
  Function? onNext;
  Function? onError;
  Function? onComplete;

  // للإضافة
  final EditAccountUseCase _addUseCase;
  Function? onAddNext;
  Function? onAddError;
  Function? onAddComplete;

  EditAccountPresenter(this._addUseCase, this._useCase);

  /// يضيف حساب جديد
  void addAccount(AccountType params) {
    _addUseCase.execute(_AddObserver(this), params);
  }


  void getAccountTypes() {
    _useCase.execute(_AccountsObserver(this));
  }

  @override
  void dispose() {
    _addUseCase.dispose();
  }
}

class _AddObserver extends Observer<String?> {
  final EditAccountPresenter presenter;
  _AddObserver(this.presenter);

  @override
  void onComplete() => presenter.onAddComplete?.call();

  @override
  void onError(e) => presenter.onAddError?.call(e as Exception);

  @override
  void onNext(String? id) => presenter.onAddNext?.call(id);
}


class _AccountsObserver extends Observer<List<AccountType>> {
  final EditAccountPresenter presenter;

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