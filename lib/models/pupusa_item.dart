class PupusaItem {
  final String id;
  String name; // Se removió 'final'
  String description; // Se removió 'final'
  double price;
  bool isActive;

  PupusaItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.isActive = true,
  });
}