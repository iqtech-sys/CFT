
import 'package:cftracker_app/domain/entities/home/payment_account.dart';

abstract class PaymentAccountRepository {
  Future<List<PaymentAccount>> getPaymentAccounts();
}
