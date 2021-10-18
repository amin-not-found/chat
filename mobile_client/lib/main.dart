import 'package:flutter/material.dart';
import 'package:mobile_client/screens/conversations.dart';
import 'package:mobile_client/screens/encryption_form.dart';
import 'package:mobile_client/screens/login.dart';
import 'package:mobile_client/screens/settings.dart';
import 'package:mobile_client/screens/signup.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_client/utils/get_it.dart';
import 'package:mobile_client/utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: initialize(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return MaterialApp(
            title: 'Chamin',
            navigatorKey: GetIt.I<GlobalKey<NavigatorState>>(),
            theme: GetIt.I<AppTheme>().getData(),
            initialRoute: snapshot.data,
            routes: {
              '/': (context) => Conversations(),
              '/passwd': (context) => EncryptionForm(),
              '/signup': (context) => SignUpForm(),
              '/login': (context) => LoginForm(),
              '/settings': (context) => Settings()
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
