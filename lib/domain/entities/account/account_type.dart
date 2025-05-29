
class AccountType {
  final String id;        // PAY | INC | DEP
  final String name;      // Payment | Income | Deposit
  final String currency;

  const AccountType({
    required this.id,
    required this.name,
    this.currency = '',
  });


  AccountType copyWith({String? id, String? name, String? currency}) {
    return AccountType(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
    );
  }
}
