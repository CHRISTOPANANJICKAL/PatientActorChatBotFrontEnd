import 'package:flutter/material.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/utils/color_utils.dart';
import 'package:symptomsphere/utils/name_utils.dart';
import 'package:symptomsphere/widgets/button/hover_gesture_detector.dart';

class PatientTileWidget extends StatelessWidget {
  final ChatListModel model;
  final Function(ChatListModel) onTap;

  const PatientTileWidget({super.key, required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: () => onTap(model),
      child: Container(
        height: 72,
        decoration:
            BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.offWhiteText))),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.offWhite),
              child: Text(getInitials(model.userName), style: TextStyle(color: AppColors.offWhiteText, fontSize: 18)),
            ),
            SizedBox(width: 12),
            Expanded(child: Text(model.userName, style: TextStyle(color: AppColors.text, fontSize: 16))),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Text(model.conversationCount.toString(), style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
