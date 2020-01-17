import 'package:family_budget/data/model/settings_categories.dart';

import 'expense_categories.dart';

class SettingsModel {
  final double income;
  final double loans;
  final double subscriptions;
  final double rent;
  final double transport;
  final double food;
  final double party;
  final double bills;
  final double house;
  final double other;

  Map<String, double> _expensesByCategory;

  SettingsModel._(
      this.income,
      this.loans,
      this.subscriptions,
      this.rent,
      this.transport,
      this.food,
      this.party,
      this.bills,
      this.house,
      this.other) {
    _expensesByCategory = {
      ExpenseCategories.transport: transport,
      ExpenseCategories.food: food,
      ExpenseCategories.party: party,
      ExpenseCategories.bills: bills,
      ExpenseCategories.house: house,
      ExpenseCategories.other: other
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> rawData) {
    return SettingsModel._(
        double.parse(rawData[SettingsCategories.income].toString()),
        double.parse(rawData[SettingsCategories.loans].toString()),
        double.parse(rawData[SettingsCategories.subscriptions].toString()),
        double.parse(rawData[SettingsCategories.rent].toString()),
        double.parse(rawData[ExpenseCategories.transport].toString()),
        double.parse(rawData[ExpenseCategories.food].toString()),
        double.parse(rawData[ExpenseCategories.party].toString()),
        double.parse(rawData[ExpenseCategories.bills].toString()),
        double.parse(rawData[ExpenseCategories.house].toString()),
        double.parse(rawData[ExpenseCategories.other].toString()));
  }

  getBudgetForCategory(String category) {
    return _expensesByCategory[category];
  }

  double getBudget() {
    return transport + food + party + bills + house + other;
  }

  Map<String, double> toMap() {
    return {
      SettingsCategories.income: income,
      SettingsCategories.loans: loans,
      SettingsCategories.subscriptions: subscriptions,
      SettingsCategories.rent: rent,
      ExpenseCategories.transport: transport,
      ExpenseCategories.food: food,
      ExpenseCategories.party: party,
      ExpenseCategories.bills: bills,
      ExpenseCategories.house: house,
      ExpenseCategories.other: other
    };
  }
}
