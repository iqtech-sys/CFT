class AccountType {
  final String id;
  final String name;
  final String currency;

  const AccountType({
    required this.id,
    required this.name,
    required this.currency,
  });

  AccountType copyWith({String? id, String? name, String? currency}) {
    return AccountType(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
    );
  }
}
