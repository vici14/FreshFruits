import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fresh_fruit/features/account/UserScreen.dart';
import 'package:fresh_fruit/features/authens/authen_screen.dart';
import 'package:fresh_fruit/features/favourite/favorite_products_screen.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'features/home/HomeScreen.dart';
import 'features/store/store_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class HomeNavigationScreen extends StatefulWidget {
  @override
  State<HomeNavigationScreen> createState() {
    return _HomeNavigationScreenState();
  }
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen>
    with TickerProviderStateMixin {
  final CupertinoTabController _tabController = CupertinoTabController();
  List<Widget>? listTab;
  int oldTab = 0;
  final autoSizeGroup = AutoSizeGroup();
  int _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  final iconList = [
    AppImageAsset.bottomHomeIcon,
    AppImageAsset.bottomSearchIcon,
    AppImageAsset.bottomFavouriteIcon,
    AppImageAsset.bottomUserIcon,
  ];

  @override
  void initState() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
    super.initState();
    listTab = [
      HomeScreen(),
      StoreScreen(),
      FavoriteProductsScreen(),
      AuthenScreen(),
    ];
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        clipBehavior: Clip.antiAlias,
        shape: const CircleBorder(),
        onPressed: () {},
        child: SvgPicture.asset(
          AppImageAsset.bottomCartIcon,
          width: 32,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: listTab![_bottomNavIndex],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = Theme.of(context).colorScheme.primary;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconList[index],
                width: 24,
                color: color,
              ),
            ],
          );
        },
        backgroundColor: Theme.of(context).colorScheme.background,
        activeIndex: _bottomNavIndex,
        splashColor: Theme.of(context).colorScheme.surface,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: onTabTap,
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 0.5,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  CupertinoTabBar _buildBottomBar() {
    return CupertinoTabBar(
        activeColor: Colors.green,
        onTap: onTabTap,
        backgroundColor: Colors.grey.withOpacity(0.5),
        items: <BottomNavigationBarItem>[
          _buildBottomBarItem(
            icon: const Icon(Icons.home),
            label: "home",
            activeIcon: const Icon(
              Icons.home,
              color: Colors.green,
            ),
          ),
          _buildBottomBarItem(
            icon: const Icon(Icons.store),
            label: "Store",
            activeIcon: const Icon(
              Icons.store,
              color: Colors.green,
            ),
          ),
        ]);
  }

  BottomNavigationBarItem _buildBottomBarItem(
      {required Widget icon,
      required Widget activeIcon,
      required String label}) {
    return BottomNavigationBarItem(
        icon: icon, activeIcon: activeIcon, label: label);
  }

  void onTabTap(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }
}
