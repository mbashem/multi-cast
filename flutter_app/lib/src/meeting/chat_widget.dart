import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/models/chat_message.dart';
import 'package:intl/intl.dart';

class ChatWidget extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(String) sendMessage;
  const ChatWidget(
      {super.key, required this.messages, required this.sendMessage});
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  TextEditingController messageController = TextEditingController();

  void _sendMessage() {
    if (messageController.text.isNotEmpty) {
      widget.sendMessage(messageController.text);
      setState(() {
        messageController.text = '';
      });
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final timeFormat = DateFormat.jm(); // You can customize the time format
    return timeFormat.format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[index];
              return ListTile(
                title: Text(
                  '${message.senderName} • ${_formatTimestamp(message.time)}\n${message.msg}',
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
