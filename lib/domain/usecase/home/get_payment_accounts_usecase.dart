import 'dart:async';

import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetPaymentAccountsUseCase extends UseCase<List<PaymentAccount>, void> {
  final PaymentAccountRepository _accountRepository;
  GetPaymentAccountsUseCase(this._accountRepository);

  @override
  Future<Stream<List<PaymentAccount>>> buildUseCaseStream(void params) async {
    final controller = StreamController<List<PaymentAccount>>();
    try {
      List<PaymentAccount> customers = await _accountRepository.getPaymentAccounts();
      controller.add(customers);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetCustomersUseCaseParams {
  GetCustomersUseCaseParams();
}

