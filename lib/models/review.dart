class Review {
  final String id;
  final String author;
  final String content;
  final String? avatarPath;
  final double? rating;
  final String createdAt;

  Review({
    required this.id,
    required this.author,
    required this.content,
    this.avatarPath,
    this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final authorDetails = json['author_details'] as Map<String, dynamic>?;
    return Review(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      avatarPath: authorDetails?['avatar_path'],
      rating: authorDetails?['rating'] != null
          ? (authorDetails!['rating'] as num).toDouble()
          : null,
      createdAt: json['created_at'] ?? '',
    );
  }
}
