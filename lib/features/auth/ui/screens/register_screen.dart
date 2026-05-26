import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:chat_bot/core/utils/di.dart';
import 'package:chat_bot/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_bot/features/auth/ui/widgets/custom_snack_bar.dart';
import 'package:chat_bot/features/auth/ui/widgets/login_row.dart';
import 'package:chat_bot/features/auth/ui/widgets/register_form.dart';
import 'package:chat_bot/features/chat/ui/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            showCustomSnackBar(context, 'Registered successfully');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            );
          } else if (state is RegisterFailure) {
            showCustomSnackBar(context, state.errMessage);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.PrimaryColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Gap(300.h),
                        RegisterForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onTap: () => register(context),
                          state: state,
                        ),
                        Gap(15.h),
                        const LoginRow(),
                      ],
                    ),
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
