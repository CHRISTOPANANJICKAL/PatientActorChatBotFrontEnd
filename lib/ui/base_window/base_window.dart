import 'package:flutter/material.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/ui/chat_window/chat_window.dart';
import 'package:symptomsphere/ui/left_container/left_container.dart';
import 'package:symptomsphere/utils/color_utils.dart';

class BaseWindow extends StatelessWidget {
  const BaseWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: MainBody()),
        ],
      ),
    );
  }
}

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  ChatListModel? patient;

  void _refresh() => mounted ? setState(() {}) : null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(flex: 1, child: LeftContainer(onTap: _onPatientTap)),
          if (patient == null)
            Expanded(
                flex: 3,
                child: Center(
                  child: Text('Select or Create a New Patient',
                      style: TextStyle(fontSize: 18, color: AppColors.offWhiteText)),
                ))
          else
            Expanded(
                flex: 3,
                child: ChatWindow(
                  model: patient!,
                  onClose: _onPatientTap,
                  onRefresh: _refresh,
                  key: Key(patient!.chatId),
                ))
        ],
      ),
    );
  }

  void _onPatientTap(ChatListModel? p) {
    if (p == patient) p = null;
    patient = p;
    if (mounted) setState(() {});
  }
}
