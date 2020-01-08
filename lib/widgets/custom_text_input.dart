import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;

  CustomTextInput({
    this.hintText,
    this.icon,
    this.controller,
    this.isPassword
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2.0, color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2.0, color: Colors.white),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        cursorColor: Colors.white,
        textAlignVertical: TextAlignVertical.center,
        obscureText: isPassword,
      ),
    );
  }
}
