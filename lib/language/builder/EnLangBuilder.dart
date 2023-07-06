import 'package:fresh_fruit/language/builder/LangBuilder.dart';

class EnLangBuilder extends LangBuilder {
  @override
  String get HOME_SCREEN_BEST_SELLING => "Best Selling";

  @override
  String get HOME_SCREEN_SEE_ALL => "See all";

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
  String get FORGOT_PASSWORD => 'Forgot password?';

  @override
  String get CART_SCREEN_HEADER => "Cart";

  @override
  String get BUTTON_NEXT => "Next";

  @override
  String get CART_TOTAL => "Total:";

  @override
  String get USER_NOT_LOGGED_IN => "Please sign in to continue";

  @override
  String get DONT_HAVE_ACCOUNT_LOGIN => 'Don’t have an account? Singup';

  @override
  String get DONT_HAVE_ACCOUNT_LOGIN_PATTERN_1 => 'Singup';

  @override
  String get USERNAME => 'Username';

  @override
  String get ALREADY_HAVE_ACCOUNT_SIGNIN => 'Already have an account? Sign in';

  @override
  String get ALREADY_HAVE_ACCOUNT_SIGNIN_PATTERN_1 => 'Sign in';

  @override
  String get AUTHEN_INTRO => 'Get your groceries with Eco Grocery';

  @override
  String get LOGIN_OR_SIGNUP => 'Signin or Signup';

  @override
  String get YOU_DONT_LOGIN_YET => 'You don\'t login yet?';

  @override
  String get ACCOUNT => 'Account';

  @override
  String get HISTORY => 'History';

  @override
  String get PAYMENT_METHOD => 'Payment method';

  @override
  String get ACCOUNT_PRIVACY_SUBTITLE => 'Set up account privacy';

  @override
  String get ACCOUNT_PRIVACY_TITLE => 'Account Privacy';

  @override
  String get FAQS_SUBTITLE => 'Frequently Asked Questions';

  @override
  String get FAQS_TITLE => 'FAQs';

  @override
  String get LOG_OUT_SUBTITLE => 'Log out account in application';

  @override
  String get LOG_OUT_TITLE => 'Log Out';

  @override
  String get PUSH_NOTIFICATION_SUBTITLE => 'Set up push notifications';

  @override
  String get PUSH_NOTIFICATION_TITLE => 'Push-Notifications';

  @override
  String get CHECK_OUT_SCREEN_DELIVERY_ADDRESS => "Delivery address";

  @override
  String get CHECK_OUT_SCREEN_DELIVERY_METHOD => "Delivery method";

  @override
  String get CHECK_OUT_SCREEN_HEADER => "Checkout";

  @override
  String get BUTTON_CONFIRM => "Confirm";

  @override
  String get CHECK_OUT_SCREEN_SHIPPING_INFORMATION => '530PM Fruits apply '
      'promotion that customer will be free ship in District 5,10 and half '
      'off shipping fee for other district (not included Hoc Mon, Cu Chi, Nha'
      ' Be) when make order After 5:30 PM';

  @override
  String get CHECK_OUT_SCREEN_SHIPPING_TIME => "Delivery Time";

  @override
  String get ADD_DELIVERY_ADDRESS_HEADER => "Add Delivery Address";

  @override
  String get DELIVERY_ADDRESS_HEADER => "Delivery Address";

  @override
  String get DELIVERY_ADDRESS_DISTRICT => "District";

  @override
  String get DELIVERY_ADDRESS_SELECT_DISTRICT => "Select District";

  @override
  String get DELIVERY_ADDRESS_WARD => "Ward";

  @override
  String get DELIVERY_ADDRESS_SELECT_WARD => "Select Ward";

  @override
  String get BUTTON_ADD_ADDRESS => "Add Address";

  @override
  String get DELIVERY_ADDRESSES => "Adresses";

  @override
  String get DELIVERY_ADDRESS_CURRENT => "Current address";

  @override
  String get DELIVERY_ADDRESSES_EMPTY => "Please add shipping address";

  @override
  String get DELIVERY_TIME => "Please select time for delivery";

  @override
  String get CHECK_OUT_SCREEN_DELIVERY_AND_PAYMENT => "Delivery & Payment";

  @override
  String get CART_CHECKOUT_VALIDATE_MISSING_FIELD => "Please update Delivery "
      "address, time";

  @override
  String get DEFAULT => "(default)";

  @override
  String get BUTTON_BACK_TO_HOME => "Back to Home";

  @override
  String get ORDER_FAILED => "Oops! Order Failed";

  @override
  String get ORDER_FAILED_DESCRIPTION => "Something went wrong.";

  @override
  String get ORDER_SUCCESS => "Your Order has been accepted";

  @override
  String get ORDER_SUCCESS_DESCRIPTION =>
      "Your items has been placcd and is on it’s way to being processed";

  @override
  String get BUTTON_TRY_AGAIN => "Try again";

  @override
  String get ORDER_STATUS_CANCEL => "Canceled";

  @override
  String get ORDER_STATUS_DONE => "Done";

  @override
  String get ORDER_STATUS_PROCESSING => "Processing";

  @override
  String get CHECK_OUT_SCREEN_CART_TOTAL => "Cart total:";

  @override
  String get CHECK_OUT_SHIPPING_DISCOUNT_FREE_SHIP => "Your order got "
      "\"FREE-SHIP ";

  @override
  String get CHECK_OUT_SHIPPING_DISCOUNT_HALF_SHIP => "Your order got 50% "
      "discount "
      "delivery fee";

  @override
  String get BUTTON_SAVE_IMAGE => "Save to gallery";

  @override
  String get CHECKOUT_SUGGEST_DESTINATION => 'Suggest :';

  @override
  String get PRODUCT_DETAIL_DESCRIPTION => "Description";

  @override
  String get PRODUCT_DETAIL_ADD_TO_CART => "Add to Cart";

  @override
  String HOME_SCREEN_HELLO(String? userName) {
    return userName != null ? "Hello, $userName" : "Hello";
  }

  @override
  String get CART_EMPTY_TEXT => "Cart is empty";

  @override
  String get ADD_TO_CART_SUCCESS => "Add to Cart success!";

  @override
  String get ADD_TO_CART_FAILED => "Add to Cart failed!";

  @override
  String get BUTTON_CANCEL => "Cancel";

  @override
  String get BUTTON_CONTINUE => "Continue";

  @override
  String DELETE_FROM_CART_TITLE(String name) => "Do you want to delete "
      " ${name} from cart";
  String get PRODUCT_DETAIL_ADD_TO_CART =>"Add to Cart";

  @override
  String get SEND_OTP => 'Send OTP';

  @override
  String get OTP_CODE => 'OTP Code';

  @override
  String get OTP_CODE_SENT => 'OTP has been sent to your phone number, please enter OTP in the box below to complete the verification';

  @override
  String get OTP_CODE_SENT_FAIL => 'Sent OTP error, please try again';

  @override
  String get VERIFY_OTP_FIRST => 'Please verify OTP first before continue sign up';

  @override
  String get INPUT_FULL_SIGNUP_INFO => 'Please input full sign up fields';
}
