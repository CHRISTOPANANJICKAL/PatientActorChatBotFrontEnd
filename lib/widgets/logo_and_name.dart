import 'package:flutter/material.dart';
import 'package:symptomsphere/utils/color_utils.dart';

class LogoAndName extends StatelessWidget {
  const LogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.chat_bubble_outline, color: AppColors.blue),
        SizedBox(width: 12),
        Text('SymptomSphere', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w800, fontSize: 24))
      ],
    );
  }
}
