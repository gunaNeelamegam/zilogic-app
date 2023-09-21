import 'package:flutter/material.dart';
import 'package:zilogic/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  const AuthField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.orangeColor,
            width: 3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
          ),
        ),
        contentPadding: const EdgeInsets.all(22),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
      obscureText: isPassword,
    );
  }
}
