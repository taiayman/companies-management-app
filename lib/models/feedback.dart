class Feedback {
  final String id;
  final String projectId;
  final String bossId;
  final String content;
  final DateTime date;

  Feedback({
    required this.id,
    required this.projectId,
    required this.bossId,
    required this.content,
    required this.date,
  });

  factory Feedback.fromMap(Map<String, dynamic> data) {
    return Feedback(
      id: data['id'] ?? '',
      projectId: data['projectId'] ?? '',
      bossId: data['bossId'] ?? '',
      content: data['content'] ?? '',
      date: DateTime.parse(data['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'bossId': bossId,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
