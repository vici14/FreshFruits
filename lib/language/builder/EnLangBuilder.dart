import 'package:fresh_fruit/language/builder/LangBuilder.dart';

class EnLangBuilder extends LangBuilder{
  @override
  String get HOME_SCREEN_BEST_SELLING =>"Best Selling";

  @override
  String get HOME_SCREEN_SEE_ALL =>"See all";

  @override
  String get HOME_SCREEN_NEW_PRODUCTS => "Newest";

  @override
  String get AUTHEN_TITLE => 'ECO GROCERY';

  @override
  String get LOGIN => 'Login';

  @override
  String get SIGNUP => 'Signup';

  @override
  String get PASSWORD => 'Password';

  @override
  // TODO: implement FORGOT_PASSWORD
  String get FORGOT_PASSWORD => 'Forgot password?';
}