import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/network/endpoints.dart';
import 'package:symptomsphere/ui/left_container/widgets/patient_list.dart';
import 'package:symptomsphere/ui/left_container/widgets/search_bar.dart';
import 'package:symptomsphere/utils/color_utils.dart';
import 'package:symptomsphere/utils/enum.dart';
import 'package:symptomsphere/widgets/logo_and_name.dart';

class LeftContainer extends StatefulWidget {
  final Function(ChatListModel?) onTap;

  const LeftContainer({super.key, required this.onTap});

  @override
  State<LeftContainer> createState() => _LeftContainerState();
}

class _LeftContainerState extends State<LeftContainer> {
  Status listLoadingStatus = Status.loading;
  String listError = "";
  List<ChatListModel> chats = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _loadMessages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: AppColors.whiteStroke))),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          LogoAndName(),
          SizedBox(height: 28),
          SearchBarWidget(onNewTap: _onNewTap, onRefreshTap: _loadMessages),
          SizedBox(height: 18),
          Expanded(
              child: PatientListView(onTap: widget.onTap, status: listLoadingStatus, error: listError, chats: chats)),
        ],
      ),
    );
  }

  Future<void> _onNewTap() async {
    listLoadingStatus = Status.loading;
    widget.onTap(null);
    _refresh();

    try {
      final response = await ApiHelper().get(Endpoints.newChat);
      print(response);
      final jsonResponse = jsonEncode(response);
      final decodedJson = jsonDecode(jsonResponse);
      final chatId = decodedJson['chat_id'] ?? '';

      if (chatId.isEmpty) {
        listError = 'Failed to get chat ID';
        listLoadingStatus = Status.error;
        _refresh();
        return;
      }

      final messagesResponse = await ApiHelper().get(Endpoints.getMessages(chatId));
      print(response);
      final messageJsonResponse = jsonEncode(messagesResponse);
      final messageDecodedJson = jsonDecode(messageJsonResponse);

      ChatListModel chatModel = ChatListModel(
          chatId: chatId,
          conversationCount: 0,
          userAge: messageDecodedJson['user_age'] ?? '',
          userGender: messageDecodedJson['user_gender'] ?? '',
          userName: messageDecodedJson['user_name'] ?? '');

      listLoadingStatus = Status.success;
      _refresh();

      widget.onTap(chatModel);

      _loadMessages();
      return;
    } catch (e) {
      debugPrint(e.toString());
      listLoadingStatus = Status.error;
      listError = e.toString();
      _refresh();
      return;
    }
  }

  void _refresh() => mounted ? setState(() {}) : null;

  Future<void> _loadMessages() async {
    listLoadingStatus = Status.loading;
    listError = "";
    chats = [];
    _refresh();

    try {
      final response = await ApiHelper().get(Endpoints.chats);
      final jsonResponse = jsonEncode(response);
      final decodedJson = jsonDecode(jsonResponse);
      for (final i in decodedJson) {
        final model = ChatListModel.fromJson(i);
        chats.add(model);
      }

      chats = chats.reversed.toList();

      if (chats.isEmpty) listError = 'No chats yet. Start a new chat';
      listLoadingStatus = Status.success;
      _refresh();
      return;
    } catch (e) {
      debugPrint(e.toString());
    }
    listError = 'Failed to load chats';
    listLoadingStatus = Status.error;
    _refresh();
  }
}
