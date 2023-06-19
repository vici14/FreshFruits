import 'package:fresh_fruit/service/service_manager.dart';
import 'package:fresh_fruit/view_model/base_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends BaseViewModel {
  final ServiceManager _serviceManager = ServiceManager();

  void signIn() {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
    // FirebaseAuth.instance.signInWithEmailAndPassword(email: 'test2@gmail.com', password: '111111');

    _serviceManager.signInWithEmailAndPassword(email: 'cuongtest@gmail.com',
        password: "123456");
  }

  void signUp(){
    _serviceManager.signUpWithEmailAndPassword(email: "cuongtest@gmail.com",
        password: '123456');
  }
}
