import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../helpers/theme_helper.dart';

import '../../widgets/userImag_widget.dart';

import './officer_detail_screen.dart';

class ListAllOfficersScreen extends StatelessWidget {
  static const routeName = '/ListAllOfficersScreen';
  final Map<String, dynamic> currentUserInfo;
  ListAllOfficersScreen({this.currentUserInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "List of officers",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("officers")
            .orderBy("name")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              List streamData = snapshot.data.docs;
              if (streamData.isEmpty) {
                return Center(
                  child: Text(
                    "There are no officers in your list",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.deepBlue,
                          fontSize: 18,
                        ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: streamData.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: (streamData[index]["type"] == "officer")
                        ? (streamData[index]["stationCode"] ==
                                    currentUserInfo["stationCode"] ||
                                streamData[index]["addedBy"] ==
                                    currentUserInfo["uid"])
                            ? ListTile(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return OfficerDetailScreen(
                                      officerUid: streamData[index]["uid"],
                                    );
                                  }));
                                },
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: streamData[index]["onDuty"]
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Hero(
                                      tag: streamData[index]["uid"],
                                      child: UserImgWidget(
                                        imgUrl: streamData[index]
                                                ["officerImgURL"]
                                            .toString(),
                                        size: 55,
                                      ),
                                    )
                                  ],
                                ),
                                title: Text(
                                  streamData[index]["name"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstant.deepBlue,
                                        fontSize: 16,
                                      ),
                                ),
                                subtitle: Text(
                                  streamData[index]["mobileno"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        color: ColorConstant.deepBlue,
                                        fontSize: 16,
                                      ),
                                ),
                              )
                            : null
                        : null,
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "No data found",
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.deepBlue,
                        fontSize: 18,
                      ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
