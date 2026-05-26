import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../common_component/primaryAppButton.dart';
import 'cubit/auth_cubit.dart';
import 'widgets/auth_screen_widgets.dart';

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
              const SnackBar(
                content: Text('Password reset email sent! Check your inbox.'),
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
          return AuthScaffold(
            title: 'Forget Password',
            showBack: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 78.h),
                    Image.asset(
                      ImageAssets.forgetPasswordImage,
                      width: 335.w,
                      height: 330.h,
                      fit: BoxFit.contain,
                    ),
                    const Spacer(),
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
                    SizedBox(height: 27.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: PrimaryAppButton(
                        text: 'Verify Email',
                        isLoading: state.isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().sendPasswordResetEmail(
                              _emailController.text.trim(),
                            );
                          }
                        },
                      ),
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
