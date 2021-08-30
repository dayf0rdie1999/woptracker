import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/ui/auth_ui/customtextformfield.dart';

class SignUpUI extends StatefulWidget {

  SignUpUI({Key? key}) : super(key: key);

  @override
  _SignUpUIState createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {

  final _authService = AuthService(auth: FirebaseAuth.instance);

  final _SignUpFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmedPasswordController = TextEditingController();

  String _snackBarText = "The Password is weak";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _SignUpFormKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: CustomTextFormField(
              key: Key("signUpEmailTextField"),
              controller: _emailController,
              labelText: "Email",
              obscureText: false,
              labelColor: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: CustomTextFormField(
              key: Key("signUpPasswordTextField"),
              controller: _passwordController,
              labelText: "Password",
              obscureText: true,
              labelColor: Colors.white,
              ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: CustomTextFormField(
              key: Key("signUpConfirmedPasswordTextField"),
              controller: _confirmedPasswordController,
              labelText: "Confirmed Password",
              obscureText: true,
              labelColor: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Row(
                children: <Widget>[
                Expanded(
                child: ElevatedButton(
                  key: Key("SignUpButton"),
                  onPressed: () async {
                    if (_SignUpFormKey.currentState!.validate()) {
                      if (_passwordController.text == _confirmedPasswordController.text) {
                        String? result = await _authService.signUpWithEmailAndPassword(_emailController.text, _passwordController.text);
                        print(result);
                          if (result == 'weak-password') {
                            setState(() {
                              _snackBarText = "The password is weak";
                            });

                            _emailController.clear();
                            _passwordController.clear();
                            _confirmedPasswordController.clear();
                          } else if (result == 'email-already-in-use') {

                            setState(() {
                              _snackBarText = "The account already exists for that email.";
                            });

                            _emailController.clear();
                            _passwordController.clear();
                            _confirmedPasswordController.clear();
                          } else {
                            setState(() {
                              _snackBarText = "Successfully Sign Up";
                            });
                            Navigator.pop(context);
                          }
                      } else {
                        setState(() {
                          _snackBarText = "Password and Confirmed Password are not the same";
                        });

                        _emailController.clear();
                        _passwordController.clear();
                        _confirmedPasswordController.clear();
                        }
                      }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_snackBarText,key: Key("SignUpSnackBarText"),)));
                    },
                    child: Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
