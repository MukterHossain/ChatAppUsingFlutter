import 'package:chatappuf/helper/helperFuctions.dart';
import 'package:chatappuf/services/auth.dart';
import 'package:chatappuf/views/chatroomscreen.dart';
import 'package:chatappuf/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailTextedController = new TextEditingController();
  TextEditingController passwordTextedController = new TextEditingController();

  logMeUp() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HelperFuctions.saveUserEmailSharedPreference(emailTextedController.text);

      FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: emailTextedController.text)
          .get()
          .then((value) {
        HelperFuctions.saveUserNameSharedPreference(value.docs[0].get("name"));
      });

      authMethods
          .signInWithEmailAndPass(
              emailTextedController.text, passwordTextedController.text)
          .then((value) {
        if (value != null) {
          HelperFuctions.saveUserLoggedSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoomScr()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Enter Valid Email";
                          },
                          controller: emailTextedController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Email"),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val!.length < 6 ? "Enter 6+ Char" : null;
                          },
                          controller: passwordTextedController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Password"),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot Passsword",
                              style: simpleTextStyle(),
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            logMeUp();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC)
                                  ],
                                )),
                            child: Text(
                              "Sign In",
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Text(
                            "Sign In With Google",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have Account?",
                              style: simpleTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
