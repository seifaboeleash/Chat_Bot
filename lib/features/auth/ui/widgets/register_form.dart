import 'package:chat_bot/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_bot/features/auth/ui/widgets/auth_button.dart';
import 'package:chat_bot/features/auth/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onTap,
    required this.state,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onTap;
  final AuthState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          key: const Key('registerEmailField'),
          hint: 'Email',
          prefix: const Icon(Icons.email_outlined),
          isPassword: false,
          controller: emailController,
        ),
        Gap(15.h),
        CustomTextField(
          key: const Key('registerPasswordField'),
          hint: 'Password',
          prefix: const Icon(Icons.lock_outlined),
          isPassword: true,
          controller: passwordController,
        ),
        Gap(15.h),
        state is RegisterLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : AuthButton(
                key: const Key('registerSubmitButton'),
                text: 'Register',
                onTap: onTap,
              ),
      ],
    );
  }
}
