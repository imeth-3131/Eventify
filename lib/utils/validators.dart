class Validators {
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, 'Email');
    if (requiredError != null) return requiredError;
    final email = value!.trim();
    final looksValid = email.contains('@') && email.contains('.') && !email.contains(' ');
    if (!looksValid) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, 'Password');
    if (requiredError != null) return requiredError;
    final password = value!.trim();
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
