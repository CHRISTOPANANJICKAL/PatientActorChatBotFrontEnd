import 'package:flutter/material.dart';
import 'package:symptomsphere/utils/color_utils.dart';
import 'package:symptomsphere/utils/enum.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final Status status;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.whiteStroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: AppColors.offWhiteText),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 4),
          status == Status.loading
              ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: AppColors.blue))
              : status == Status.success
                  ? IconButton(icon: Icon(Icons.send_rounded), color: AppColors.blue, onPressed: onSend)
                  : IconButton(icon: Icon(Icons.refresh), color: Colors.red, onPressed: onSend),
        ],
      ),
    );
  }
}
