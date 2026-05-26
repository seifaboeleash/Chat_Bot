import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    this.controller, required this.prefix,
     this.onChanged,
  });
  final String hint;
  final bool isPassword;
  final Icon prefix;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  void tooglePassword() {
    _obscureText = !_obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.hint} is required';
        }
        // ✅ لو الـ field بتاع email
  if (widget.hint == 'Email') {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
  }

  // ✅ لو الـ field بتاع password
  if (widget.hint == 'Password') {
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
  }

  return null;
      },
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      cursorColor: Colors.black,
      cursorHeight: 20,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: widget.prefix,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    tooglePassword();
                  });
                },
                child: Icon(
                  Icons.remove_red_eye_rounded,
                  color: AppColors.PrimaryColor,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
