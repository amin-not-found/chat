import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class ThemeSetting extends StatefulWidget {
  final Map<String?, String> themeNames = {
    null: "System Prefrence",
    "light": "Light Theme",
    "dark": "Dark Theme",
  };
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ThemeSettingState();
  }
}

class _ThemeSettingState extends State<ThemeSetting> {
  String themeIndicator = "";
  getTheme() async {
    var theme = await GetIt.I<FlutterSecureStorage>().read(key: "theme");
    setState(() {
      themeIndicator =
          " ( Current: " + widget.themeNames[theme].toString() + ")";
    });
  }

  changeTheme(String? newTheme) async {
    await GetIt.I<FlutterSecureStorage>().write(key: "theme", value: newTheme);
    // TODO : change theme on the fly. I guess I'm gonna need a state management lib for that
  }

  Widget themePickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Choose a theme option"),
      children: widget.themeNames.entries
          .map((e) => SimpleDialogOption(
                child: Text(
                  e.value,
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  changeTheme(e.key);
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.fromLTRB(32, 16, 22, 16),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    return OutlinedButton(
      child: Text("Theme" + themeIndicator),
      onPressed: () => showDialog(context: context, builder: themePickerDialog),
    );
  }
}
