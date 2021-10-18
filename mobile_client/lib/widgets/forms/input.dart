import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String placeholder;
  final Function(String) updateInput;
  final TextEditingController? controller;
  AppInput(
      {required this.controller,
      required this.placeholder,
      required this.updateInput});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(hintText: placeholder),
      controller: controller,
      onChanged: updateInput,
    );
  }
}
