import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';

const Color ukColor = Color(0xFF0D6DD5);
const Color viColor = Color(0xFFF42F4C);

class LanguageSwitch extends StatefulWidget {
  final bool isVietnamese;
  final Function(bool) onChange;

  const LanguageSwitch({
    Key? key,
    required this.onChange,
    this.isVietnamese = true,
  }) : super(key: key);

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  Widget ukWidget =
      Image.asset(AppImageAsset.icUKToggle, width: 23, height: 23);
  Widget viWidget = Image.asset(AppImageAsset.icVIToggle, width: 12);

  @override
  void initState() {
    super.initState();
  }

  Widget _node(Widget image, Color color, Color borderColor) {
    return Container(
      alignment: Alignment.center,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: borderColor, width: 0.5)),
      child: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onChange(!widget.isVietnamese);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 16,
              decoration: ShapeDecoration(
                color: widget.isVietnamese ? viColor : ukColor,
                shape: SmoothRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 8,
                    cornerSmoothing: 0.6,
                  ),
                ),
              ),
            ),
            widget.isVietnamese
                ? Positioned(
                    right: 0,
                    child: _node(viWidget, viColor, const Color(0xFFFFFFFF)),
                  )
                : Positioned(
                    left: 0,
                    child: _node(ukWidget, ukColor, ukColor),
                  ),
          ],
        ),
      ),
    );
  }
}
