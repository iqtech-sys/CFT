// lib/app/presenters/accounts_presenter.dart

import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/usecase/account/add_account_usecase.dart';
import 'package:cftracker_app/domain/usecase/account/get_account_types_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class AccountsPresenter extends Presenter {
  // للمجموعات
  final GetAccountTypesUseCase _useCase;
  Function? onNext;
  Function? onError;
  Function? onComplete;

  // للإضافة
  final AddAccountUseCase _addUseCase;
  Function? onAddNext;
  Function? onAddError;
  Function? onAddComplete;

  // البناء يأخذ use cases الاثنين
  AccountsPresenter(this._useCase, this._addUseCase);

void getAccountTypes() {
  _useCase.execute(_AccountsObserver(this)); 
}

  /// يضيف حساب جديد
  void addAccount(AccountType params) {
    _addUseCase.execute(_AddObserver(this), params);
  }

  @override
  void dispose() {
    // تأكد من تحرير الاثنين
    _useCase.dispose();
    _addUseCase.dispose();
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


class _AddObserver extends Observer<String?> {
  final AccountsPresenter presenter;
  _AddObserver(this.presenter);

  @override
  void onComplete() => presenter.onAddComplete?.call();

  @override
  void onError(e) => presenter.onAddError?.call(e as Exception);

  @override
  void onNext(String? id) => presenter.onAddNext?.call(id);
}


