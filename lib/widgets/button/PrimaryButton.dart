import 'package:flutter/material.dart';
import 'package:fresh_fruit/theme/AppColor.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final bool? isLoading;

  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: isLoading == true
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                ),
        ),
      ),
    );
  }
}
