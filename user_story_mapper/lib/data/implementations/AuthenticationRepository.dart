import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../cache.dart';

class AuthenticationRepository{
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
}

class LogOutFailure implements Exception{}

class LogInWithGoogleFailure implements Exception {
  const LogInWithGoogleFailure(
      [this.message = 'An unknow exception occurred.']);

  final String message;

  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
            'Account exists with different credentials');
      case 'invalid-credentail':
        return const LogInWithGoogleFailure(
            'The credentail recieved is malformed or has expired');
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure('The verification code is invalid');
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
            'The credential verification IF received is invalid');
      case 'wrong-password':
        return const LogInWithGoogleFailure('Wrong email or password');
      case 'user-disabled':
        return const LogInWithGoogleFailure('User disabled');
      case 'user-not-found':
        return const LogInWithGoogleFailure('Wrong email or password');
      default:
        return const LogInWithGoogleFailure();
    }
  }
}

class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure(
      [this.message = 'An unknown exception occurred']);

  final String message;

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
            'Wrong email or password');
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
            'Wrong email or password');
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure('User disabled');
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
            'Wrong email or password');
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }
}

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
