import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    await [Permission.microphone, Permission.camera].request();
    if (defaultTargetPlatform == TargetPlatform.android) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> microphonePermissionsGranted() async {
    await [Permission.microphone].request();
    if (defaultTargetPlatform == TargetPlatform.android) {
      return true;
    } else {
      return false;
    }
  }
}
