import 'package:flutter/material.dart';

import '../widgets/common/CommonAppBar.dart';

class ErrorScreen extends StatelessWidget {
  final Exception? error;
  late String message;

  ErrorScreen({Key? key, required this.error}) : super(key: key) {
    if (error != null) {
      message = error.toString();
    } else {
      message = 'Screen ${error} is not support';
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CommonAppbar(
          title: 'Error',
        ),
        body: Center(child: Text('')));
  }
}
