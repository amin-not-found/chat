import 'package:flutter/material.dart';

class Submit extends StatelessWidget {
  final Function() submit;

  Submit({required this.submit});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: ElevatedButton(onPressed: submit, child: Text("Sumbit")));
  }
}
