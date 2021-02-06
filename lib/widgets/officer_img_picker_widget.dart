import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../helpers/theme_helper.dart';

class OfficerImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  final String imgUrl;
  OfficerImagePicker(this.imagePickFn, this.imgUrl);

  @override
  _OfficerImagePickerState createState() => _OfficerImagePickerState();
}

class _OfficerImagePickerState extends State<OfficerImagePicker> {
  final picker = ImagePicker();
  File _image;

  _imgFromCamera() async {
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    final image = File(pickedImage.path);
    setState(() {
      if (image != null) {
        _image = image;
        widget.imagePickFn(image);
      }
    });
  }

  _imgFromGallery() async {
    final pickedImage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    final image = File(pickedImage.path);
    setState(() {
      if (image != null) {
        _image = image;
        widget.imagePickFn(image);
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        _showPicker(context);
      },
      child: Stack(
        children: [
          // (widget.imgUrl.isNotEmpty || widget.imgUrl == null)
          //     ? Container(
          //         height: 80,
          //         width: 80,
          //         decoration: BoxDecoration(
          //             image: DecorationImage(
          //                 image: NetworkImage(widget.imgUrl),
          //                 fit: BoxFit.cover),
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(50),
          //             border: Border.all(
          //                 color: ColorConstant.dodgerBlue, width: 2)),
          //         // child: Image.network(userImgUrl),
          //       )
          //     : _image == null
          //         ? Icon(
          //             Icons.person,
          //             size: 60,
          //             color: Colors.grey,
          //           )
          //         : CircleAvatar(
          //             radius: 50,
          //             backgroundColor: Colors.grey,
          //             backgroundImage:
          //                 _image != null ? FileImage(_image, scale: 1) : null,
          //           ),

          _image == null
              ? (widget.imgUrl.isNotEmpty || widget.imgUrl == null)
                  ? Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.imgUrl),
                              fit: BoxFit.cover),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: ColorConstant.dodgerBlue, width: 2)),
                      // child: Image.network(userImgUrl),
                    )
                  : Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    )
              : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      _image != null ? FileImage(_image, scale: 1) : null,
                ),

          Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.add_a_photo)))
        ],
      ),
    );
  }
}
