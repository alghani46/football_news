class NewsEntry {
  final String id;
  final String title;
  final String content;
  final String category;
  final String thumbnail;
  final bool isFeatured;
  final DateTime createdAt;
  final int newsViews;

  NewsEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.thumbnail,
    required this.isFeatured,
    required this.createdAt,
    required this.newsViews,
  });

  factory NewsEntry.fromJson(Map<String, dynamic> json) {
    return NewsEntry(
      id: (json['id'] ?? json['pk'] ?? json['uuid'] ?? '').toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      isFeatured: json['is_featured'] == true || json['isFeatured'] == true,
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      newsViews: (json['news_views'] ?? json['newsViews'] ?? 0) as int,
    );
  }

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final s = v.toString();
    // Handle "+0000" vs "+00:00"
    if (RegExp(r'\+\d{4}$').hasMatch(s)) {
      final fixed = s.replaceFirst(RegExp(r'\+(\d{2})(\d{2})$'), r'+$1:$2');
      return DateTime.parse(fixed);
    }
    return DateTime.parse(s);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'thumbnail': thumbnail,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'news_views': newsViews,
    };
  }
}
