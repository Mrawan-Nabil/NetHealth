class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String? type;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: json['type']?.toString(),
      isRead: json['is_read'] == true || json['is_read'] == 1 || json['is_read'] == '1',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
