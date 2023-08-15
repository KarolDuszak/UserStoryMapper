import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.prune() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordRegEx =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    return _passwordRegEx.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }
}
