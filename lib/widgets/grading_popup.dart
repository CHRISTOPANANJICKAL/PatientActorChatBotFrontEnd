import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:symptomsphere/models/evaluation_model.dart';
import 'package:symptomsphere/network/endpoints.dart';
import 'package:symptomsphere/utils/enum.dart';

Future<void> showGradingPopup(
  BuildContext context, {
  required String chatId,
}) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: _DialogContent(chatId: chatId),
      );
    },
  );
}

class _DialogContent extends StatefulWidget {
  final String chatId;

  const _DialogContent({super.key, required this.chatId});

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  Status status = Status.loading;
  String error = '';

  EvaluationModel? model;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _loadApi());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// --- Title ---
            Text(
              "Grading Summary",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 18),

            if (status == Status.success && model != null)
              Column(
                children: [
                  /// Patient details card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailRow("Patient Name", model!.patientName),
                        detailRow("Consultation Time", "${(model!.totalTime / 60).toStringAsFixed(2)} Min"),
                        detailRow("Actual Disease", model!.actualDisease),
                        detailRow("Total Word Count", model!.words.toString()),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  /// Metrics section
                  metricTile(
                    "Conversation Friendliness",
                    model!.conversationFriendly.toString(),
                    Icons.chat_bubble_outline,
                    Colors.blue,
                  ),
                  metricTile(
                    "Diagnosis Accuracy",
                    model!.diagnosisAccuracy.toString(),
                    Icons.health_and_safety_outlined,
                    Colors.green,
                  ),

                  SizedBox(height: 20),

                  /// Final Score Highlight
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.blue.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.25),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "FINAL SCORE",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          model!.finalScore.toString(),
                          style: TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  /// Missed questions title
                  ///
                  if (model!.missedQuestions.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Missed Questions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  SizedBox(height: 10),

                  if (model!.missedQuestions.isNotEmpty)

                    /// Missed questions list
                    ...List.generate(
                      model!.missedQuestions.length,
                      (i) => missedTile(model!.missedQuestions[i]),
                    ),

                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Differential Diagnosis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// Differential list
                  ...List.generate(
                    model!.ddx.length,
                    (i) => ddxTile(model!.ddx[i].symptom, model!.ddx[i].probability),
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (status == Status.loading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(width: 35, height: 35, child: CircularProgressIndicator()),
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error.isEmpty ? 'Failed to grade' : error,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      IconButton(onPressed: _loadApi, icon: Icon(Icons.refresh, color: Colors.red)),
                    ],
                  ),
                ),
              ),

            /// Close button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Close",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;

  Future<void> _loadApi() async {
    status = Status.loading;
    error = '';
    model = null;
    _refresh();

    try {
      final response = await ApiHelper().get(Endpoints.evaluate(widget.chatId));
      final jsonResponse = jsonEncode(response);
      final decodedJson = jsonDecode(jsonResponse);
      print(decodedJson);
      model = EvaluationModel.fromJson(decodedJson);
      status = Status.success;
      _refresh();
      return;
    } catch (e) {
      debugPrint(e.toString());
    }
    error = 'Failed to evaluate your case';
    status = Status.error;
    _refresh();
  }
}

/// --- Helper Widgets ---

Widget detailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            title,
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
          ),
        ),
        Text(': ', style: TextStyle(color: Colors.black54)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Widget metricTile(String title, String value, IconData icon, Color iconColor) {
  return Container(
    padding: EdgeInsets.all(14),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor, size: 30),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    ),
  );
}

Widget missedTile(String question) {
  return Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.close, color: Colors.redAccent, size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            question,
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}

Widget ddxTile(String symptom, int probability) {
  return Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.close, color: Colors.redAccent, size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            symptom,
            style: TextStyle(color: Colors.black87),
          ),
        ),
        SizedBox(width: 10),
        Text(
          probability.toString(),
          style: TextStyle(color: Colors.green),
        )
      ],
    ),
  );
}
