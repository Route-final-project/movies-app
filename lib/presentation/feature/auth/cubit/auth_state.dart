part of 'auth_cubit.dart';

class AuthState {
  final bool isLoading;
  final String errorMessage;
  final bool isSuccess;
  final AuthEntity? user;

  const AuthState({
    this.isLoading = false,
    this.errorMessage = '',
    this.isSuccess = false,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    AuthEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user,
    );
  }
}
