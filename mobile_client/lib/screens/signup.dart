import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_client/utils/api_client.dart';
import 'package:mobile_client/widgets/forms/password_input.dart';
import 'package:mobile_client/widgets/shared/dialog.dart';
import '../widgets/forms/input.dart';
import '../widgets/forms/submit.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm();

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpForm> {
  var formData = new Map<String, String>();

  updateForm(String fieldName) {
    return (String fieldData) => setState(() {
          formData[fieldName] = fieldData;
        });
  }

  submitForm() async {
    for (var k in ["name", "username", "password"]) {
      if (!formData.containsKey(k) || formData[k]!.isEmpty) {
        showDialog(
            context: context,
            builder: dialogBuilder(
                "Invalid input",
                'Field "$k" can\'t be empty',
                {"Ok": () => Navigator.of(context).pop()}));
        return;
      }
    }

    var uri = Uri.parse(GetIt.I<ApiClient>().signupUrl());
    // TODO  (Maybe) : Move some of logic about api to another file
    var connStatus = ApiClient.canConnect();
    // default for "Ok" action button
    Map<String, Function()> actionsMap = {
      "Ok": () => Navigator.of(context).pop()
    };
    String dialogTitle = "";
    String dialogDesc = "";

    if (connStatus.connected) {
      var resp = await ApiClient.call(uri, formData);

      var data = jsonDecode(resp.body);
      if (resp.statusCode < 300) {
        actionsMap["Ok"] = () => Navigator.pushNamedAndRemoveUntil(
            context, "/login", (route) => false);
      }
      dialogTitle = data["Title"];
      dialogDesc = data["Description"];
    } else {
      dialogTitle = "Couldn't connect to server";
      dialogDesc = connStatus.err;
    }

    showDialog(
        context: context,
        builder: dialogBuilder(dialogTitle, dialogDesc, actionsMap));
  }

  goToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up\n",
                  style: TextStyle(fontSize: 42),
                ),
                AppInput(
                  controller: null,
                  placeholder: "Name",
                  // remember: updateForm is a closure
                  updateInput: updateForm("name"),
                ),
                SizedBox(height: 10),
                AppInput(
                  controller: null,
                  placeholder: "Username",
                  // remember: updateForm is a closure
                  updateInput: updateForm("username"),
                ),
                SizedBox(height: 10),
                AppPasswordInput(
                  placeholder: "Password",
                  // remember: updateForm is a closure
                  updatePassword: updateForm("password"),
                ),
                SizedBox(height: 32),
                Submit(submit: submitForm),
                SizedBox(height: 16),
                TextButton(
                  onPressed: goToLogin,
                  child: Text("Alreay have an account? Press to login"),
                  style: TextButton.styleFrom(
                    // TODO : remove splash
                    splashFactory: InkSplash.splashFactory,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
