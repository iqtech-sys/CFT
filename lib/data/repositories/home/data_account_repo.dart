import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';

class DataAccountRepository implements PaymentAccountRepository {
  final List<PaymentAccount> _paymentAccount = [];

  @override
  Future<List<PaymentAccount>> getPaymentAccounts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_paymentAccount.isEmpty) {
      _paymentAccount.addAll([
        PaymentAccount(
          id: '1',
          name: 'Payment USD',
          currency: 'USD',
          isActive: true,
          balance: 10.0,
        ),
        PaymentAccount(
          id: '2',
          name: 'Payment EUR',
          currency: 'EUR',
          balance: 36.50,
          isActive: true,
        ),
        PaymentAccount(
          id: '3',
          name: 'Expense GBP',
          currency: 'GBP',
          isActive: false,
          balance: 47.30,
        ),
        PaymentAccount(
          id: '1',
          name: 'Payment USD',
          currency: 'USD',
          isActive: false,
          balance: -28.0,
        ),
        PaymentAccount(
          id: '5',
          name: 'Payment EUR',
          currency: 'EUR',
          balance: -15.0,isActive: false,
        ),
        PaymentAccount(
          id: '6',
          name: 'Expense GBP',
          currency: 'GBP',isActive: false,
          balance: 0.0,
        ),
      ]);
    }
    return _paymentAccount;
  }
}
