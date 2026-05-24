import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resource/colors_manager.dart';
import '../../common_component/appTextField.dart';
import '../../common_component/primaryAppButton.dart';
import '../../common_component/secondaryAppButton.dart';
import '../auth/login_screen.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'widgets/avatar_picker_sheet.dart';
import 'widgets/profile_avatar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _initialized = false;
  int _avatarId = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields(ProfileState state) {
    if (_initialized || state.profile == null) return;
    final profile = state.profile!;
    _nameController.text = profile.name;
    _phoneController.text = profile.phone;
    _avatarId = profile.avatarId;
    _initialized = true;
  }

  void _openAvatarPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => AvatarPickerSheet(
          selectedAvatarId: _avatarId,
          onSelected: (value) {
            setState(() => _avatarId = value);
            setSheetState(() {});
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorsManager.grey,
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: ColorsManager.red),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      context.read<ProfileCubit>().deleteAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.didDeleteAccount) {
          context.read<ProfileCubit>().consumeDeleteAccountState();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        } else if (state.didSave) {
          context.read<ProfileCubit>().consumeSavedState();
          final messenger = ScaffoldMessenger.of(context);
          Navigator.pop(context);
          messenger.showSnackBar(
            const SnackBar(content: Text('Profile updated successfully.')),
          );
        } else if (state.didSendResetPassword) {
          context.read<ProfileCubit>().consumeResetPasswordState();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email sent. Check your inbox.'),
            ),
          );
        } else if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        _populateFields(state);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Update Profile'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 17.h, 16.w, 17.h),
                child: Column(
                  children: [
                    InkWell(
                      onTap: _openAvatarPicker,
                      customBorder: const CircleBorder(),
                      child: ProfileAvatar(avatarId: _avatarId, size: 150.r),
                    ),
                    SizedBox(height: 36.h),
                    AppTextField(
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'Name',
                      validator: (value) {
                        return value == null || value.trim().isEmpty
                            ? 'Name is required'
                            : null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _phoneController,
                      prefixIcon: const Icon(Icons.phone),
                      hintText: 'Phone',
                      keyboardType: TextInputType.phone,
                      validator: (_) => null,
                    ),
                    SizedBox(height: 25.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: state.isSendingResetPassword
                            ? null
                            : context
                                  .read<ProfileCubit>()
                                  .sendResetPasswordEmail,
                        child: state.isSendingResetPassword
                            ? SizedBox(
                                width: 18.r,
                                height: 18.r,
                                child: const CircularProgressIndicator(
                                  color: ColorsManager.gold,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Reset Password',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: state.isDeletingAccount
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.gold,
                              ),
                            )
                          : SecondaryAppButton(
                              text: 'Delete Account',
                              onPressed: _confirmDeleteAccount,
                            ),
                    ),
                    SizedBox(height: 15.h),
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: state.isSaving
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.gold,
                              ),
                            )
                          : PrimaryAppButton(
                              text: 'Update Data',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ProfileCubit>().updateProfile(
                                    name: _nameController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                    avatarId: _avatarId,
                                  );
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
