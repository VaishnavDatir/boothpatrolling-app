import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';

class UserImgWidget extends StatelessWidget {
  final String imgUrl;
  final double size;
  UserImgWidget({this.imgUrl, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  imgUrl.isEmpty ? DummyPhotos.profilePic : imgUrl),
              fit: BoxFit.cover),
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: ColorConstant.dodgerBlue, width: 2)),
    );
  }
}
