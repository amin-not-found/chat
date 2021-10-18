import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_client/utils/get_it.dart';
import 'package:mobile_client/utils/api_client.dart';
import 'package:mobile_client/widgets/forms/password_input.dart';
import 'package:mobile_client/widgets/shared/dialog.dart';
import '../widgets/forms/input.dart';
import '../widgets/forms/submit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginForm extends StatefulWidget {
  LoginForm();

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<LoginForm> {
  var formData = new Map<String, String>();

  updateForm(String fieldName) {
    return (String fieldData) => setState(() {
          formData[fieldName] = fieldData;
        });
  }

  // TODO : fill the gap from when the user presses the submit button to when we get results from server
  // also for the sign up form
  // TODO : Make it so that you will go to next field with presseing enter for login and signup form
  submitForm() async {
    for (var k in ["username", "password"]) {
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

    var uri = Uri.parse(GetIt.I<ApiClient>().loginUrl());
    // TODO : move to auth file

    var actionsMap = Map<String, Function()>();
    // default for "Ok" action button in dialog
    actionsMap["Ok"] = () => Navigator.of(context).pop();
    var dialogTitle = "";
    var dialogDesc = "";
    var connStatus = ApiClient.canConnect();

    if (connStatus.connected) {
      var resp = await ApiClient.call(uri, formData);
      var data = jsonDecode(resp.body);

      if (resp.statusCode < 300) {
        var storage = GetIt.I<FlutterSecureStorage>();
        storage.write(key: "refresh_token", value: data["RefreshToken"]);
        storage.write(key: "username", value: formData["username"]);
        actionsMap["Ok"] = () async => Navigator.pushNamedAndRemoveUntil(
            context, await initialize(context), (route) => false);
        dialogTitle = "Logged in successfuly";
        dialogDesc = "Now you can chat with your friends";
      } else {
        dialogTitle = data["Title"];
        dialogDesc = data["Description"];
      }
    } else {
      dialogTitle = "Couldn't connect to server";
      dialogDesc = connStatus.err;
    }
    showDialog(
        context: context,
        builder: dialogBuilder(dialogTitle, dialogDesc, actionsMap));
  }

  goToSignUp() {
    Navigator.pushNamedAndRemoveUntil(context, "/signup", (route) => false);
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
                  "Login\n",
                  style: TextStyle(fontSize: 42),
                ),
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
                  onPressed: goToSignUp,
                  child: Text("Don't have an account? Press to sign up"),
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
