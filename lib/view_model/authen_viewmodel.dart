import 'package:fresh_fruit/view_model/base_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends BaseViewModel {


  void login() {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
    FirebaseAuth.instance.signInWithEmailAndPassword(email: 'test2@gmail.com', password: '111111');
  }
}
