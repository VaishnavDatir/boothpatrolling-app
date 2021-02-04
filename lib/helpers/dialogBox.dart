import 'package:flutter/material.dart';
import './theme_helper.dart';

dialogBox(BuildContext context, String title, String msg, IconData icon) {
  msg = msg.toString().replaceAll("email address", "Mobile Number");

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: ColorConstant.deepBlue,
          ),
          SizedBox(
            width: 10,
          ),
          Text(title),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          child: Text(msg),
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Ok",
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 16),
            ))
      ],
    ),
  );
}
