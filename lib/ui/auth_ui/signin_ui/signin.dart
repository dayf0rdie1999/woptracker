import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/ui/auth_ui/customtextformfield.dart';
import 'package:woptracker/ui/auth_ui/signup_ui/signup.dart';
import 'package:woptracker/ui/auth_ui/signup_ui/signupbasewrapper.dart';



class SignInUI extends StatefulWidget {
  const SignInUI({Key? key}) : super(key: key);

  @override
  _SignInUIState createState() => _SignInUIState();
}

class _SignInUIState extends State<SignInUI> {

  // Todo: Create a firebaseauth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Todo: Creating a global key
  final _signInFormKey = GlobalKey<FormState>();
  
  // Todo: Creating a Text Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String snackBarText = "No user found for that email";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var bottom = MediaQuery.of(context).viewInsets.bottom;

    return Form(
        key: _signInFormKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: CustomTextFormField(key: Key("EmailTextFormField"),controller: _emailController,labelText: "Email",obscureText: false,labelColor: Colors.white,),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: CustomTextFormField(key: Key("PasswordTextFormField"),controller: _passwordController,labelText: "Password",obscureText: true,labelColor: Colors.white,),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                        key: Key('signIn'),
                        onPressed: () async {
                          if (_signInFormKey.currentState!.validate()) {
                            String? result = await AuthService(auth: _auth).signInWithEmailAndPassword(_emailController.text, _passwordController.text);

                            if (result != null) {
                              if (result == 'user-not-found') {
                                setState(() {
                                  snackBarText = "No user found for that email.";
                                });
                                _emailController.clear();
                                _passwordController.clear();
                              } else if (result == 'wrong-password') {
                                setState(()  {
                                  snackBarText = "Wrong password provided for that user";
                                });
                                _emailController.clear();
                                _passwordController.clear();
                              }
                            } else {
                              setState(() {
                                snackBarText = "Successfully Signed In";
                              });
                              _emailController.clear();
                              _passwordController.clear();
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackBarText)));
                        },
                        child: Text("Sign In"))
                  ),
                  SizedBox(width: 32.0,),
                  Expanded(
                      child: TextButton(
                        key: Key("NavigateSignUpUI"),
                        onPressed: (){
                          _emailController.clear();
                          _passwordController.clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpUIWrapper())
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}



