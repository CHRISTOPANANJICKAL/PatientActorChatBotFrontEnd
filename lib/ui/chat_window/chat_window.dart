import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:symptomsphere/models/chat_list_model.dart';
import 'package:symptomsphere/models/message_model.dart';
import 'package:symptomsphere/network/endpoints.dart';
import 'package:symptomsphere/provider/common_provider.dart';
import 'package:symptomsphere/ui/chat_window/widgets/message_bubble.dart';
import 'package:symptomsphere/ui/chat_window/widgets/message_text_field.dart';
import 'package:symptomsphere/utils/color_utils.dart';
import 'package:symptomsphere/utils/enum.dart';
import 'package:symptomsphere/widgets/title_bar.dart';

class ChatWindow extends StatefulWidget {
  final ChatListModel model;
  final Function(ChatListModel?) onClose;
  final Function() onRefresh;

  const ChatWindow({super.key, required this.model, required this.onClose, required this.onRefresh});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  late TextEditingController controller;
  late ScrollController scrollController;
  MessageModel? message;

  String error = '';
  Status staus = Status.loading;
  Status messageSending = Status.success;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s) => _loadMessages());

    controller = TextEditingController();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.offWhite,
      alignment: Alignment.center,
      child: staus == Status.loading
          ? SizedBox(width: 50, height: 50, child: CircularProgressIndicator())
          : (staus == Status.success && message != null)
              ? Column(
                  children: [
                    TitleBar(
                        model: widget.model,
                        onClose: () {
                          widget.onClose(null);
                          message = null;
                          staus = Status.loading;
                          controller.clear();
                          error = '';
                          _refresh();
                        }),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Column(
                          children: [
                            Expanded(
                                child: message!.conversations.isEmpty
                                    ? Center(
                                        child: Text(
                                        'Say Hi to your patient, ${message!.userName}',
                                        style: TextStyle(fontSize: 19),
                                      ))
                                    : ListView.builder(
                                        itemCount: message!.conversations.length,
                                        controller: scrollController,
                                        itemBuilder: (context, index) {
                                          return MessageBubble(
                                              model: message!.conversations[index], patient: widget.model);
                                        })),
                            ChatInputField(
                              controller: controller,
                              onSend: _onMessageSend,
                              status: messageSending,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error, style: TextStyle(fontSize: 18, color: Colors.red)),
                    IconButton(onPressed: _loadMessages, icon: Icon(Icons.refresh, color: Colors.red)),
                  ],
                ),
    );
  }

  Future<void> _onMessageSend() async {
    if (messageSending == Status.loading) return;
    final String text = controller.text.trim();
    messageSending = Status.loading;
    _refresh();

    try {
      final response = await ApiHelper()
          .post(Endpoints.sendMessage, data: jsonEncode({"chat_id": widget.model.chatId, "message": text}));

      print(response);
      final jsonResponse = jsonEncode(response);
      final decodedJson = jsonDecode(jsonResponse);
      final responseMessage = (decodedJson['response'] ?? '').toString().trim();

      if (responseMessage.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            'Failed to send message',
            style: TextStyle(color: Colors.red),
          )));
        }
        messageSending = Status.error;
        _refresh();
        return;
      }

      final messageListResponse = await ApiHelper().get(Endpoints.getMessages(widget.model.chatId));
      final jsonMessageResponse = jsonEncode(messageListResponse);
      final decodedMessageJson = jsonDecode(jsonMessageResponse);
      message = MessageModel.fromJson(decodedMessageJson);

      _speakTheLatestMessage();

      widget.model.conversationCount += 2;
      messageSending = Status.success;
      controller.clear();
      _scroll();
      _refresh();
      widget.onRefresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Failed to send message',
          style: TextStyle(color: Colors.red),
        )));
      }
      messageSending = Status.error;
      _refresh();
      return;
    }
  }

  _refresh() => mounted ? setState(() {}) : null;

  Future<void> _loadMessages() async {
    error = '';
    staus = Status.loading;
    messageSending = Status.success;
    _refresh();

    try {
      final response = await ApiHelper().get(Endpoints.getMessages(widget.model.chatId));
      final jsonResponse = jsonEncode(response);
      final decodedJson = jsonDecode(jsonResponse);
      message = MessageModel.fromJson(decodedJson);
      staus = Status.success;
      _refresh();
      _scroll();
      return;
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
      staus = Status.error;
      _refresh();
    }
  }

  void _scroll() {
    try {
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 250), curve: Curves.easeIn);
      });
    } catch (_) {}
  }

  void _speakTheLatestMessage() {
    if (message == null || message!.conversations.isEmpty || !context.read<CommonProvider>().voiceEnabled) return;

    final lastMessage = message!.conversations.last;
    FlutterTts tts = FlutterTts();
    tts.speak(lastMessage.message);
  }
}
