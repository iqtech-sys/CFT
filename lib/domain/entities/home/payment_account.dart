class PaymentAccount {
  final String id;
  final String name;
  final String currency;
  final double balance;

  const PaymentAccount({
    required this.id,
    required this.name,
    required this.currency,
    required this.balance,
  });

  PaymentAccount copyWith({
    String? id,
    String? name,
    String? currency,
    double? balance,
  }) {
    return PaymentAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
    );
  }
}
