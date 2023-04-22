import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_dustbin_admin/model/dialog_box.dart';
import 'package:smart_dustbin_admin/screens/login/login_screen.dart';
import 'package:smart_dustbin_admin/screens/main.dart';

class AuthenticationProvider with ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;

  void login(String email, String password, BuildContext context) async {
    EasyLoading.show(status: "Please wait...");
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MainScreen()));
      EasyLoading.showSuccess("Login Successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.dismiss();
        return showDialog(
          context: context,
          builder: (_) => const CustomAlertDialog(
            title: 'Sign in',
            description:
                'Sorry, we cant\'t find an account with this email address. Please try again or create a new account.',
            bText: 'Try again',
          ),
        );
      } else if (e.code == 'wrong-password') {
        EasyLoading.dismiss();
        return showDialog(
          context: context,
          builder: (_) => const CustomAlertDialog(
            title: 'Incorrect Password',
            description: 'Your username or password is incorrect.',
            bText: 'Try again',
          ),
        );
      }
    }
  }

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

}
