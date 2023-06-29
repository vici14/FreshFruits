import 'package:flutter/material.dart';
import 'package:fresh_fruit/extension/IterableExtension.dart';

class OnPrimaryTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const OnPrimaryTextButton(
      {super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onTap(),
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent,),
        child: Center(child: Text(text.toTitleCase(), style: Theme
            .of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(
          fontSize: 22, fontWeight: FontWeight.w500,
        ),
        ),),
      ),
    );
  }
}