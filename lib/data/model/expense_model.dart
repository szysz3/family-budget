import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final double amount;
  final String category;
  final DateTime date;
  final String desc;

  ExpenseModel(this.amount, this.category, this.date, this.desc);

  factory ExpenseModel.fromMap(Map<String, dynamic> rawData) {
    return ExpenseModel(
        double.parse(rawData["amount"].toString()),
        rawData["category"].toString(),
        DateTime.fromMillisecondsSinceEpoch(
            (rawData["date"] as Timestamp).millisecondsSinceEpoch),
        rawData["description"]);
  }
}
