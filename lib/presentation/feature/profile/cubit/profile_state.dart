import '../../../../domain/entity/profile_entity.dart';

class ProfileState {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.isSigningOut = false,
    this.isSendingResetPassword = false,
    this.isDeletingAccount = false,
    this.didSave = false,
    this.didSignOut = false,
    this.didSendResetPassword = false,
    this.didDeleteAccount = false,
    this.errorMessage = '',
  });

  final ProfileEntity? profile;
  final bool isLoading;
  final bool isSaving;
  final bool isSigningOut;
  final bool isSendingResetPassword;
  final bool isDeletingAccount;
  final bool didSave;
  final bool didSignOut;
  final bool didSendResetPassword;
  final bool didDeleteAccount;
  final String errorMessage;

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    bool? isSaving,
    bool? isSigningOut,
    bool? isSendingResetPassword,
    bool? isDeletingAccount,
    bool? didSave,
    bool? didSignOut,
    bool? didSendResetPassword,
    bool? didDeleteAccount,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isSigningOut: isSigningOut ?? this.isSigningOut,
      isSendingResetPassword:
          isSendingResetPassword ?? this.isSendingResetPassword,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      didSave: didSave ?? this.didSave,
      didSignOut: didSignOut ?? this.didSignOut,
      didSendResetPassword: didSendResetPassword ?? this.didSendResetPassword,
      didDeleteAccount: didDeleteAccount ?? this.didDeleteAccount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
