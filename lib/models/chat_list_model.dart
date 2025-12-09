import 'dart:convert';

class ChatListModel {
  final String chatId;
  int conversationCount;
  final int userAge;
  final String userGender;
  final String userName;

  ChatListModel({
    required this.chatId,
    required this.conversationCount,
    required this.userAge,
    required this.userGender,
    required this.userName,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        chatId: json["chat_id"] ?? '',
        conversationCount: json["conversation_count"] ?? 0,
        userAge: json["user_age"] ?? 34,
        userGender: json["user_gender"] ?? 'M',
        userName: json["user_name"] ?? 'Bob Samuel',
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "conversation_count": conversationCount,
        "user_age": userAge,
        "user_gender": userGender,
        "user_name": userName,
      };
}
