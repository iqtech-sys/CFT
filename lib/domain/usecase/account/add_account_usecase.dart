
import 'dart:async';
import 'package:cftracker_app/domain/entities/account/account_type.dart';
import 'package:cftracker_app/domain/repositories/account/account_type_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class AddAccountUseCase
    extends UseCase<String?, AccountType?> {

  final AccountTypeRepository _repo;

  AddAccountUseCase(this._repo);

  @override
  Future<Stream<String?>> buildUseCaseStream(AccountType? params) async {
    final controller = StreamController<String?>();
    try {
      if (params == null) {
        throw ArgumentError("Params cannot be null");
      }
      final String result = await _repo.addAccount(params);
      controller.add(result);
      controller.close();
    } catch (e, st) {
      controller.addError(e, st);
    }
    return controller.stream;
  }
}
