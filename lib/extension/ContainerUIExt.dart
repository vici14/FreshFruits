import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/AppColor.dart';

extension ContainerUIExt on Container {
  Container addWhiteBoxShadow() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: AppColor.grey,
                spreadRadius: 0.8,
                blurRadius: 1,
                offset: Offset(0, 1.2)),
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.grey, width: 1)),
      child: this,
    );
  }
}
