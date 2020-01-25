import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final Color color;
  final bool withIcon;

  CustomTextInput({
    this.hintText,
    this.icon,
    this.controller,
    this.isPassword,
    this.color,
    this.withIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: color),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2.0, color: color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2.0, color: color),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          prefixIcon: withIcon
              ? Icon(
                  icon,
                  color: color,
                  size: 22,
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(
            color: color,
          ),
        ),
        cursorColor: color,
        textAlignVertical: TextAlignVertical.center,
        obscureText: isPassword,
      ),
    );
  }
}
