import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/auth_entity.dart';
import '../../../../domain/usecase/forget_password_use_case.dart';
import '../../../../domain/usecase/google_sign_in_use_case.dart';
import '../../../../domain/usecase/register_use_case.dart';
import '../../../../domain/usecase/sign_in_use_case.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.signInUseCase,
    required this.googleSignInUseCase,
    required this.registerUseCase,
    required this.forgetPasswordUseCase,
  }) : super(const AuthState());

  final SignInUseCase signInUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final RegisterUseCase registerUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;

  void signIn(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result = await signInUseCase(email: email, password: password);
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (user) =>
          emit(state.copyWith(isLoading: false, isSuccess: true, user: user)),
    );
  }

  void signInWithGoogle() async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result = await googleSignInUseCase();
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (user) =>
          emit(state.copyWith(isLoading: false, isSuccess: true, user: user)),
    );
  }

  void register(
    String name,
    String email,
    String password,
    String phone,
    int avatarId,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
      phone: phone,
      avatarId: avatarId,
    );
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (user) =>
          emit(state.copyWith(isLoading: false, isSuccess: true, user: user)),
    );
  }

  void sendPasswordResetEmail(String email) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result = await forgetPasswordUseCase(email: email);
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }
}
