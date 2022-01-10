import 'package:chatappuf/helper/helperFuctions.dart';
import 'package:chatappuf/services/auth.dart';
import 'package:chatappuf/services/database.dart';
import 'package:chatappuf/views/chatroomscreen.dart';
import 'package:chatappuf/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();
  TextEditingController usernameTextEdCotroller = new TextEditingController();
  TextEditingController emailTextEdCotroller = new TextEditingController();
  TextEditingController passwordTextEdCotroller = new TextEditingController();
  AuthMethods authMethod = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  SignMeUp() {
    if (formkey.currentState!.validate()) {
      Map<String, String> userMap = {
        "name": usernameTextEdCotroller.text,
        "email": emailTextEdCotroller.text,
      };
      HelperFuctions.saveUserNameSharedPreference(usernameTextEdCotroller.text);
      HelperFuctions.saveUserEmailSharedPreference(emailTextEdCotroller.text);

      setState(() {
        isLoading = true;
      });
      authMethod
          .signUPWithEmailAndPassword(
              emailTextEdCotroller.text, passwordTextEdCotroller.text)
          .then((value) {
        databaseMethods.uploadUserInfo(userMap);
        HelperFuctions.saveUserLoggedSharedPreference(true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScr(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return val!.isEmpty || val.length < 4
                                    ? "Enter UserName"
                                    : null;
                              },
                              controller: usernameTextEdCotroller,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("UserName"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Enter Valid Email";
                              },
                              controller: emailTextEdCotroller,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("Email"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return val!.length < 6 ? "Enter 6+ Char" : null;
                              },
                              controller: passwordTextEdCotroller,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("Password"),
                            ),
                          ],
                        ),
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
                          SignMeUp();
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
                            "Sign Up",
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
                          "Sign Up With Google",
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
                            "Already have Account?",
                            style: simpleTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Text(
                              "SignIN Now",
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
    );
  }
}
