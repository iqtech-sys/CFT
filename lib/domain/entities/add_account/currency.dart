class Currency {
  final int    id;
  final String symbol;
  final String name;
  final String flag;

  Currency({required this.id, required this.symbol, required this.name, required this.flag});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id:     json['id']     as int,
        symbol: json['symbol'] as String,
        name:   json['name']   as String,
        flag:   json['flag']   as String,
      );

  @override
  String get label => '$name - $symbol';
}
