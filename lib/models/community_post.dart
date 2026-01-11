/// Community topic categories
enum CommunityTopic {
  general,
  periodTalk,
  pcosPcod,
  pregnancy,
  wellness,
  mentalHealth,
  relationships,
}

extension CommunityTopicExtension on CommunityTopic {
  String get displayName {
    switch (this) {
      case CommunityTopic.general:
        return 'General';
      case CommunityTopic.periodTalk:
        return 'Period Talk';
      case CommunityTopic.pcosPcod:
        return 'PCOS/PCOD';
      case CommunityTopic.pregnancy:
        return 'Pregnancy';
      case CommunityTopic.wellness:
        return 'Wellness';
      case CommunityTopic.mentalHealth:
        return 'Mental Health';
      case CommunityTopic.relationships:
        return 'Relationships';
    }
  }

  String get icon {
    switch (this) {
      case CommunityTopic.general:
        return '💬';
      case CommunityTopic.periodTalk:
        return '🩸';
      case CommunityTopic.pcosPcod:
        return '🎗️';
      case CommunityTopic.pregnancy:
        return '🤰';
      case CommunityTopic.wellness:
        return '🌿';
      case CommunityTopic.mentalHealth:
        return '🧠';
      case CommunityTopic.relationships:
        return '💕';
    }
  }
}

/// Anonymous community post model
class CommunityPost {
  final String id;
  final String anonymousName; // e.g., "Anonymous Butterfly", "Kind Sunflower"
  final String content;
  final CommunityTopic topic;
  final DateTime createdAt;
  final int supportCount; // Like hearts/hugs
  final int replyCount;
  final List<CommunityReply> replies;
  final bool isFromCurrentUser;

  const CommunityPost({
    required this.id,
    required this.anonymousName,
    required this.content,
    required this.topic,
    required this.createdAt,
    this.supportCount = 0,
    this.replyCount = 0,
    this.replies = const [],
    this.isFromCurrentUser = false,
  });

  CommunityPost copyWith({
    String? id,
    String? anonymousName,
    String? content,
    CommunityTopic? topic,
    DateTime? createdAt,
    int? supportCount,
    int? replyCount,
    List<CommunityReply>? replies,
    bool? isFromCurrentUser,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      anonymousName: anonymousName ?? this.anonymousName,
      content: content ?? this.content,
      topic: topic ?? this.topic,
      createdAt: createdAt ?? this.createdAt,
      supportCount: supportCount ?? this.supportCount,
      replyCount: replyCount ?? this.replyCount,
      replies: replies ?? this.replies,
      isFromCurrentUser: isFromCurrentUser ?? this.isFromCurrentUser,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'anonymousName': anonymousName,
    'content': content,
    'topic': topic.index,
    'createdAt': createdAt.toIso8601String(),
    'supportCount': supportCount,
    'replyCount': replyCount,
    'replies': replies.map((r) => r.toJson()).toList(),
    'isFromCurrentUser': isFromCurrentUser,
  };

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      anonymousName: json['anonymousName'] as String,
      content: json['content'] as String,
      topic: CommunityTopic.values[json['topic'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      supportCount: json['supportCount'] as int? ?? 0,
      replyCount: json['replyCount'] as int? ?? 0,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((r) => CommunityReply.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
      isFromCurrentUser: json['isFromCurrentUser'] as bool? ?? false,
    );
  }
}

/// Reply to a community post
class CommunityReply {
  final String id;
  final String anonymousName;
  final String content;
  final DateTime createdAt;
  final int supportCount;
  final bool isFromCurrentUser;

  const CommunityReply({
    required this.id,
    required this.anonymousName,
    required this.content,
    required this.createdAt,
    this.supportCount = 0,
    this.isFromCurrentUser = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'anonymousName': anonymousName,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'supportCount': supportCount,
    'isFromCurrentUser': isFromCurrentUser,
  };

  factory CommunityReply.fromJson(Map<String, dynamic> json) {
    return CommunityReply(
      id: json['id'] as String,
      anonymousName: json['anonymousName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      supportCount: json['supportCount'] as int? ?? 0,
      isFromCurrentUser: json['isFromCurrentUser'] as bool? ?? false,
    );
  }
}

/// Helper to generate anonymous names
class AnonymousNameGenerator {
  static const _adjectives = [
    'Kind', 'Gentle', 'Brave', 'Warm', 'Bright', 'Sweet', 'Calm',
    'Strong', 'Wise', 'Happy', 'Peaceful', 'Caring', 'Loving',
  ];
  
  static const _nouns = [
    'Butterfly', 'Sunflower', 'Rainbow', 'Star', 'Moon', 'Flower',
    'Bird', 'Cloud', 'Wave', 'Leaf', 'Heart', 'Pearl', 'Rose',
  ];

  static String generate() {
    final adjective = _adjectives[DateTime.now().microsecond % _adjectives.length];
    final noun = _nouns[DateTime.now().millisecond % _nouns.length];
    return '$adjective $noun';
  }
}
