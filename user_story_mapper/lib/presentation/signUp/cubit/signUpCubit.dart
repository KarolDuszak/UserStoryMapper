import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:user_story_mapper/data/implementations/FirebaseUserApi.dart';
import 'package:user_story_mapper/models/authModels/email.dart';
import 'package:user_story_mapper/models/authModels/password.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:user_story_mapper/models/userModels/user.dart' as FSUser;
import 'package:user_story_mapper/presentation/signUp/confirmPassword.dart';

part 'signUpState.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid:
            Formz.validate([email, state.password, state.confirmedPassword]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
        password: password.value, value: state.confirmedPassword.value);
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([state.email, password, confirmedPassword]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword =
        ConfirmedPassword.dirty(password: state.password.value, value: value);
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid:
            Formz.validate([state.email, state.password, confirmedPassword]),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      var result = await _authenticationRepository.signUp(
          email: state.email.value, password: state.password.value);
      await FirebaseUserApi().createUser(FSUser.User(
          id: result.id, email: result.email!, name: "", boards: const []));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
            errorMessage: e.message, status: FormzSubmissionStatus.failure),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
