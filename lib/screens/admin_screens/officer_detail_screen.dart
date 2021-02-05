import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../helpers/url_launcher.dart';
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
                var latitude = (streamData["location"]["latitude"]);
                var longitude = streamData["location"]["longitude"];
                final userLocation =
                    LatLng(latitude.toDouble(), longitude.toDouble());
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: streamData["onDuty"]
                            ? Container(
                                color: Colors.white,
                                child: Text("Showing current locaiton"),
                              )
                            : Container(
                                color: Colors.white,
                                child: Text(
                                    "The officer is not on duty\nShowing last known location"),
                              ),
                      ),
                    ),
                    FlutterMap(
                      options: MapOptions(
                        center: userLocation,
                        zoom: 13,
                      ),
                      nonRotatedLayers: [
                        TileLayerOptions(
                          urlTemplate:
                              "https://api.tomtom.com/map/1/tile/basic/main/"
                              "{z}/{x}/{y}.png?key={apiKey}",
                          additionalOptions: {'apiKey': MyKeys.apiKey},
                        ),
                        MarkerLayerOptions(markers: [
                          Marker(
                              width: 80.0,
                              height: 80.0,
                              point: userLocation,
                              builder: (context) => Container(
                                    child: Column(
                                      children: [
                                        UserImgWidget(
                                          imgUrl: streamData["officerImgURL"],
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
                                  )),
                        ]),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Card(
                        elevation: 2,
                        child: streamData["onDuty"]
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 15),
                                color: Colors.white,
                                child: Text(
                                  "Showing current locaiton",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstant.deepBlue,
                                        fontSize: 14,
                                      ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 15),
                                color: Colors.white,
                                child: Text(
                                  "The officer is not on duty\nShowing last known location",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstant.deepBlue,
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                      ),
                    ),
                    OfficerInfoottom(streamData: streamData)
                  ],
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
            }));
  }
}

class OfficerInfoottom extends StatelessWidget {
  final streamData;
  OfficerInfoottom({
    @required this.streamData,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        padding: EdgeInsets.symmetric(vertical: 7),
        width: double.infinity,
        color: ColorConstant.deepBlue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: UserImgWidget(
                imgUrl: streamData["officerImgURL"].toString(),
                size: 55,
              ),
              title: Text(
                streamData["name"],
                style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                streamData["mobileno"],
                style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 28,
                  ),
                  tooltip: "Call",
                  onPressed: () {
                    UrlLauncher().callOfficer(streamData["mobileno"]);
                  }),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Station code",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    streamData["stationCode"],
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
