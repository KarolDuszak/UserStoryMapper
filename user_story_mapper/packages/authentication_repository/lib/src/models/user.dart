import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, this.email, this.name});

  //Informations
  final String id;
  final String? email;
  final String? name;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', email: '', name: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, email, name];
}
