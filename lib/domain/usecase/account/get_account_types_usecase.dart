import 'dart:async';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetAccountTypesUseCase extends UseCase<List<AccountType>, void> {

  final AccountTypeRepository _repository;
  GetAccountTypesUseCase(this._repository);

  @override
  Future<Stream<List<AccountType>>> buildUseCaseStream(void params) async {
    final controller = StreamController<List<AccountType>>();
    try {
      final result = await _repository.getAccountTypes();
      controller.add(result);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

