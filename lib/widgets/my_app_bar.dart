import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/widgets/common/CommonIconButton.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;
  final Color? backgroundColor;

  const CommonAppBar({
    required this.title,
    this.trailing,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: SafeArea(
        child: Container(
            alignment: Alignment.center,
            child: AppBar(
              backgroundColor: backgroundColor ?? hexToColor('#FCFCFC'),
              leadingWidth: 65,
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Column(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(left: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        // border: Border.all(color: AppColor.grey, width: 1),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImageAsset.iconBack,
                          color: AppColor.primary,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                fontSize: 20,
                height: 18,
                ),
              ),
              // trailing: (trailing != null)
              //     ? trailing
              //     : GestureDetector(
              //         onTap: () {
              //           Navigator.of(context).pop();
              //         },
              //         child: Text('Back')),
            )
            //
            ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(42);
}
