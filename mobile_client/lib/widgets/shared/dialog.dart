import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget Function(BuildContext) dialogBuilder(
    String title, String message, Map<String, Function()> actionsMap) {
  return (BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actionsMap.keys
          .map(
              (key) => TextButton(onPressed: actionsMap[key], child: Text(key)))
          .toList(),
    );
  };
}
