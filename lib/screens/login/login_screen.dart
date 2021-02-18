import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/others/auth.dart';
import 'package:testapp/others/constants.dart';
import 'package:testapp/screens/home/home_screen.dart';
import 'package:testapp/screens/home/home_screen_admin.dart';

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

  String userId, userRole;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Image.asset('assets/images/loadingimage.jpg'),
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
                                'Test ',
                                style: TextStyle(
                                  fontSize: 30.0,
                                ),
                              ),
                              Text(
                                'APP',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 30.0,
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
                              if (!value.contains('@') || value.length < 5) {
                                return 'Enter Valid Email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
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
                        SizedBox(
                          height: 15,
                        ),
                        RaisedButton.icon(
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
                              await loginUser();
                            }
                          },
                          label: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
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
                                    fontSize: 17, fontWeight: FontWeight.w500),
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  loginUser() async {
    await _auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) async {
      await getCurrentUser();
      await Firestore.instance
          .collection('profile')
          .document(userId)
          .get()
          .then((DocumentSnapshot) => {
                userRole = DocumentSnapshot.data['role'].toString(),
                print('User Role is Here: ' +
                    DocumentSnapshot.data['role'].toString()),
              });
        if(userRole == 'admin') {
          Navigator.pushReplacementNamed(context, HomeScreenAdmin.id);
        }
        else if(userRole == 'user'){
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      //Navigator.pushReplacementNamed(context, HomeScreenAdmin.id);
      print('User Role in Here: ' + userRole + ' id = ' + userId);
    });
  }

  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    userId = uid;
    //final uemail = user.email;
    print('user id in here: ' + uid + '   ' + userId);
    //print(uemail);
  }
}
