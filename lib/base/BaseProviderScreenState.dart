import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/common/CommonAppBar.dart';

abstract class BaseProviderScreenState<T extends StatefulWidget,
    C extends ChangeNotifier> extends State<T> {
  C initLocalController();

  Widget buildContent(BuildContext context, C localState);

  bool enableHeader() => true;

  bool centerAppBarTitle() => true;

  bool enableBackButton() => true;

  bool enableSafeAreaTop() => false;

  bool enableSafeAreaBottom() => false;

  String appBarTitle() => "Admin";

  List<Widget>? appBarActions() => null;

  Color? setBackgroundColor() => null;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return initLocalController();
      },
      builder: (_, child) => Consumer<C>(
        builder: (context, localState, child) {
          return SafeArea(
            left: false,
            right: false,
            top: enableSafeAreaTop(),
            bottom: enableSafeAreaBottom(),
            child: Scaffold(
              backgroundColor: setBackgroundColor(),
                appBar: enableHeader()
                    ? CommonAppbar(
                        title: appBarTitle(),
                        centerTitle: centerAppBarTitle(),
                        isAllowBack: enableBackButton(),
                        actions: appBarActions(),
                      )
                    : null,
                body: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: buildContent(context, localState))),
          );
        },
      ),
    );
  }
}
