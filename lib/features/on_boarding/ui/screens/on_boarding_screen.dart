import 'package:chat_bot/features/on_boarding/ui/widgets/custom_button.dart';
import 'package:chat_bot/features/on_boarding/ui/widgets/on_boarding_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('onBoardingScreenScaffold'),
      backgroundColor: Colors.white,
      body:SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(top :80.h , right: 16.w ,left: 16.h , bottom: 20.h),
          child: Column(
            children: [
              OnBoardingTitle(),
              SizedBox(height: 50.h,),
              Image.asset(
                'assets/images/Frame 33.png',
                height: 320.h,
                width: 320.w,
                ),
                Spacer(),
                CustomButton(),
                
            ],
          ),
        ),
      )
    );
  }
}