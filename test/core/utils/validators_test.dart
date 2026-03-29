import 'package:backbonz/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty values', () {
      expect(Validators.email(''), 'Email is required.');
    });

    test('rejects malformed email', () {
      expect(
        Validators.email('invalid-email'),
        'Please enter a valid email address.',
      );
    });

    test('accepts valid email', () {
      expect(Validators.email('teen@example.com'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('rejects mismatch', () {
      expect(
        Validators.confirmPassword('secret123', 'secret321'),
        'Passwords do not match.',
      );
    });

    test('accepts matching value', () {
      expect(Validators.confirmPassword('secret123', 'secret123'), isNull);
    });
  });
}
