import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../widgets/add_drawer.dart';
import '../../widgets/userImag_widget.dart';

import '../../helpers/background_location.dart';

import '../../helpers/theme_helper.dart';

class OfficerMainScreen extends StatefulWidget {
  static const routeName = '/OfficerMainScreen';
  final Map<String, dynamic> userInfo;
  OfficerMainScreen({this.userInfo});

  @override
  _OfficerMainScreenState createState() => _OfficerMainScreenState();
}

class _OfficerMainScreenState extends State<OfficerMainScreen> {
  startServiceInPlatform() async {
    bool res = await LocationService.instance().getLocation();
    if (!res) {
      return false;
    }
    var methodChannel = MethodChannel("com.androidv.BoothPatrolling/Start");
    var calbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
    methodChannel.invokeMethod("startService", calbackHandle.toRawHandle());
    return true;
  }

  stopServiceInPlatform() {
    var methodChannel = MethodChannel("com.androidv.BoothPatrolling/Stop");
    // methodChannel.invokeMethod("stopService", -1.0.toDouble());
    methodChannel.invokeMethod("stopService");
    LocationService.instance().stop();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   UserManagement().onDutyDefault();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        userInfo: widget.userInfo,
      ),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Officer Screen",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white, fontSize: 21),
        ),
      ),
      body: Stack(
        children: [
          widget.userInfo["onDuty"]
              ? Container(
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("officers")
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        try {
                          final streamData = snapshot.data;

                          var latitude = (streamData["location"]["latitude"]);
                          var longitude = streamData["location"]["longitude"];

                          final userLocation =
                              LatLng(latitude.toDouble(), longitude.toDouble());
                          return FlutterMap(
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
                                                imgUrl:
                                                    streamData["officerImgURL"],
                                                size: 55,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    color:
                                                        ColorConstant.deepBlue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                              )
                                            ],
                                          ),
                                        )),
                              ]),
                            ],
                          );
                        } catch (e) {
                          return GettingLocationWidget();
                        }
                      } else {
                        return GettingLocationWidget();
                      }
                    },
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 48,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text("Currently your off duty",
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: 19,
                                color: Colors.black,
                              )),
                    ),
                  ],
                ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
            elevation: 9,
            child: SwitchListTile(
              value: widget.userInfo["onDuty"],
              onChanged: (value) async {
                if (value) {
                  bool res = await startServiceInPlatform();
                  if (!res) {
                    return;
                  }
                } else {
                  await stopServiceInPlatform();
                }
                await FirebaseFirestore.instance
                    .collection("officers")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .update({"onDuty": value});
              },
              title: Text(
                "Duty",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GettingLocationWidget extends StatelessWidget {
  const GettingLocationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 48,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text("Getting current location",
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        fontSize: 19,
                        color: Colors.black,
                      )),
            ),
          ],
        ));
  }
}
