class MessageModel {
  final String actualDisease;
  final String blob;
  final String chatId;
  final List<Conversation> conversations;
  final List<DdxList> ddxList;
  final Symptom initialSymptom;
  final List<Symptom> otherSymptom;
  final int rowIndex;
  final int userAge;
  final String userGender;
  final String userName;

  MessageModel({
    required this.actualDisease,
    required this.blob,
    required this.chatId,
    required this.conversations,
    required this.ddxList,
    required this.initialSymptom,
    required this.otherSymptom,
    required this.rowIndex,
    required this.userAge,
    required this.userGender,
    required this.userName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        actualDisease: json["actual_disease"] ?? "",
        blob: json["blob"] ?? "",
        chatId: json["chat_id"] ?? "",
        conversations: List<Conversation>.from((json["conversations"] ?? []).map((x) => Conversation.fromJson(x))),
        ddxList: List<DdxList>.from((json["ddx_list"] ?? []).map((x) => DdxList.fromJson(x))),
        initialSymptom: Symptom.fromJson(json["initial_symptom"]),
        otherSymptom: List<Symptom>.from((json["other_symptom"] ?? []).map((x) => Symptom.fromJson(x))),
        rowIndex: json["row_index"] ?? 0,
        userAge: json["user_age"] ?? 35,
        userGender: json["user_gender"] ?? 'M',
        userName: json["user_name"] ?? "Tom Chris",
      );
}

class Conversation {
  final String message;
  final String role;
  final DateTime timestamp;

  Conversation({
    required this.message,
    required this.role,
    required this.timestamp,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        message: json["message"] ?? '',
        role: json["role"] ?? "doctor",
        timestamp: json["timestamp"] == null ? DateTime.now() : DateTime.parse(json["timestamp"]),
      );
}

class DdxList {
  final int probability;
  final String symptom;

  DdxList({required this.probability, required this.symptom});

  factory DdxList.fromJson(Map<String, dynamic> json) => DdxList(
        probability: json["probability"] ?? 0.5,
        symptom: json["symptom"] ?? '',
      );
}

class Symptom {
  final String answer;
  final String question;

  Symptom({
    required this.answer,
    required this.question,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) => Symptom(
        answer: json["answer"] ?? "",
        question: json["question"] ?? "",
      );
}
