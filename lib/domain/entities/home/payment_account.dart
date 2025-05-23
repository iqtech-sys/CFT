class PaymentAccount {
  final String id;
  final String name;
  final String currency;
  final double balance;
   final bool isActive;

  const PaymentAccount({
    required this.id,
    required this.name,
    required this.currency,
    required this.isActive, 
    required this.balance,
  });

  PaymentAccount copyWith({
    String? id,
    String? name,
    String? currency,
    double? balance,
    bool? isActive,
  }) {
    return PaymentAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      isActive:  isActive ?? this.isActive,
    );
  }
}
