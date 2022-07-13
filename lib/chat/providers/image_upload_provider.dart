import 'package:connect_chat/enum/view_state.dart';
import 'package:flutter/widgets.dart';

class ImageUploadProvider with ChangeNotifier {
  ViewState _viewState = ViewState.IDLE;
  ViewState get getViewState => _viewState;

  void startLoading() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void stopLoading() {
    _viewState = ViewState.IDLE;
    notifyListeners();
  }
}
