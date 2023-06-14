import 'package:flutter/cupertino.dart';

abstract class BaseProvider extends ChangeNotifier{
  Future<void> init();
}