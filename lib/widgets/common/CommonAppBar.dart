import 'package:flutter/material.dart';
import 'package:fresh_fruit/widgets/common/CommonIconButton.dart';

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
          Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      foregroundColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      leading: isAllowBack
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [CommonIconButton.buildBackButton(context)],
              ),
            )
          : const SizedBox(),
      elevation: 0,
      centerTitle: centerTitle,
      title: _buildTitle(context),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
