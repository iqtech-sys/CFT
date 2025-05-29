
class PaymentTransaction {
  final DateTime dateTime;
  final String type;         // e.g. "Topup" أو "Payment"
  final String description;  // e.g. "Care" أو "BIM"
  final double amount;       // موجب للـ top-up، سالب للـ payment
  final String currency;     // "USD", "TRY", ...

  PaymentTransaction({
    required this.dateTime,
    required this.type,
    required this.description,
    required this.amount,
    required this.currency,
  });
}
