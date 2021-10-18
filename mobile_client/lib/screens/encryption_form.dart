import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_client/utils/get_it.dart';
import 'package:mobile_client/widgets/forms/password_input.dart';
import '../widgets/forms/submit.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptionForm extends StatefulWidget {
  EncryptionForm();

  @override
  State<StatefulWidget> createState() {
    return _EncryptionFormState();
  }
}

class _EncryptionFormState extends State<EncryptionForm> {
  String _password = "";

  updatePassword(String newPassword) {
    setState(() {
      _password = newPassword;
    });
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var res = sha256.convert(bytes);
    return String.fromCharCodes(res.bytes);
  }

  submitForm() async {
    // TODO : Are u sure dialog
    var storage = GetIt.I<FlutterSecureStorage>();
    storage.write(key: "encryption_key", value: hashPassword(_password));
    Navigator.pushNamedAndRemoveUntil(
        context, await initialize(context), (route) => false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var defaultTextColor = Theme.of(context).textTheme.bodyText1!.color;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO : write smth about data being encrypted
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Data Encryption\n\n",
                      style: TextStyle(fontSize: 27, color: defaultTextColor)),
                  TextSpan(
                      text:
                          "We need a password to use for encryption of your messages. Please note that it isn't going to be used for your account but just encryption of local data. So please choose a good password and write it somewhere, specially if you want to backup your messages.\n",
                      style: TextStyle(color: defaultTextColor))
                ])),
                AppPasswordInput(
                  placeholder: "Password",
                  updatePassword: updatePassword,
                ),
                SizedBox(
                  height: 10,
                ),
                Submit(submit: submitForm)
              ],
            ),
          )),
    );
  }
}
