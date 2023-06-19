import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/view_model/authen_viewmodel.dart';
import 'package:fresh_fruit/widgets/keyboard_dismisser.dart';
import 'package:fresh_fruit/widgets/textfield/common_textfield.dart';
import 'package:provider/provider.dart';

class AuthenScreen extends StatefulWidget {
  const AuthenScreen({Key? key}) : super(key: key);

  @override
  State<AuthenScreen> createState() => _AuthenScreenState();
}

class _AuthenScreenState extends State<AuthenScreen>
    with TickerProviderStateMixin {
  AuthViewModel? authViewModel;
  TabController? tabController;

  TextEditingController? loginUserNameCtl;
  TextEditingController? loginPasswordCtl;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    loginUserNameCtl = TextEditingController();
    loginPasswordCtl = TextEditingController();
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
          const SizedBox(height: 128),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 44),
                CommonTextField(
                  controller: loginUserNameCtl ?? TextEditingController(),
                  labelText: 'Email',
                ),
                const SizedBox(height: 21),
                CommonTextField(
                  controller: loginUserNameCtl ?? TextEditingController(),
                  labelText: locale.language.PASSWORD,
                  password: true,
                ),
                const SizedBox(height: 16),
                Text(
                  locale.language.FORGOT_PASSWORD,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 108.1 / 100,
                    wordSpacing: 0.05,
                    color: tertiarySeedColor,
                  ),
                ),
                const SizedBox(height: 51),
                InkWell(
                  child: Container(
                    height: 67,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primarySeedColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        locale.language.LOGIN,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                        fontSize: 22,
                            wordSpacing: 1,
                          color: hexToColor('#FFF9FF'),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    authViewModel?.login();
                  },
                ),
              ],
            ),
            Container(
              height: 100,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
