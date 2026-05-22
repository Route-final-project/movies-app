import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../common_component/appTextField.dart';
import '../../common_component/language_toggle.dart';
import '../../common_component/primaryAppButton.dart';
import '../../mainAppScreen.dart';
import '../../signin.dart';
import 'cubit/auth_cubit.dart';
import 'forget_password_screen.dart';
import 'register_screen.dart';

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
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 48.h),
                      const AppLogo(size: 120),
                      SizedBox(height: 40.h),
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
                      SizedBox(height: 16.h),
                      AppTextField(
                        controller: _passwordController,
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Password',
                        obscureText: _obscurePassword,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (v.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                        suffixIcon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onSuffixClicked: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      SizedBox(height: 8.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgetPasswordScreen()),
                          ),
                          child: Text(
                            'Forget Password ?',
                            style: GoogleFonts.roboto(
                              color: ColorsManager.gold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: state.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: ColorsManager.gold))
                            : PrimaryAppButton(
                                text: 'Login',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signIn(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                },
                              ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't Have Account ? ",
                            style: GoogleFonts.roboto(
                              color: ColorsManager.white,
                              fontSize: 14.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'Create One',
                                style: GoogleFonts.roboto(
                                  color: ColorsManager.gold,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: ColorsManager.white
                                      .withValues(alpha: 0.3))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text('OR',
                                style: GoogleFonts.roboto(
                                    color: ColorsManager.white,
                                    fontSize: 14.sp)),
                          ),
                          Expanded(
                              child: Divider(
                                  color: ColorsManager.white
                                      .withValues(alpha: 0.3))),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () =>
                                  context.read<AuthCubit>().signInWithGoogle(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.grey,
                            foregroundColor: ColorsManager.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(ImageAssets.googleIcon,
                                  width: 24.w, height: 24.h),
                              SizedBox(width: 12.w),
                              Text('Login With Google',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      color: ColorsManager.white)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      LanguageToggle(
                        isEnglish: _isEnglish,
                        onToggle: (val) =>
                            setState(() => _isEnglish = val),
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
