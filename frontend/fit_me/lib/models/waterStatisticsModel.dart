import 'package:cloud_firestore/cloud_firestore.dart';

class WaterStatisticsModel {
  String? uid;
  Timestamp? timestamp;
  int? waterAmount;

  WaterStatisticsModel(
    {
      this.uid,
      this.timestamp,
      this.waterAmount
    }
  );

  WaterStatisticsModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    timestamp = json['date'];
    waterAmount = json['waterAmount'];
  }

}