import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/others/auth.dart';
import 'package:testapp/others/constants.dart';
import 'package:testapp/screens/home/admin.dart';
import 'package:testapp/screens/home/home_screen.dart';
import 'package:testapp/screens/loading/onBoarding_screen.dart';
import 'package:testapp/screens/loading/waiting_screen.dart';
import 'package:testapp/screens/login/reset.dart';

import 'email_auth.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login_Screen';

  LoginScreen({@required this.auth});

  final AuthBase auth;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      await widget.auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  bool loading = false, userRole;
  String userId, error = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SharedPreferences prefs;
  bool showOnBoarding = false;

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    showOnBoarding = prefs.getBool('first') ?? true;
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? WaittingScreen()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Image.asset('assets/images/img.jpg'),
                  ),
                  Card(
                    elevation: 3,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Savior',
                                    style: TextStyle(
                                      fontSize: 35.0,
                                      letterSpacing: 1.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              child: TextFormField(
                                controller: emailController,
                                style: TextStyle(),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue,
                                          style: BorderStyle.solid)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red,
                                          style: BorderStyle.solid)),
                                  hintText: 'Enter email-address',
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.indigo),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.indigo,
                                          style: BorderStyle.solid)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue,
                                          style: BorderStyle.solid)),
                                ),
                                onChanged: (v) {
                                  _loginFormKey.currentState.validate();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter Valid Email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: TextFormField(
                                controller: passwordController,
                                style: TextStyle(),
                                onChanged: (v) {
                                  _loginFormKey.currentState.validate();
                                },
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Enter password',
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.indigo),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue,
                                          style: BorderStyle.solid)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.indigo,
                                          style: BorderStyle.solid)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue,
                                          style: BorderStyle.solid)),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be more than 8 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (error != '')
                              SizedBox(
                                height: 8,
                              ),
                            if (error != '')
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Forgot Password?'),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ResetScreen()),
                                  ),
                                )
                              ],
                            ),
                            RaisedButton.icon(
                              label: Text(
                                'Sign in',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              color: Colors.green.shade300,
                              padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                              onPressed: () async {
                                if (_loginFormKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    await loginUser();
                                  } catch (e) {}
                                  setState(() {
                                    passwordController.clear();
                                    loading = false;
                                    error =
                                        'could not sign in with those credentials';
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: AutoSizeText(
                                    'Don\'t have an account? ',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EmailRegister();
                                    }));
                                  },
                                  child: Container(
                                    child: AutoSizeText('Sign up',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  kFacebookImage,
                                  height: 55,
                                ),
                                SizedBox(
                                  width: 28,
                                ),
                                GestureDetector(
                                  onTap: _signInWithGoogle,
                                  child: Image.asset(
                                    kGoogleImage,
                                    height: 55,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ));
  }

/*  loginUser() async {
    return await _auth
        .signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((value) {
      Navigator.pushReplacementNamed(context, Admin.id);
    });
  }*/

  loginUser() async {
    await _auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) async {
      if (!showOnBoarding) {
        await getCurrentUser();
        await Firestore.instance
            .collection('profile')
            .document(userId)
            .get()
            .then((DocumentSnapshot) => {
                  userRole = DocumentSnapshot.data['role'],
                  if (userRole)
                    {
                      Navigator.pushReplacementNamed(context, Admin.id),
                    }
                  else
                    {
                      Navigator.pushReplacementNamed(context, HomeScreen.id),
                    }
                });
      } else {
        Navigator.pushReplacementNamed(context, OnBoardingScreen.id);
      }
    });

    print('User Role in Here: ' + userRole.toString() + ' id = ' + userId);
  }

  getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      userId = user.uid;
    });
  }

/*  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }*/
}
