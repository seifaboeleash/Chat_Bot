import 'package:chat_bot/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_bot/features/auth/ui/widgets/auth_button.dart';
import 'package:chat_bot/features/auth/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.onTap,
    required this.emailController,
    required this.passController,
    required this.state,
  });

  final TextEditingController emailController;
  final TextEditingController passController;
  final VoidCallback onTap;
  final AuthState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          key: const Key('loginEmailField'),
          hint: 'Email',
          prefix: const Icon(Icons.email_outlined),
          isPassword: false,
          controller: emailController,
        ),
        Gap(15.h),
        CustomTextField(
          key: const Key('loginPasswordField'),
          hint: 'Password',
          prefix: const Icon(Icons.lock_outlined),
          isPassword: true,
          controller: passController,
        ),
        Gap(15.h),
        state is LoginLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : AuthButton(
                key: const Key('loginSubmitButton'),
                text: 'Login',
                onTap: onTap,
              ),
      ],
    );
  }
}
