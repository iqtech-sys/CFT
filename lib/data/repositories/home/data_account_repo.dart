import 'package:cftracker_app/domain/entities/home/payment_account.dart';
import 'package:cftracker_app/domain/repositories/home/payment_account_repository.dart';
class DataAccountRepository implements PaymentAccountRepository {
  final List<PaymentAccount> _accounts = [
    // Payment
    const PaymentAccount(
      id: '01', name: 'Wallet USD', currency: 'USD',
      balance: 120.0, isActive: true, typeId: 'PAY'),
    const PaymentAccount(
      id: '02', name: 'Bank GBP', currency: 'GBP',
      balance: 350.0, isActive: true, typeId: 'PAY'),

    // Income (سالبة)
    const PaymentAccount(
      id: '03', name: 'Salary EUR', currency: 'EUR',
      balance: -2500.0, isActive: true, typeId: 'INC'),

    // Deposit
    const PaymentAccount(
      id: '04', name: 'Fixed Deposit', currency: 'USD',
      balance: 5000.0, isActive: false, typeId: 'DEP'),
  ];

  @override
  Future<List<PaymentAccount>> getPaymentAccounts() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _accounts;
  }
}
