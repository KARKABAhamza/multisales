/// FAQ item model for MultiSales app
class FaqItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final List<String> tags;
  final bool isHelpful;
  final int viewCount;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.tags = const [],
    this.isHelpful = false,
    this.viewCount = 0,
    this.helpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create FaqItem from Firestore document
  factory FaqItem.fromMap(Map<String, dynamic> map) {
    return FaqItem(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      isHelpful: map['isHelpful'] ?? false,
      viewCount: map['viewCount'] ?? 0,
      helpfulCount: map['helpfulCount'] ?? 0,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert FaqItem to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'tags': tags,
      'isHelpful': isHelpful,
      'viewCount': viewCount,
      'helpfulCount': helpfulCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  FaqItem copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    List<String>? tags,
    bool? isHelpful,
    int? viewCount,
    int? helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isHelpful: isHelpful ?? this.isHelpful,
      viewCount: viewCount ?? this.viewCount,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if FAQ item matches search query
  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();
    return question.toLowerCase().contains(lowerQuery) ||
        answer.toLowerCase().contains(lowerQuery) ||
        tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  /// Get popularity score based on views and helpful count
  double get popularityScore {
    if (viewCount == 0) return 0.0;
    return (helpfulCount / viewCount) * 100;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FaqItem(id: $id, question: $question)';
}

/// Help resource model for guides and documentation
class HelpResource {
  final String id;
  final String title;
  final String content;
  final String category;
  final String type; // guide, video, document, tutorial
  final String? url;
  final String? thumbnailUrl;
  final List<String> tags;
  final int difficulty; // 1-5 scale
  final int estimatedReadTime; // in minutes
  final bool isFeatured;
  final int viewCount;
  final double rating;
  final int ratingCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  HelpResource({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.type,
    this.url,
    this.thumbnailUrl,
    this.tags = const [],
    this.difficulty = 1,
    this.estimatedReadTime = 5,
    this.isFeatured = false,
    this.viewCount = 0,
    this.rating = 0.0,
    this.ratingCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create HelpResource from Firestore document
  factory HelpResource.fromMap(Map<String, dynamic> map) {
    return HelpResource(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? '',
      type: map['type'] ?? 'guide',
      url: map['url'],
      thumbnailUrl: map['thumbnailUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      difficulty: map['difficulty'] ?? 1,
      estimatedReadTime: map['estimatedReadTime'] ?? 5,
      isFeatured: map['isFeatured'] ?? false,
      viewCount: map['viewCount'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      ratingCount: map['ratingCount'] ?? 0,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert HelpResource to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'tags': tags,
      'difficulty': difficulty,
      'estimatedReadTime': estimatedReadTime,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
      'rating': rating,
      'ratingCount': ratingCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  HelpResource copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? type,
    String? url,
    String? thumbnailUrl,
    List<String>? tags,
    int? difficulty,
    int? estimatedReadTime,
    bool? isFeatured,
    int? viewCount,
    double? rating,
    int? ratingCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HelpResource(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      estimatedReadTime: estimatedReadTime ?? this.estimatedReadTime,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get difficulty text
  String get difficultyText {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Easy';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Unknown';
    }
  }

  /// Get type icon
  String get typeIcon {
    switch (type.toLowerCase()) {
      case 'video':
        return 'play_circle_outline';
      case 'document':
        return 'description';
      case 'tutorial':
        return 'school';
      case 'guide':
      default:
        return 'menu_book';
    }
  }

  /// Check if resource matches search query
  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        content.toLowerCase().contains(lowerQuery) ||
        tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelpResource &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'HelpResource(id: $id, title: $title, type: $type)';
}
