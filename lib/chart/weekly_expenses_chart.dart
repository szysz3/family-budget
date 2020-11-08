import 'package:family_budget/data/data_access.dart';
import 'package:family_budget/data/model/expenses_weekly.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'base_chart_state.dart';

class WeeklyExpensesChart extends StatefulWidget {
  State<StatefulWidget> createState() =>
      WeeklyExpensesChartState(DataAccess().getWeeklyExpenses, DateTime.now());
}

class WeeklyExpensesChartState
    extends BaseChartState<WeeklyExpensesChart, List<ExpensesWeekly>> {
  WeeklyExpensesChartState(Function getData, DateTime dateTime)
      : super(getData, dateTime);

  @override
  Widget getChart(List<ExpensesWeekly> data) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child:
          BarChart(getBarChartData(data), swapAnimationDuration: animDuration),
    ));
  }

  @override
  List<BarChartGroupData> getGroups(List<ExpensesWeekly> data) {
    var barChartGroupData = List<BarChartGroupData>();

    data.forEach((element) => {
          barChartGroupData.add(
              makeGroupData(element.maxValue, element.position, element.value))
        });

    return barChartGroupData;
  }

  @override
  Color getTitleColor() {
    return Theme.of(context).colorScheme.onSurface;
  }

  @override
  String getTitleItem(List<ExpensesWeekly> data, double value) {
    switch (value.toInt()) {
      case 0:
        return 'M';
      case 1:
        return 'T';
      case 2:
        return 'W';
      case 3:
        return 'T';
      case 4:
        return 'F';
      case 5:
        return 'S';
      case 6:
        return 'S';
      default:
        return '';
    }
  }

  @override
  Color getTooltipBcgColor() {
    return Theme.of(context).colorScheme.secondaryVariant;
  }

  @override
  BarTooltipItem getTooltipItem(
      List<ExpensesWeekly> data, BarChartGroupData group, BarChartRodData rod) {
    String weekDay;
    switch (group.x.toInt()) {
      case 0:
        weekDay = 'Monday';
        break;
      case 1:
        weekDay = 'Tuesday';
        break;
      case 2:
        weekDay = 'Wednesday';
        break;
      case 3:
        weekDay = 'Thursday';
        break;
      case 4:
        weekDay = 'Friday';
        break;
      case 5:
        weekDay = 'Saturday';
        break;
      case 6:
        weekDay = 'Sunday';
        break;
    }
    return BarTooltipItem(weekDay + '\n' + "${rod.y.toString()} PLN",
        TextStyle(color: Theme.of(context).colorScheme.onSurface));
  }
}
