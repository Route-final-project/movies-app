import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../common_component/primaryAppButton.dart';
import '../../mainAppScreen.dart';
import 'cubit/auth_cubit.dart';
import 'widgets/auth_screen_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isEnglish = true;
  int _selectedAvatar = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainAppScreen()),
              (_) => false,
            );
          }
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: ColorsManager.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return AuthScaffold(
            title: 'Register',
            showBack: true,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    _AvatarSelector(
                      selected: _selectedAvatar,
                      onSelect: (avatarId) =>
                          setState(() => _selectedAvatar = avatarId),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Avatar',
                      style: GoogleFonts.roboto(
                        color: ColorsManager.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 29.h),
                    AuthField(
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: 'Name',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AuthField(
                      controller: _emailController,
                      prefixIcon: const Icon(Icons.email_outlined),
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    AuthField(
                      controller: _passwordController,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onSuffixClicked: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      hintText: 'Password',
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) return 'Minimum 6 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    AuthField(
                      controller: _confirmPasswordController,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onSuffixClicked: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                      hintText: 'Confirm Password',
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    AuthField(
                      controller: _phoneController,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Phone is required'
                          : null,
                    ),
                    SizedBox(height: 35.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: PrimaryAppButton(
                        text: 'Create Account',
                        isLoading: state.isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _phoneController.text.trim(),
                              _selectedAvatar,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 21.h),
                    AuthLinkText(
                      prefix: 'Already Have Account ? ',
                      action: 'Login',
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(height: 23.h),
                    AuthLanguageToggle(
                      isEnglish: _isEnglish,
                      onToggle: (value) => setState(() => _isEnglish = value),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AvatarSelector extends StatelessWidget {
  const _AvatarSelector({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final avatarId = index + 1;
        final isSelected = avatarId == selected;
        final size = isSelected ? 82.r : 66.r;
        return GestureDetector(
          onTap: () => onSelect(avatarId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: size,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.all(isSelected ? 4.r : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: ColorsManager.gold, width: 3.r)
                  : null,
            ),
            child: ClipOval(
              child: Image.asset(
                ImageAssets.avatars[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: ColorsManager.grey,
                  child: Icon(
                    Icons.person,
                    color: ColorsManager.white,
                    size: 36.r,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
