class FieldValidator {

// static String? p(String password ){
//   RegExp passwordRegex = new RegExp(r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\$%^&*]).{8,}$');
//   if (passwordRegex.hasMatch(password)) {
//     // Password is valid
//   } else {
//     return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one numeric digit.';
//   }
//
// }
  static String? validateEmail(String value) {

    if (value.isEmpty) {
      return 'Email is Required';
    }
    if (!RegExp(
        r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
        .hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }
  static String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password is too short";
    return null;
  }
  // static String? validatePassword(String value) {
  //   if (value.isEmpty) return 'Please enter password';
  //   if (value.length < 6) {
  //     return "Enter a combination of at least 6 numbers, \nalphabets & special characters";
  //   }
  //   if (!RegExp(r"^(?=.*?[0-9])").hasMatch(value)) {
  //     return 'Enter a combination of at least 6 numbers, \nalphabets & special characters';
  //   }
  //   if (!RegExp(r'^(?=.?[!@#\$&~])').hasMatch(value.trim())) {
  //     return 'Enter a combination of at least 6 numbers, \nalphabets & special characters';
  //   }
  //   return null;
  // }
  static String? validatePasswordMatch(String value, String pass2) {
    if (value.isEmpty) return "Confirm password is required";
    if (value != pass2) {
      return "Password doesn't match";
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.isEmpty) return "Name is required";
    if (value.length <= 2) {
      return "First name is too short";
    }

    return null;
  }
  static String? validateHostelName(String value) {
    if (value.isEmpty) return "HostelName is required";
    if (value.length <= 2) {
      return "HostelName is too short";
    }

    return null;
  }
  static String? validateHostelCity(String value) {
    if (value.isEmpty) return "CityName is required";
    if (value.length <= 2) {
      return "City name is too short";
    }

    return null;
  }
  static String? validateUserName(String value) {
    if (value.isEmpty) return "User name is required";
    if (value.length <= 1) {
      return "User name is too short";
    }

    return null;
  }
  static String? validatePinCode(String? value) {
    if (value!.isEmpty) {
      return "Incorrect PINCODE";
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) return "Phone number is required";
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{9,20}$)';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value.trim())) {
      return "Please enter a valid phone number";
    }
    return null;
  }
}