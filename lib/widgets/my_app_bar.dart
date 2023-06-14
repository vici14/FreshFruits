import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;

  const CommonAppBar({
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      child: SafeArea(
        child: Container(
            alignment: Alignment.center,
            child: NavigationToolbar(
              leading: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              ),
              middle: Text(
                title,
                textAlign: TextAlign.center,
              ),
              trailing: (trailing != null)
                  ? trailing
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Back')),
            )
            //
            ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(76);
}
