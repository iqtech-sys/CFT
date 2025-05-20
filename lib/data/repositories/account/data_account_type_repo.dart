import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';

class DataAccountTypeRepository implements AccountTypeRepository {
  final List<AccountType> _accountTypes = [];

  @override
  Future<List<AccountType>> getAccountTypes() async {
    await Future.delayed(const Duration(milliseconds: 400)); // محاكاة زمن شبكة
    if (_accountTypes.isEmpty) {
_accountTypes.addAll([
  const AccountType(id: 'USD', name: 'US Dollar'),
  const AccountType(id: 'EUR', name: 'Euro'),
  const AccountType(id: 'GBP', name: 'British Pound'),
]);

    }
    return _accountTypes;
  }
}
