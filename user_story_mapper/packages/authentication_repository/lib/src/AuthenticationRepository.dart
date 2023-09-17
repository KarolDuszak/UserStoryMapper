import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cache/cache.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  static const userCacheKey = '__user_cache_key__';

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  Future<User> signUp({required String email, required String password}) async {
    try {
      var authData = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return User(id: authData.user!.uid, email: authData.user?.email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  Future deleteAccount(String email, String password) async {
    try {
      _firebaseAuth.currentUser!.delete();
    } catch (e) {
      print(e);
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}

class LogOutFailure implements Exception {}

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
