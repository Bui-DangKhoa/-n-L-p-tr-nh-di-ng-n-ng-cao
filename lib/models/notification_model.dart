class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type; // 'order', 'promotion', 'system', 'product'
  final String? imageUrl;
  final String? actionId; // Order ID, Product ID, etc.
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.imageUrl,
    this.actionId,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'imageUrl': imageUrl,
      'actionId': actionId,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? 'system',
      imageUrl: map['imageUrl'],
      actionId: map['actionId'],
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      imageUrl: imageUrl,
      actionId: actionId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
