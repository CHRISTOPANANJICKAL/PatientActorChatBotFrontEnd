import 'package:flutter/material.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/ui/left_container/widgets/patient_tile_widget.dart';
import 'package:symptomsphere/utils/enum.dart';

class PatientListView extends StatefulWidget {
  final Function(ChatListModel) onTap;
  final Status status;
  final String error;
  final List<ChatListModel> chats;
  final TextEditingController controller;

  const PatientListView(
      {super.key,
      required this.onTap,
      required this.status,
      required this.error,
      required this.chats,
      required this.controller});

  @override
  State<PatientListView> createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.status == Status.loading) {
      return Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
    }

    if (widget.status == Status.success && widget.chats.isEmpty) {
      return Center(
          child: Text(
        widget.error.trim().isEmpty ? 'Something went wrong' : widget.error.trim(),
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ));
    }

    if (widget.status == Status.error) {
      return Center(
          child: Text(
        widget.error.trim().isEmpty ? 'Something went wrong' : widget.error.trim(),
        style: TextStyle(fontSize: 12, color: Colors.red),
      ));
    }

    return ListView.builder(
      key: Key(widget.controller.text),
      itemCount: getChants().length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: PatientTileWidget(model: getChants()[i], onTap: widget.onTap),
        );
      },
    );
  }

  List<ChatListModel> getChants() {
    List<ChatListModel> allChats = widget.chats;
    String text = widget.controller.text.trim().toLowerCase();
    if (text.isEmpty) return allChats;

    List<ChatListModel> filtered = [];

    for (final i in widget.chats) {
      if (i.userName.toLowerCase().contains(text.toLowerCase())) filtered.add(i);
    }

    if (filtered.isNotEmpty) return filtered;
    return allChats;
  }
}
