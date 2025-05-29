class PaymentAccount {
  final String id;
  final String name;
  final String currency;     // USD ،EUR … إلخ
  final double balance;
  final bool   isActive;
  final String typeId;       // ‘PAY’ | ‘INC’ | ‘DEP’  <-- جديد

  const PaymentAccount({
    required this.id,
    required this.name,
    required this.currency,
    required this.balance,
    required this.isActive,
    required this.typeId,
  });


  /* ───────── copyWith ───────── */
  PaymentAccount copyWith({
    String?  id,
    String?  name,
    String?  currency,
    double?  balance,
    bool?    isActive,
    String?  typeId,
  }) {
    return PaymentAccount(
      id:        id        ?? this.id,
      name:      name      ?? this.name,
      currency:  currency  ?? this.currency,
      balance:   balance   ?? this.balance,
      isActive:  isActive  ?? this.isActive,
      typeId:    typeId    ?? this.typeId,
    );
  }
}
