import 'package:cloud_firestore/cloud_firestore.dart';
import "package:collection/collection.dart";
import 'package:family_budget/data/model/expenses_to_days_model.dart';
import 'package:family_budget/data/model/expenses_weekly.dart';
import 'package:family_budget/data/model/settings_model.dart';
import 'package:family_budget/util/date_utils.dart';

import 'model/expense_by_category_model.dart';
import 'model/expense_categories.dart';
import 'model/expense_model.dart';

class DataAccess {
  static final DataAccess _singleton = DataAccess._();
  final _databaseReference = Firestore.instance;

  factory DataAccess() {
    return _singleton;
  }

  DataAccess._();

  Future<DocumentReference> addExpense(
      double amount, String category, String description) {
    return _databaseReference.collection("expenses").add({
      "category": category,
      "description": description,
      "amount": amount,
      "date": Timestamp.fromDate(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day))
    });
  }

  Future<SettingsModel> getSettings() async {
    var snapshot =
        await _databaseReference.collection("settings").getDocuments();
    return SettingsModel.fromMap(snapshot.documents.first.data);
  }

  saveOrUpdateSettings(SettingsModel settingsItem) async {
    await _databaseReference
        .collection("settings")
        .document("main")
        .updateData(settingsItem.toMap());
  }

  Future<Map<String, ExpenseByCategoryModel>> getExpensesByCategory(
      DateTime dateTime) async {
    var dateTimeNow = DateTime.now();
    var snapshot = await _getExpensesWithinRange(
        DateUtils.getStartingDateForGivenMonth(dateTimeNow),
        DateUtils.getEndingDateForGivenMonth(dateTimeNow));

    var settingsItem = await getSettings();
    Map<String, ExpenseByCategoryModel> expensesByCategories =
        groupBy(snapshot.documents, (item) => item['category'])
            .map((category, itemList) {
      var mappedItemList = itemList.map((rawItem) {
        return ExpenseModel.fromMap(rawItem.data);
      });
      var sumOfExpensesForCategory =
          mappedItemList.fold(0, (sum, item) => sum + item.amount);
      var expenseByCategory = ExpenseByCategoryModel(
          category,
          (sumOfExpensesForCategory /
                  settingsItem.getBudgetForCategory(category)) *
              100);
      return MapEntry(category, expenseByCategory);
    });
    ExpenseCategories.getCategoryList().forEach((category) {
      return expensesByCategories.putIfAbsent(
          category, () => ExpenseByCategoryModel(category, 0));
    });

    return expensesByCategories;
  }

  Future<ExpensesToDaysModel> getElapsedDaysToExpensesProportions(
      DateTime dateTime) async {
    var settingsItem = await getSettings();
    var budget = settingsItem.getBudget();

    var dateTimeNow = DateTime.now();
    var endingDate = DateUtils.getEndingDateForGivenMonth(dateTimeNow);

    var snapshot = await _getExpensesWithinRange(
        DateUtils.getStartingDateForGivenMonth(dateTimeNow), endingDate);

    var expenseSum = snapshot.documents.map((element) {
      return ExpenseModel.fromMap(element.data);
    }).fold(0.0, (amountSum, item) => amountSum + item.amount);

    var expensesRatio = (expenseSum / budget) * 100;
    var elapsedDaysRatio = (dateTimeNow.day / endingDate.day) * 100;

    return ExpensesToDaysModel(expensesRatio, elapsedDaysRatio);
  }

  Future<MapEntry<double, double>> getTotalExpenses(DateTime dateTime) async {
    var settingsItem = await getSettings();
    var budget = settingsItem.getBudget();

    var dateTimeNow = DateTime.now();
    var snapshot = await _getExpensesWithinRange(
        DateUtils.getStartingDateForGivenMonth(dateTimeNow),
        DateUtils.getEndingDateForGivenMonth(dateTimeNow));

    var expenseSum = snapshot.documents.map((element) {
      return ExpenseModel.fromMap(element.data);
    }).fold(0.0, (amountSum, item) => amountSum + item.amount);

    return MapEntry(expenseSum, budget - expenseSum);
  }

  Future<List<ExpensesWeekly>> getWeeklyExpenses(DateTime date) async {
    var settingsItem = await getSettings();
    var avgExpenses = (settingsItem.income -
            settingsItem.loans -
            settingsItem.subscriptions -
            settingsItem.rent -
            settingsItem.transport) /
        31;

    var startingDate = DateUtils.getStartingDateForGivenWeek();
    var snapshot = await _getExpensesWithinRange(
        startingDate, DateUtils.getEndingDateForGivenWeek());

    var expenseItems = snapshot.documents
        .map((element) {
          return ExpenseModel.fromMap(element.data);
        })
        .where((expenseItem) =>
            expenseItem.category != ExpenseCategories.transport &&
            expenseItem.category != ExpenseCategories.bills)
        .toList();

    var expenseItemsData = Map<DateTime, List<ExpenseModel>>();
    var barChartData = List<ExpensesWeekly>();
    for (var i = 0; i <= 6; i++) {
      var date = startingDate.add(Duration(days: i));
      expenseItemsData.putIfAbsent(date, () => List<ExpenseModel>());
      expenseItems.forEach((element) => {
            if (element.date == date) {expenseItemsData[date].add(element)}
          });

      barChartData.add(ExpensesWeekly(
          date.toString(),
          avgExpenses,
          expenseItemsData[date]
              .fold(0.0, (amountSum, item) => amountSum + item.amount),
          i));
    }

    return barChartData;
  }

  Future<QuerySnapshot> _getExpensesWithinRange(
      DateTime startDate, DateTime endDate) async {
    return await _databaseReference
        .collection("expenses")
        .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .getDocuments();
  }
}
