class FieldValidator {
  static String validateEmail(String value) {
    // print("validateEmail : $value ");

    if (value.isEmpty) {
      return 'Please Enter a valid E-mail';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = RegExp(pattern.toString());

    if (!regex.hasMatch(value.trim())) {
      return "Please Enter a valid E-mail";
    }

    return null;
  }

  /// Password matching expression. Password must be at least 4 characters,
  /// no more than 8 characters, and must include at least one upper case letter,
  /// one lower case letter, and one numeric digit.
  static String validateField(
    String value,
  ) {
    if (value.isEmpty) {
      // Apputils.showToast('Field Required*');

      return 'Field Required*';
    }

    return null;
  }

  static String fNameField(
    String value,
  ) {
    if (value.isEmpty) {
      return 'Field Required*';
    }

    return null;
  }

  static String lNameField(
    String value,
  ) {
    if (value.isEmpty) {
      return 'Field Required*';
    }

    return null;
  }

  static String validateDropDown(
    String value,
  ) {
    if (value == null) {
      // Apputils.showToast('Field Required*');

      return 'Field Required*';
    }

    return null;
  }

  static String TeamField(
    String value,
  ) {
    if (value.isEmpty) {
      return 'Field Required*';
    }

    return null;
  }

  static String validatePassword(String value) {
    // print("validatepassword : $value ");

    if (value.isEmpty) {
      return 'Please Enter a valid Password';
    }
    if (value.length <= 6) {
      return 'Password must be more than 6 characters!';
    }
    return null;
  }

  static String validateConfirmPassword(String value, String password) {
    // print("validatepassword : $value ");

    if (value != password) {
      return 'Confirm Password must be same as password!';
    }
    return null;
  }

  static String validateFieldPhone(String value) {
    // print("validatepassword : $value ");

    if (value.isEmpty) return "Field Required*";
    if (value.length < 5) {
      return "Field must have more than 4 characters!";
    }
    return null;
  }

  static String validateFieldLenTwo(String value) {
    // print("validatepassword : $value ");

    if (value.isEmpty) return "Field Required*";
    if (value.length < 2) {
      return "Field must have more than 2 characters!";
    }
    return null;
  }
}
