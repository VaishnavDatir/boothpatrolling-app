import 'package:flutter/material.dart';
import 'dart:io';

import '../helpers/theme_helper.dart';

import '../widgets/officer_img_picker_widget.dart';

import '../model/logger_info.dart';

class OfficerForm extends StatefulWidget {
  final GlobalKey<FormState> officerForm;
  final Map<String, dynamic> userInfos;
  final LoggerInfo editUser;
  final void Function(File pickedImage) imagePickFn;

  OfficerForm(
      this.officerForm, this.userInfos, this.editUser, this.imagePickFn);

  @override
  _OfficerFormState createState() => _OfficerFormState();
}

class _OfficerFormState extends State<OfficerForm> {
  final _editofficerFullName = TextEditingController();

  final _editOfficerMobileNo = TextEditingController();
  final _focusNodeEditMobileNo = FocusNode();

  final _editOfficerStationCode = TextEditingController();
  final _focusEditStationCode = FocusNode();

  final _editOfficerDOB = TextEditingController();
  final _focusEditDOB = FocusNode();

  String imgUrl;

  @override
  void initState() {
    super.initState();
    _editofficerFullName.text =
        widget.userInfos == null ? "" : widget.userInfos["name"] ?? "";
    _editOfficerMobileNo.text =
        widget.userInfos == null ? "" : widget.userInfos["mobileno"] ?? "";
    _editOfficerStationCode.text =
        widget.userInfos == null ? "" : widget.userInfos["stationCode"] ?? "";
    _editOfficerDOB.text =
        widget.userInfos == null ? "" : widget.userInfos["dob"] ?? "";
    imgUrl =
        widget.userInfos == null ? "" : widget.userInfos["officerImgURL"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.officerForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OfficerImagePicker(widget.imagePickFn, imgUrl),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: Text(
              "Personal Information",
              style: Theme.of(context).textTheme.headline1.copyWith(
                  color: ColorConstant.deepBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            controller: _editofficerFullName,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 18),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Full Name',
            ),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(_focusNodeEditMobileNo),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter officer name";
              }
              return null;
            },
            onSaved: (newValue) =>
                widget.editUser.loggerName = newValue.toString(),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _editOfficerMobileNo,
            focusNode: _focusNodeEditMobileNo,
            keyboardType: TextInputType.phone,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 18),
            maxLength: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mobile Number',
            ),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(_focusEditStationCode),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter officer mobile number";
              } else if (value.length != 10) {
                return "Please enter correct mobile number";
              }
              return null;
            },
            onSaved: (newValue) =>
                widget.editUser.loggerMobNo = newValue.toString(),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _editOfficerStationCode,
            focusNode: _focusEditStationCode,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 18),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Station code',
            ),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(_focusEditDOB),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter station code";
              }
              return null;
            },
            onSaved: (newValue) =>
                widget.editUser.loggerStationCode = newValue.toString(),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _editOfficerDOB,
            focusNode: _focusEditDOB,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.words,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 18),
            onTap: () async {
              DateTime _selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              _editOfficerDOB.text =
                  _selectedDate.toLocal().toString().split(' ')[0];
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date of Birth',
                hintText: "YYYY-MM-DD",
                suffixIcon: Icon(Icons.calendar_today)),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter date of birth";
              }
              return null;
            },
            onSaved: (newValue) =>
                widget.editUser.loggerDob = newValue.toString(),
          ),
        ],
      ),
    );
  }
}
