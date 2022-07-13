import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  //   static Future<bool> showPickerDialog(BuildContext context) async {
  //   final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  //   final res = isIOS ? await showImageSourceIOS(context) : await showImageSourceAndroid(context);
  //   return res;
  // }
  static Future<PickedFile?> pickedImage(
      BuildContext context, ImageSource? src) async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.getImage(
      source: src!,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 85,
    );
  }

  static Future<PickedFile?> pickedVideo(
      BuildContext context, ImageSource? src) async {
    ImagePicker videoPicker = ImagePicker();
    return await videoPicker.getVideo(source: src!);
  }
}
