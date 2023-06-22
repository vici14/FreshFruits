import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/features/authens/login_screen.dart';
import 'package:fresh_fruit/features/authens/signup_screen.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

class AuthenScreen extends StatefulWidget {
  const AuthenScreen({Key? key}) : super(key: key);

  @override
  State<AuthenScreen> createState() => _AuthenScreenState();
}

class _AuthenScreenState extends State<AuthenScreen>
    with TickerProviderStateMixin {
  UserViewModel? userViewModel;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildTopActions(),
        _buildTabView(),
      ],
    );
  }

  Widget _buildTopActions() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AppImageAsset.authenAppbarBackground,
          ),
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(226, 225, 225, 0.25),
            blurRadius: 10,
            spreadRadius: 28,
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 56),
          Image.asset(
            AppImageAsset.authAppBarIcon,
            fit: BoxFit.cover,
          ),
          EasyRichText(
            locale.language.AUTHEN_TITLE,
            defaultStyle: const TextStyle(
              fontSize: 21.1179,
              height: 15 / 21.1179,
              fontWeight: FontWeight.w400,
              letterSpacing: 4.46725,
              color: surfaceSeedColor,
            ),
            patternList: [
              EasyRichTextPattern(
                targetString: 'GROCERY',
                style: const TextStyle(
                  fontSize: 21.1179,
                  height: 15 / 21.1179,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4.46725,
                  color: surfaceSeedColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 42,
            child: TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  width: 2.0,
                  color: hexToColor('#A6CE3B'),
                ),
              ),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 80),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 29 / 14,
                color: Colors.red,
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: locale.language.LOGIN),
                Tab(text: locale.language.SIGNUP),
              ],
            ),
          ),
          Container(height: 8),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TabBarView(
          controller: tabController,
          children: [
            const LoginScreen(),
            SignUpScreen(
              onSignUpSuccess: () {
                tabController?.animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
