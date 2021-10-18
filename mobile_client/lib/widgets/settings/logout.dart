import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_client/utils/auth.dart';
import 'package:mobile_client/widgets/shared/dialog.dart';

class LogoutSetting extends StatelessWidget {
  confirmDialog(context) {}

  @override
  Widget build(BuildContext context) {
    return (OutlinedButton(
      child: Text("Log Out"),
      onPressed: () => showDialog(
          context: context,
          builder: dialogBuilder(
              "Confirm log out", "Are you sure you want to log out?", {
            "No": () => Navigator.of(context).pop(),
            "Yes": () => GetIt.I<Auth>().logout()
          })),
    ));
  }
}
