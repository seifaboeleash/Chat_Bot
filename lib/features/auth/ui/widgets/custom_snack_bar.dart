import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, ) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  });
}
