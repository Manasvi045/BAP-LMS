// lib/models/chat.dart — UI-level chat shape. Wire-level ChatMessage is in services/assistant/api.dart.

import 'package:flutter/foundation.dart';

enum ChatRole { user, bot }

@immutable
class ChatMessage {
  final ChatRole role;
  final String text;
  final int? ts;
  const ChatMessage({required this.role, required this.text, this.ts});
}