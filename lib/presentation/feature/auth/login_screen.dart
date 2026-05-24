import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../mainAppScreen.dart';
import 'cubit/auth_cubit.dart';
import 'forget_password_screen.dart';
import 'register_screen.dart';
import 'widgets/auth_screen_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isEnglish = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainAppScreen()),
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 52.h),
                    Image.asset(
                      ImageAssets.appLogo,
                      width: 120.w,
                      height: 120.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 55.h),
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
                    SizedBox(height: 18.h),
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
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgetPasswordScreen(),
                          ),
                        ),
                        child: Text(
                          'Forget Password ?',
                          style: GoogleFonts.roboto(
                            color: ColorsManager.gold,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 31.h),
                    AuthPrimaryButton(
                      text: 'Login',
                      isLoading: state.isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signIn(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 23.h),
                    AuthLinkText(
                      prefix: "Don't Have Account ? ",
                      action: 'Create One',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                    ),
                    SizedBox(height: 31.h),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: ColorsManager.grey,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Text(
                            'OR',
                            style: GoogleFonts.roboto(
                              color: ColorsManager.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: ColorsManager.grey,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 31.h),
                    AuthGoogleButton(
                      isLoading: state.isLoading,
                      onPressed: () =>
                          context.read<AuthCubit>().signInWithGoogle(),
                    ),
                    SizedBox(height: 32.h),
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
