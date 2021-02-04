import 'dart:io';

class LoggerInfo {
  String loggerName;
  String loggerMobNo;
  String loggerStationCode;
  String loggerDob;
  String loggerType;
  File loggerImg;
  String loggerAddedBy;
  bool onDuty;
  String imgUrl;

  LoggerInfo(
      {this.loggerName,
      this.loggerMobNo,
      this.loggerStationCode,
      this.loggerDob,
      this.loggerType,
      this.loggerImg,
      this.loggerAddedBy,
      this.onDuty,
      this.imgUrl});
}
