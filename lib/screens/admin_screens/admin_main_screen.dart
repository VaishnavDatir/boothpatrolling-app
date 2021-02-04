import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/theme_helper.dart';

//Widgets
import '../../widgets/add_drawer.dart';
import '../../widgets/userImag_widget.dart';

enum PopUpMenu { addOfficer, listAllOfficers, logout }

class AdminMainScreen extends StatefulWidget {
  static const routeName = '/AdminMainScreen';
  final Map<String, dynamic> userInfo;
  AdminMainScreen({this.userInfo});

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  MapController mapController;
  LatLng center = LatLng(19.1043, 73.0033);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        userInfo: widget.userInfo,
      ),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Booth Patrolling",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white, fontSize: 21),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("officers")
              .where("type", isEqualTo: "officer")
              .where("onDuty", isEqualTo: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                List streamData = snapshot.data.docs;
                if (streamData.isNotEmpty) {
                  List<Marker> markers = List<Marker>();
                  List sheetUsers = streamData;
                  streamData.forEach((user) {
                    markers.add(Marker(
                        width: 80.0,
                        height: 110.0,
                        point: LatLng(user["location"]["latitude"],
                            user["location"]["longitude"]),
                        builder: (context) => GestureDetector(
                              onTap: () {
                                Scaffold.of(context).showBottomSheet(
                                    (context) =>
                                        _userInfoBottomSheet(sheetUsers));
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      user["name"].toString().split(" ")[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(
                                              color: ColorConstant.deepBlue,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.white,
                                              fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    UserImgWidget(
                                      imgUrl: user["officerImgURL"],
                                      size: 55,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.deepBlue,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    )
                                  ],
                                ),
                              ),
                            )));
                  });
                  return FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: center,
                      zoom: 14,
                    ),
                    nonRotatedLayers: [
                      TileLayerOptions(
                        urlTemplate:
                            "https://api.tomtom.com/map/1/tile/basic/main/"
                            "{z}/{x}/{y}.png?key={apiKey}",
                        additionalOptions: {'apiKey': MyKeys.apiKey},
                      ),
                      MarkerLayerOptions(markers: markers)
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      "Currently no officer is on duty",
                      style: Theme.of(context).textTheme.headline2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.deepBlue,
                            fontSize: 18,
                          ),
                    ),
                  );
                }
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
      ),
    );
  }

  Container _userInfoBottomSheet(List user) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.30,
      child: ListView.builder(
        itemCount: user.length,
        itemBuilder: (context, index) {
          int _selectedIndex;

          return Container(
            margin: EdgeInsets.only(bottom: 2),
            child: ListTile(
              selected: index == _selectedIndex,
              selectedTileColor: ColorConstant.deepBlue,
              onTap: () {
                setState(() {
                  center = LatLng(user[index]["location"]["latitude"],
                      user[index]["location"]["longitude"]);
                  _selectedIndex = index;
                });
              },
              leading: UserImgWidget(
                imgUrl: user[index]["officerImgURL"],
                size: 55,
              ),
              title: Text(
                user[index]["name"],
                style: Theme.of(context).textTheme.headline2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
              subtitle: Text(
                user[index]["mobileno"],
                style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.call, color: ColorConstant.deepBlue),
                  onPressed: () async {
                    String url = "tel:${user[index]["mobileno"]}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
            ),
          );
        },
      ),
    );
  }
}
