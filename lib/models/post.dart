class Post {
  final String id;
  final String username;
  final DateTime createdAt;
  final String text;
  final String imageUrl;

  Post({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.text,
    required this.imageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      createdAt: DateTime.parse(json['createdAt']),
      text: json['text'],
      imageUrl: json['imageUrl'],
    );
  }
}
