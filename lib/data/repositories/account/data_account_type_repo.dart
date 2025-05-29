import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';
class DataAccountTypeRepository implements AccountTypeRepository {
  DataAccountTypeRepository._();
  static final _instance = DataAccountTypeRepository._();
  factory DataAccountTypeRepository() => _instance;

  final List<AccountType> _accountTypes = [
    const AccountType(id: 'PAY', name: 'Payment'),
    const AccountType(id: 'INC', name: 'Income'),
    const AccountType(id: 'DEP', name: 'Deposit'),
  ];

  @override
  Future<List<AccountType>> getAccountTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _accountTypes;
  }

  @override
  Future<String> addAccount(AccountType params) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _accountTypes.add(params);
    return params.id;
  }
}
