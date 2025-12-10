import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:symptomsphere/models/metrics_model.dart';
import 'package:symptomsphere/network/endpoints.dart';
import 'package:symptomsphere/utils/enum.dart';

Future<void> showMetricsPopup(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: _MetricsContent(),
      );
    },
  );
}

class _MetricsContent extends StatefulWidget {
  const _MetricsContent({super.key});

  @override
  State<_MetricsContent> createState() => _MetricsContentState();
}

class _MetricsContentState extends State<_MetricsContent> {
  double diagnosis = 0;
  double duration = 0;
  double friendliness = 0;
  double missed = 0;
  double words = 0;

  String error = "";

  Status loadingStatus = Status.loading;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) => _loadApi());
  }

  void _validate() {
    final sum = diagnosis + duration + friendliness + missed + words;
    if ((sum - 1.0).abs() > 0.001) {
      error = "Total must equal 1.0 (current: ${sum.toStringAsFixed(2)})";
    } else {
      error = "";
    }
    setState(() {});
  }

  double _normalize(double value) {
    // Ensure step 0.1 and limit 0–1
    return double.parse(
      value.clamp(0.0, 1.0).toStringAsFixed(1),
    );
  }

  Widget metricField(String label, double value, void Function(double) onChanged) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.brown),
                onPressed: () {
                  onChanged(_normalize(value - 0.1));
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: 6, left: 3),
                child: Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.brown),
                onPressed: () {
                  onChanged(_normalize(value + 0.1));
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Adjust Grading Metrics",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16),
          loadingStatus == Status.loading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                )
              : loadingStatus == Status.success
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        metricField("Diagnosis Accuracy", diagnosis, (v) {
                          diagnosis = v;
                          _validate();
                        }),
                        metricField("Consultation Duration", duration, (v) {
                          duration = v;
                          _validate();
                        }),
                        metricField("Conversation Friendliness", friendliness, (v) {
                          friendliness = v;
                          _validate();
                        }),
                        metricField("Missed Questions", missed, (v) {
                          missed = v;
                          _validate();
                        }),
                        metricField("Word Count Weight", words, (v) {
                          words = v;
                          _validate();
                        }),
                        if (error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              error,
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(error, style: TextStyle(fontSize: 18, color: Colors.red)),
                          IconButton(onPressed: _loadApi, icon: Icon(Icons.refresh, color: Colors.red)),
                        ],
                      ),
                    ),
          SizedBox(height: 12),
          Row(
            children: [
              /// Close Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),

              /// Save Button
              Expanded(
                child: loadingStatus == Status.success
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: error.isEmpty ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _onSaveTap,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : SizedBox(width: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;

  Future<void> _loadApi() async {
    loadingStatus = Status.loading;
    error = '';
    _refresh();

    try {
      await Future.delayed(Duration(seconds: 1));

      final response = await ApiHelper().get(Endpoints.getMetrics);
      print(response);
      final jsonResponse = jsonEncode(response);
      final decodedJson = jsonDecode(jsonResponse);

      MetricsModel model = MetricsModel.fromJson(decodedJson);
      diagnosis = model.diagnosis;
      duration = model.duration;
      friendliness = model.friendliness;
      missed = model.missed;
      words = model.words;

      loadingStatus = Status.success;
      _refresh();

      return;
    } catch (e) {
      debugPrint(e.toString());
      loadingStatus = Status.error;
      error = e.toString();
      _refresh();
      return;
    }
  }

  Future<void> _onSaveTap() async {
    _validate();
    _refresh();

    if (error.isNotEmpty) return;

    loadingStatus = Status.loading;
    error = '';
    _refresh();

    try {
      MetricsModel model = MetricsModel(
        diagnosis: diagnosis,
        duration: duration,
        friendliness: friendliness,
        missed: missed,
        words: words,
      );

      await Future.delayed(Duration(seconds: 1));
      await ApiHelper().post(Endpoints.saveMatrics, data: jsonEncode(model.toJson()));

      loadingStatus = Status.success;
      _refresh();

      if (mounted) Navigator.of(context).pop();
      return;
    } catch (e) {
      debugPrint(e.toString());
      loadingStatus = Status.error;
      error = e.toString();
      _refresh();
      return;
    }
  }
}
