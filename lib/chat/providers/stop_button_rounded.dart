import 'package:brekete_connect/chat/Widgets/rounded_loading_button.dart';
import 'package:flutter/cupertino.dart';

class StopAndStartButtonRounded with ChangeNotifier {
  late final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  get btnController => _btnController;

  void roundedButtonStop() {
    _btnController.stop();
    notifyListeners();
  }

  void roundedButtonStart() {
    _btnController.start();
    notifyListeners();
  }
}
