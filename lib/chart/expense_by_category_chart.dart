import 'package:family_budget/data/data_access.dart';
import 'package:family_budget/data/model/expense_by_category_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'base_chart_state.dart';

class ExpenseByCategoryChart extends StatefulWidget {
  State<StatefulWidget> createState() => ExpenseByCategoryChartState(
      DataAccess().getExpensesByCategory, DateTime.now());
}

class ExpenseByCategoryChartState extends BaseChartState<ExpenseByCategoryChart,
    Map<String, ExpenseByCategoryModel>> {
  final Color barBackgroundColor = const Color(0xFFCFD8DC);

  ExpenseByCategoryChartState(Function getData, DateTime dateTime)
      : super(getData, dateTime);

  @override
  Widget getChart(Map<String, ExpenseByCategoryModel> data) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child:
          BarChart(getBarChartData(data), swapAnimationDuration: animDuration),
    ));
  }

  @override
  List<BarChartGroupData> getGroups(Map<String, ExpenseByCategoryModel> data) {
    var barChartGroupData = List<BarChartGroupData>();

    var keys = data.keys.toList();
    var values = data.values.toList();

    for (var i = 0; i < keys.length; i++) {
      barChartGroupData.add(makeGroupData(
          100, i, values[i].expensesInPercents.roundToDouble(),
          limitToMax: true));
    }

    return barChartGroupData;
  }

  @override
  Color getTitleColor() {
    return Theme.of(context).colorScheme.onSurface;
  }

  @override
  String getTitleItem(Map<String, ExpenseByCategoryModel> data, double value) {
    var keys = data.keys.toList();
    return keys[value.toInt()].substring(0, 1).toUpperCase();
  }

  @override
  Color getTooltipBcgColor() {
    return Theme.of(context).colorScheme.secondaryVariant;
  }

  @override
  BarTooltipItem getTooltipItem(Map<String, ExpenseByCategoryModel> data,
      BarChartGroupData group, BarChartRodData rod) {
    var keys = data.keys.toList();
    String weekDay = keys[group.x.toInt()];
    return BarTooltipItem(weekDay + '\n' + "${rod.y.round()} %",
        TextStyle(color: Theme.of(context).colorScheme.onSurface));
  }
}
