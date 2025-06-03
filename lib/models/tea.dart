class Tea {
  final int id;
  final String name;
  final String image;
  final String description;
  final String tasteType;
  final String aroma;
  final String color;

  const Tea({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.tasteType,
    required this.aroma,
    required this.color,
  });

  factory Tea.fromJson(Map<String, dynamic> json) {
    return Tea(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        description: json['description'],
        tasteType: json['tasteType'],
        aroma: json['aroma'],
        color: json['color']);
  }
}
