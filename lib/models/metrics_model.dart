class MetricsModel {
  final double diagnosis;
  final double duration;
  final double friendliness;
  final double missed;
  final double words;

  MetricsModel({
    required this.diagnosis,
    required this.duration,
    required this.friendliness,
    required this.missed,
    required this.words,
  });

  factory MetricsModel.fromJson(Map<String, dynamic> json) => MetricsModel(
        diagnosis: (json["diagnosis"] ?? 0).toDouble(),
        duration: (json["duration"] ?? 0).toDouble(),
        friendliness: (json["friendliness"] ?? 0).toDouble(),
        missed: (json["missed"] ?? 0).toDouble(),
        words: (json["words"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "diagnosis": diagnosis,
        "duration": duration,
        "friendliness": friendliness,
        "missed": missed,
        "words": words,
      };
}
