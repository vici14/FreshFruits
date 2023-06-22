import 'package:flutter/material.dart';
import 'package:fresh_fruit/theme/AppColor.dart';

class CommonCircularLoading extends StatelessWidget {
  const CommonCircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
      color: AppColor.secondary,
    ));
  }
}
