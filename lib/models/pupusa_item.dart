class PupusaItem {
  final String id;
  String name;
  String description;
  double price;
  bool isActive;

  PupusaItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'isActive': isActive,
      };

  factory PupusaItem.fromJson(Map<String, dynamic> json) => PupusaItem(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        isActive: json['isActive'] ?? true,
      );
}