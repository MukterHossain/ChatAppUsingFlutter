import 'package:flutter/material.dart';

PreferredSize appBarMain(BuildContext context) {
  return PreferredSize(
      child: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
      ),
      preferredSize: Size.fromHeight(55));
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white,fontSize: 16);
}
