class Chopp {
  final String id;
  final String name;
  final double price;
  final bool available;
  final String? description;
  final String? imageUrl;
  final String? updatedBy;


  Chopp({
    required this.id,
    required this.name,
    required this.price,
    required this.available,
    this.description,
    this.imageUrl,
    this.updatedBy,
  });


  factory Chopp.fromMap(String id, Map<String, dynamic> data) {
    return Chopp(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      available: data['available'] ?? false,
      description: data['description'],
      imageUrl: data['imageUrl'],
      updatedBy: data['updatedBy'],
    );
  }


  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'available': available,
    'description': description,
    'imageUrl': imageUrl,
    'updatedBy': updatedBy,
  };
}