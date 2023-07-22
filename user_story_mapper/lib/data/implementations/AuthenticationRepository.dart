class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred',
  ]);

  final String message;

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'Can not create user with this name',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'Email already used',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure('Password too weak!');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
