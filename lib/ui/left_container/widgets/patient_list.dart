import 'package:flutter/material.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/ui/left_container/widgets/patient_tile_widget.dart';
import 'package:symptomsphere/utils/enum.dart';

class PatientListView extends StatefulWidget {
  final Function(ChatListModel) onTap;
  final Status status;
  final String error;
  final List<ChatListModel> chats;

  const PatientListView(
      {super.key, required this.onTap, required this.status, required this.error, required this.chats});

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
      itemCount: widget.chats.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: PatientTileWidget(model: widget.chats[i], onTap: widget.onTap),
        );
      },
    );
  }
}
