import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_client/widgets/settings/logout.dart';
import 'package:mobile_client/widgets/settings/theme.dart';
import 'package:mobile_client/widgets/shared/chat_nav.dart';

class Settings extends StatefulWidget {
  Settings();
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  String username = "";

  submitForm() async {
    // TODO: show a dialog if username is empty
    if (username != "") {
      await GetIt.I<FlutterSecureStorage>()
          .write(key: "username", value: username);
    }
  }

  setData() async {
    username = (await GetIt.I<FlutterSecureStorage>().read(key: "username"))
        .toString();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Username: $username",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              //Submit(submit: submitForm)
              ThemeSetting(),
              SizedBox(
                height: 10,
              ),
              LogoutSetting(),
            ],
          ))),
      bottomNavigationBar: ChatNavigation(),
    );
  }
}
