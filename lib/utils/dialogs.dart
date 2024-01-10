import 'package:flutter/material.dart';

class Dialogs {
  Future<void> showErrorDialog(context, String response) async {
    if (response == "400") {
      response = "Email or password wrong";
    }
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    response,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
