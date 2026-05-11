class Cast {
  final int id;
  final String name;
  final String? profilePath;
  final String character;
  final int order;

  Cast({
    required this.id,
    required this.name,
    this.profilePath,
    required this.character,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
      character: json['character'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}
