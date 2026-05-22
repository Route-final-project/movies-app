import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../common_component/appTextField.dart';
import '../../common_component/primaryAppButton.dart';
import 'cubit/auth_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    'Password reset email sent! Check your inbox.'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
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
                'Forget Password',
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      Expanded(child: _ForgetPasswordIllustration()),
                      SizedBox(height: 32.h),
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
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: state.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: ColorsManager.gold))
                            : PrimaryAppButton(
                                text: 'Verify Email',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<AuthCubit>()
                                        .sendPasswordResetEmail(
                                          _emailController.text.trim(),
                                        );
                                  }
                                },
                              ),
                      ),
                      SizedBox(height: 32.h),
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

class _ForgetPasswordIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageAssets.forgetPasswordImage,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, _) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: ColorsManager.gold.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close, color: ColorsManager.red, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text('**********',
                      style: GoogleFonts.roboto(
                          color: ColorsManager.black,
                          fontSize: 16.sp,
                          letterSpacing: 2)),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Icon(Icons.person_2_outlined,
                size: 80.sp, color: ColorsManager.gold),
          ],
        ),
      ),
    );
  }
}
