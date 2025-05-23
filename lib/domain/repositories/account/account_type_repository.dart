
import 'package:cftracker_app/domain/entities/account/account_type.dart';

abstract class AccountTypeRepository {
  Future<List<AccountType>> getAccountTypes();
  Future<String> addAccount(AccountType params);
}
