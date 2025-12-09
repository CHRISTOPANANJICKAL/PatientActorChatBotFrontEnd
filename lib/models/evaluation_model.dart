class EvaluationModel {
  final String actualDisease;
  final int conversationFriendly;
  final int diagnosisAccuracy;
  final double finalScore;
  final List<String> missedQuestions;
  final List<DDX> ddx;
  final String patientName;
  final double totalTime;
  final int words;

  EvaluationModel({
    required this.actualDisease,
    required this.conversationFriendly,
    required this.diagnosisAccuracy,
    required this.finalScore,
    required this.missedQuestions,
    required this.ddx,
    required this.patientName,
    required this.totalTime,
    required this.words,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) => EvaluationModel(
        actualDisease: json["actual_disease"] ?? 'Unknown',
        conversationFriendly: json["conversation_friendlines"] ?? 0,
        diagnosisAccuracy: json["diagnosis_accuracy"] ?? 0,
        finalScore: (json["final_score"] ?? 0).toDouble(),
        missedQuestions: List<String>.from((json["missed_questions"] ?? []).map((x) => x)),
        ddx: List<DDX>.from((json["ddx"] ?? []).map((x) => DDX.fromJson(x))),
        patientName: json["patient_name"] ?? 'Bob',
        totalTime: (json["total_time"] ?? 150).toDouble(),
        words: json["words"] ?? 50,
      );
}

class DDX {
  final String symptom;
  final int probability;
  const DDX({required this.symptom, required this.probability});

  factory DDX.fromJson(Map<String, dynamic> json) => DDX(
        symptom: json["symptom"] ?? 'Unknown',
        probability: json["probability"] ?? 0,
      );
}
