import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/app_error.dart';
import '../../../../domain/entity/profile_entity.dart';
import '../../../../domain/usecase/delete_account_use_case.dart';
import '../../../../domain/usecase/forget_password_use_case.dart';
import '../../../../domain/usecase/get_profile_use_case.dart';
import '../../../../domain/usecase/sign_out_use_case.dart';
import '../../../../domain/usecase/update_profile_use_case.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.signOutUseCase,
    required this.forgetPasswordUseCase,
    required this.deleteAccountUseCase,
  }) : super(ProfileState(profile: _initialProfile()));

  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final SignOutUseCase signOutUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  static ProfileEntity? _initialProfile() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return ProfileEntity(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!
          : 'User',
      phone: '',
      avatarId: 1,
      wishlistMovies: const [],
      historyMovies: const [],
    );
  }

  Future<void> loadProfile() async {
    emit(
      state.copyWith(
        isLoading: state.profile == null,
        errorMessage: '',
        didSave: false,
      ),
    );
    final result = await getProfileUseCase();
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (profile) => emit(
        state.copyWith(isLoading: false, profile: profile, errorMessage: ''),
      ),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    emit(state.copyWith(isSaving: true, errorMessage: '', didSave: false));
    final result = await updateProfileUseCase(
      name: name,
      phone: phone,
      avatarId: avatarId,
    );
    result.fold(
      (error) =>
          emit(state.copyWith(isSaving: false, errorMessage: _message(error))),
      (profile) => emit(
        state.copyWith(
          profile: profile,
          isSaving: false,
          didSave: true,
          errorMessage: '',
        ),
      ),
    );
  }

  Future<void> signOut() async {
    emit(
      state.copyWith(isSigningOut: true, errorMessage: '', didSignOut: false),
    );
    final result = await signOutUseCase();
    result.fold(
      (error) => emit(
        state.copyWith(isSigningOut: false, errorMessage: _message(error)),
      ),
      (_) => emit(
        state.copyWith(isSigningOut: false, didSignOut: true, errorMessage: ''),
      ),
    );
  }

  Future<void> sendResetPasswordEmail() async {
    final email = state.profile?.email ?? '';
    if (email.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'No email found for this account.',
          didSendResetPassword: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSendingResetPassword: true,
        errorMessage: '',
        didSendResetPassword: false,
      ),
    );
    final result = await forgetPasswordUseCase(email: email);
    result.fold(
      (error) => emit(
        state.copyWith(
          isSendingResetPassword: false,
          errorMessage: _message(error),
        ),
      ),
      (_) => emit(
        state.copyWith(
          isSendingResetPassword: false,
          didSendResetPassword: true,
          errorMessage: '',
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    emit(
      state.copyWith(
        isDeletingAccount: true,
        errorMessage: '',
        didDeleteAccount: false,
      ),
    );
    final result = await deleteAccountUseCase();
    result.fold(
      (error) => emit(
        state.copyWith(isDeletingAccount: false, errorMessage: _message(error)),
      ),
      (_) => emit(
        state.copyWith(
          isDeletingAccount: false,
          didDeleteAccount: true,
          errorMessage: '',
        ),
      ),
    );
  }

  void consumeSavedState() {
    emit(state.copyWith(didSave: false));
  }

  void consumeSignOutState() {
    emit(state.copyWith(didSignOut: false));
  }

  void consumeResetPasswordState() {
    emit(state.copyWith(didSendResetPassword: false));
  }

  void consumeDeleteAccountState() {
    emit(state.copyWith(didDeleteAccount: false));
  }

  String _message(AppError error) {
    if (error.message.startsWith('TimeoutException')) {
      return 'Request timed out. Please check your connection.';
    }
    return error.message;
  }
}
