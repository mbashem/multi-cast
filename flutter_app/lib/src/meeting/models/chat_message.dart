class ChatMessage {
  final String msg;
  final String senderName;
  final DateTime time = DateTime.now();
  ChatMessage({required this.msg, required this.senderName});
}
