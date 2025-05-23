import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';

class DataAccountTypeRepository implements AccountTypeRepository {
  final List<AccountType> _accountTypes = [];

  @override
  Future<List<AccountType>> getAccountTypes() async {
    await Future.delayed(const Duration(milliseconds: 400)); // محاكاة زمن شبكة
    if (_accountTypes.isEmpty) {
      _accountTypes.addAll([
        const AccountType(id: 'USD', name: 'US Dollar', currency: 'USD'),
        const AccountType(id: 'EUR', name: 'Euro',       currency: 'EUR'),
        const AccountType(id: 'GBP', name: 'British Pound', currency: 'GBP'),
      ]);

    }
    return _accountTypes;
  }

    @override
  Future<String> addAccount(AccountType params) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _accountTypes.add(params);
    return params.id;
  }
}
