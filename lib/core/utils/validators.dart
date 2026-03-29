class Validators {
  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? required(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredMessage = required(value, label: 'Email');
    if (requiredMessage != null) {
      return requiredMessage;
    }
    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredMessage = required(value, label: 'Password');
    if (requiredMessage != null) {
      return requiredMessage;
    }
    if (value!.trim().length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    final requiredMessage = required(
      confirmPassword,
      label: 'Confirm password',
    );
    if (requiredMessage != null) {
      return requiredMessage;
    }
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }
}
