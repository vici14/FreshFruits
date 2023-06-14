import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? textStyle;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool isAllowBack;

  const CommonAppbar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.textStyle,
    this.isAllowBack = true,
  }) : super(key: key);

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: textStyle ??
          Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 22,
              color: const Color(0xff1C1B1F),
              fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      titleSpacing: 0,
      leading: isAllowBack
          ? GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
          child: Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.black,
          ),
        ),
      )
          : SizedBox(),
      elevation: 0,
      centerTitle: centerTitle,
      title: _buildTitle(context),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
