import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/theme_helper.dart';
import '../helpers/dialogBox.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = '/AboutScreen';
  final Map<String, dynamic> userInfo;
  FeedbackScreen({this.userInfo});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool _isLoading = false;

  final _feedbackFormKey = GlobalKey<FormState>();

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final _messageField = FocusNode();

  _formSublit() async {
    FocusScope.of(context).unfocus();
    if (!_feedbackFormKey.currentState.validate()) {
      print("Invalid");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> userFeedBack = {
      "subject": _subjectController.text.toString(),
      "message": _messageController.text.toString(),
      "date": DateTime.now().toString()
    };

    try {
      await FirebaseFirestore.instance.collection("feedback").doc().set({
        "name": widget.userInfo["name"],
        "mobileno": widget.userInfo["mobileno"],
        "type": widget.userInfo["type"],
        "uid": widget.userInfo["uid"],
        "feedback": userFeedBack,
      });
      Fluttertoast.showToast(
        msg: "Thankyou for your feedback",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue[800],
        textColor: Colors.white,
        fontSize: 14,
      );
    } on FirebaseException catch (e) {
      dialogBox(context, "Error", e.toString(), Icons.error);
    } catch (err) {
      print("the error in feedback");
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                      controller: _subjectController,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Subject',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please specify the subject";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_messageField);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _messageController,
                      focusNode: _messageField,
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
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please specify your feedback";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              onPressed: _formSublit,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              color: ColorConstant.deepBlue,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(
                                  "Submit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
