import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../common_component/appTextField.dart';
import '../../common_component/language_toggle.dart';
import '../../common_component/primaryAppButton.dart';
import '../../mainAppScreen.dart';
import 'cubit/auth_cubit.dart';

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
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Register',
                style: GoogleFonts.roboto(
                    color: ColorsManager.gold,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: ColorsManager.gold),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: ColorsManager.black,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 24.h),
                      _AvatarSelector(
                        selected: _selectedAvatar,
                        onSelect: (i) =>
                            setState(() => _selectedAvatar = i),
                      ),
                      SizedBox(height: 10.h),
                      Text('Avatar',
                          style: GoogleFonts.roboto(
                              color: ColorsManager.white, fontSize: 16.sp)),
                      SizedBox(height: 24.h),
                      AppTextField(
                        controller: _nameController,
                        prefixIcon: const Icon(Icons.person_outline),
                        hintText: 'Name',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Name is required' : null,
                      ),
                      SizedBox(height: 14.h),
                      AppTextField(
                        controller: _emailController,
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      SizedBox(height: 14.h),
                      AppTextField(
                        controller: _passwordController,
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Password',
                        obscureText: _obscurePassword,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 6) { return 'Minimum 6 characters'; }
                          return null;
                        },
                        suffixIcon: Icon(_obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onSuffixClicked: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      SizedBox(height: 14.h),
                      AppTextField(
                        controller: _confirmPasswordController,
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Confirm Password',
                        obscureText: _obscureConfirmPassword,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please confirm password';
                          }
                          if (v != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        suffixIcon: Icon(_obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onSuffixClicked: () => setState(() =>
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword),
                      ),
                      SizedBox(height: 14.h),
                      AppTextField(
                        controller: _phoneController,
                        prefixIcon: const Icon(Icons.phone_outlined),
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Phone is required' : null,
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        child: state.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: ColorsManager.gold))
                            : PrimaryAppButton(
                                text: 'Create Account',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().register(
                                          _nameController.text.trim(),
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                },
                              ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already Have Account ? ',
                            style: GoogleFonts.roboto(
                                color: ColorsManager.white, fontSize: 14.sp),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: GoogleFonts.roboto(
                                    color: ColorsManager.gold,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      LanguageToggle(
                        isEnglish: _isEnglish,
                        onToggle: (val) => setState(() => _isEnglish = val),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
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
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isSelected = i == selected;
        final double size = isSelected ? 82.r : 70.r;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: ColorsManager.gold, width: 3)
                  : null,
            ),
            child: ClipOval(
              child: Image.asset(
                ImageAssets.avatars[i],
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => Container(
                  color: const Color(0xFF5B9BD5),
                  child: Icon(Icons.person,
                      color: ColorsManager.white, size: 36.sp),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
