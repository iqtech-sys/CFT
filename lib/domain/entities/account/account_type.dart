class AccountType {
  final String id;
  final String name;

  const AccountType({
    required this.id,
    required this.name,
  });

  AccountType copyWith({
    String? id,
    String? name,
  }) {
    return AccountType(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
