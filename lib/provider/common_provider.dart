import 'package:flutter/foundation.dart';

class CommonProvider extends ChangeNotifier {
  bool voiceEnabled = false;

  void setEnableVoice(bool a) {
    voiceEnabled = a;
    notifyListeners();
  }
}
