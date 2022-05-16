import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brekete_connect/shop/constants/app_color.dart';

Widget myTextField(
    {String label,
    @required controller,
    bool obscureText,
    Color borderColor,
    IconData prefixicon,
    IconButton suffixiconbutton,
    onChanged,
    onSubmit,
    submitIcon,
    bool filled,
    Color filledColor,
    TextCapitalization textCapitalization,
    bool autofocus,
    bool readOnly,
    onTap,
    int maxLines,
    double width,
    keyboardType,
    String prefixText,
    int maxLength,
    List<TextInputFormatter> formatter,
    String Function(String) validator}) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    // height: height ?? 40,
    width: width,
    child: TextFormField(
      validator: validator,
      inputFormatters: formatter,
      readOnly: readOnly ?? false,
      obscureText: obscureText ?? false,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      onTap: onTap ?? () {},
      maxLines: maxLines ?? 1,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      autofocus: autofocus ?? false,
      maxLength: maxLength ?? null,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        // prefixText: prefixText ?? null,
        // counterText: '',
        suffixIcon: suffixiconbutton == null ? null : suffixiconbutton,
        prefixIcon: prefixicon == null
            ? null
            : Icon(
                prefixicon,
                color: AppColor.fadeColor,
              ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        border: InputBorder.none,
        hintText: label,
        errorText: null,
        errorStyle: TextStyle(height: 0, fontSize: 0),
        hintStyle: TextStyle(
          color: AppColor.fadeColor,
        ),
        fillColor: filledColor ?? Colors.transparent,
        filled: filled ?? false,
        disabledBorder: OutlineInputBorder(
          // borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColor.fadeColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
              // color: borderColor ?? AppColor.borderColor,
              ),
        ),
        focusedBorder: OutlineInputBorder(
          // borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColor.primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          // borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          // borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColor.fadeColor,
            width: 1.0,
          ),
        ),
      ),
    ),
  );
}

class CustomTextField {
  static Widget myTextField(
      {String label,
      @required controller,
      bool obscureText,
      Color borderColor,
      IconData prefixicon,
      IconButton suffixiconbutton,
      onChanged,
      onSubmit,
      submitIcon,
      bool filled,
      Color filledColor,
      TextCapitalization textCapitalization,
      bool autofocus,
      bool readOnly,
      onTap,
      int maxLines,
      double width,
      keyboardType,
      String prefixText,
      int maxLength,
      List<TextInputFormatter> formatter,
      String Function(String) validator}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: width,
      child: TextFormField(
        validator: validator,
        inputFormatters: formatter,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType ?? TextInputType.text,
        onTap: onTap ?? () {},
        maxLines: maxLines ?? 1,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        autofocus: autofocus ?? false,
        maxLength: maxLength ?? null,
        onFieldSubmitted: onSubmit,
        decoration: InputDecoration(
          // prefixText: prefixText ?? null,
          // counterText: '',
          suffixIcon: suffixiconbutton == null ? null : suffixiconbutton,
          prefixIcon: prefixicon == null
              ? null
              : Icon(
                  prefixicon,
                  color: AppColor.fadeColor,
                ),
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          border: InputBorder.none,
          hintText: label,
          errorText: null,
          errorStyle: TextStyle(height: 0, fontSize: 0),
          hintStyle: TextStyle(
            color: AppColor.fadeColor,
          ),
          fillColor: filledColor ?? Colors.transparent,
          filled: filled ?? false,
          disabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: borderColor ?? AppColor.fadeColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                // color: borderColor ?? AppColor.borderColor,
                ),
          ),
          focusedBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                // color: borderColor ?? AppColor.primaryColor,
                ),
          ),
          errorBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: borderColor ?? AppColor.fadeColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
