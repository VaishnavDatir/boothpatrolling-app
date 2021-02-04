import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';

class FeedbackScreen extends StatelessWidget {
  static const routeName = '/AboutScreen';
  final _feedbackFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: ColorConstant.deepBlue),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          width: double.infinity,
          child: ScrollConfiguration(
            behavior: NoGlowScroll(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Form(
                key: _feedbackFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/logo2Black.png",
                      height: 150,
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        "Feedback",
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: ColorConstant.deepBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Subject',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Message',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
