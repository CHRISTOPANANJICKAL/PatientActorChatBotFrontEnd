import 'package:flutter/material.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/models/message_model.dart';
import 'package:symptomsphere/utils/color_utils.dart';
import 'package:symptomsphere/utils/name_utils.dart';

class MessageBubble extends StatelessWidget {
  final Conversation model;
  final ChatListModel patient;

  const MessageBubble({super.key, required this.model, required this.patient});

  @override
  Widget build(BuildContext context) {
    final bool isBot = model.role == 'bot';

    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot)
            Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
              child: Text(getInitials(patient.userName), style: TextStyle(color: AppColors.offWhiteText, fontSize: 18)),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: isBot ? AppColors.white : AppColors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isBot ? 0 : 12),
                  topRight: Radius.circular(isBot ? 12 : 0),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                model.message.trim(),
                style: TextStyle(fontSize: 16, color: isBot ? AppColors.text : AppColors.white),
              ),
            ),
          ),
          if (!isBot)
            Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
              child: Text('You', style: TextStyle(color: AppColors.offWhiteText, fontSize: 18)),
            ),
        ],
      ),
    );
  }
}
