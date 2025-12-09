import 'package:flutter/material.dart';
import 'package:symptomsphere/utils/color_utils.dart';
import 'package:symptomsphere/widgets/button/hover_gesture_detector.dart';

class SearchBarWidget extends StatelessWidget {
  final Function() onNewTap;
  final Function() onRefreshTap;

  const SearchBarWidget({super.key, required this.onNewTap, required this.onRefreshTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: SearchBar(
            constraints: BoxConstraints(minHeight: 46),
            hintText: 'Search Patients',
            hintStyle: WidgetStatePropertyAll(TextStyle(color: AppColors.offWhiteText)),
            elevation: WidgetStatePropertyAll(0),
            leading: Icon(Icons.search, color: AppColors.offWhiteText),
            backgroundColor: WidgetStatePropertyAll(AppColors.white),
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: AppColors.whiteStroke, width: 2),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        HoverGD(
          onTap: onNewTap,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Icon(Icons.add, color: AppColors.white),
          ),
        ),
        SizedBox(width: 20),
        HoverGD(
          onTap: onRefreshTap,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Icon(Icons.refresh, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
