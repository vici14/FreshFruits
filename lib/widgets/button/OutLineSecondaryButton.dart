import 'package:flutter/material.dart';
import 'package:fresh_fruit/theme/AppColor.dart';

class OutLineSecondaryButton extends StatelessWidget {
  final Function() onTap;
  final String content;
  final bool isLoading;

  const OutLineSecondaryButton(
      {Key? key,
        required this.onTap,
        required this.content,
        this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),

        height: 67,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColor.secondary, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: !isLoading
              ? Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.secondary),
          )
              : const CircularProgressIndicator(
            color: AppColor.secondary,
          ),
        ),
      ),
    );
  }
}
