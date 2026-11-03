class DiscussionMessage {
  final String id;
  final String senderName;
  final String senderRole;
  final String text;
  final DateTime timestamp;
  final bool isFromEngineer;

  const DiscussionMessage({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.text,
    required this.timestamp,
    required this.isFromEngineer,
  });
}

