import 'package:flutter/material.dart';

class AppPasswordInput extends StatefulWidget {
  final String placeholder;
  final Function(String) updatePassword;
  AppPasswordInput({required this.placeholder, required this.updatePassword});

  @override
  State<StatefulWidget> createState() {
    return _PasswordInputState();
  }
}

class _PasswordInputState extends State<AppPasswordInput> {
  togglePasswordVisiblity() {
    setState(() {
      _passwordInvisible = _passwordInvisible ? false : true;
    });
  }

  bool _passwordInvisible = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: widget.placeholder,
          suffixIcon: IconButton(
            icon: Icon(
                _passwordInvisible ? Icons.visibility_off : Icons.visibility),
            onPressed: togglePasswordVisiblity,
          )),
      onChanged: widget.updatePassword,
      obscureText: _passwordInvisible,
      enableSuggestions: false,
      autocorrect: false,
    );
  }
}
