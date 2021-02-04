import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../helpers/theme_helper.dart';

import '../../widgets/userImag_widget.dart';

class OfficerDetailScreen extends StatefulWidget {
  static const routeName = '/OfficerDetailScreen';
  final String officerUid;
  OfficerDetailScreen({this.officerUid});

  @override
  _OfficerDetailScreenState createState() => _OfficerDetailScreenState();
}

class _OfficerDetailScreenState extends State<OfficerDetailScreen> {
  bool showFull = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            "About officer",
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: Colors.white, fontSize: 20),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("officers")
                .doc(widget.officerUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final streamData = snapshot.data;
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        print("1");
                      },
                      child: Container(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                        padding: EdgeInsets.symmetric(vertical: 7),
                        width: double.infinity,
                        color: ColorConstant.deepBlue,
                        child: ListTile(
                          leading: UserImgWidget(
                            imgUrl: streamData["officerImgURL"].toString(),
                            size: 55,
                          ),
                          title: Text(
                            streamData["name"],
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            streamData["mobileno"],
                            style:
                                Theme.of(context).textTheme.headline2.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Text("Getting Data");
              }
            }));
  }
}
