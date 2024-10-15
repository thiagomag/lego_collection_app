class LegoSet {
  final int? id;
  final String name;
  final String officialPage;
  final List<String> imagePaths;
  final int pieces;
  final double price;

  LegoSet({
    this.id,
    required this.name,
    required this.officialPage,
    required this.imagePaths,
    required this.pieces,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'officialPage': officialPage,
      'imagePaths': imagePaths.join(','),
      'pieces': pieces,
      'price': price,
    };
  }

  static LegoSet fromMap(Map<String, dynamic> map) {
    return LegoSet(
      id: map['id'],
      name: map['name'],
      officialPage: map['officialPage'],
      imagePaths: (map['imagePaths'] as String).split(','),
      pieces: map['pieces'],
      price: map['price'],
    );
  }
}
