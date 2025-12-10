import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/provider/common_provider.dart';
import 'package:symptomsphere/utils/color_utils.dart';
import 'package:symptomsphere/utils/name_utils.dart';
import 'package:symptomsphere/widgets/button/hover_gesture_detector.dart';
import 'package:symptomsphere/widgets/grading_popup.dart';

class TitleBar extends StatefulWidget {
  final ChatListModel model;
  final Function() onClose;

  const TitleBar({super.key, required this.model, required this.onClose});

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.offWhite))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.offWhite),
              child: Text(getInitials(widget.model.userName),
                  style: TextStyle(color: AppColors.offWhiteText, fontSize: 18)),
            ),
            SizedBox(width: 12),
            Text(widget.model.userName, style: TextStyle(color: AppColors.text, fontSize: 16)),
            Spacer(),
            Consumer<CommonProvider>(builder: (context, p, w) {
              return Checkbox(
                value: p.voiceEnabled,
                onChanged: (a) => p.setEnableVoice(a ?? false),
                activeColor: Colors.blue,
                fillColor: WidgetStatePropertyAll(p.voiceEnabled ? Colors.green : Colors.white),
                checkColor: Colors.white,
                side: BorderSide(color: Colors.green, width: 2),
              );
            }),
            Text('Enable Voice', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(width: 24),
            if (widget.model.conversationCount > 4)
              HoverGD(
                onTap: _onGradeTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Colors.amber),
                  child: Text('Grade Me',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            SizedBox(width: 40),
            TextSp(text1: 'Gender', text2: widget.model.userGender == 'f' ? 'Female' : 'Male'),
            SizedBox(width: 12),
            TextSp(text1: 'Age', text2: widget.model.userAge.toString()),
            SizedBox(width: 40),
            HoverGD(onTap: widget.onClose, child: Icon(Icons.close)),
          ],
        ),
      ),
    );
  }

  void _onGradeTap() {
    showGradingPopup(context, chatId: widget.model.chatId);
  }
}

class TextSp extends StatelessWidget {
  final String text1;
  final String text2;

  const TextSp({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$text1: ', style: TextStyle(color: AppColors.blue, fontSize: 16)),
        Text(text2, style: TextStyle(color: Colors.red, fontSize: 16)),
      ],
    );
  }
}
