import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin_admin/provider/authentication_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  String _email = "", _password = "";
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {

    final authentication = Provider.of<AuthenticationProvider>(context);

    void validateLogin() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        authentication.login(_email, _password, context);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Welcome,",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Sign in to continue!",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade400),
                    ),
                  ],
                ),
                const SizedBox(height: 200),
                Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email ID",
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      validator: (email) {
                        if (email!.isEmpty) {
                          return 'Please Enter email ID';
                        } else if (!EmailValidator.validate(email)) {
                          return 'Enter valid email address';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (email) => _email = email!,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorMaxLines: 5,
                        labelText: "Password",
                        labelStyle: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: _toggle,
                        ),
                      ),
                      validator: (password) {
                        String pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        RegExp regex = RegExp(pattern);
                        if (password!.isEmpty) {
                          return 'Please Enter Password';
                        } else if (password.length < 8) {
                          return 'Password must be between 8 and 30 characters';
                        } else if (!regex.hasMatch(password)) {
                          return 'Passwords must contain:\n  - at least 1 uppercase [A-Z]\n  - at least 1 lowercase [a-z]\n  - at least 1 number [0-9]\n  - at least 1 Special Character';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (password) => _password = password!,
                      textInputAction: TextInputAction.done,
                      obscureText: _obscureText,
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          validateLogin();
                        },
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xffff5f6d),
                                Color(0xffff5f6d),
                                Color(0xffffc371),
                              ],
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                                maxWidth: double.infinity, minHeight: 50),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
