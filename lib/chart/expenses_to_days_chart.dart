import 'package:family_budget/data/data_access.dart';
import 'package:family_budget/data/model/expenses_to_days_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'base_chart_state.dart';

class ExpensesToDaysChart extends StatefulWidget {
  State<StatefulWidget> createState() => ExpensesToDaysChartState(
      DataAccess().getElapsedDaysToExpensesProportions, DateTime.now());
}

class ExpensesToDaysChartState
    extends BaseChartState<ExpensesToDaysChart, ExpensesToDaysModel> {
  final Color barBackgroundColor = const Color(0xFFC5CAE9);

  ExpensesToDaysChartState(Function getData, DateTime dateTime)
      : super(getData, dateTime);

  @override
  Widget getChart(ExpensesToDaysModel data) {
    return Expanded(
      child: Container(
        width: 100,
        child: BarChart(getBarChartData(data),
            swapAnimationDuration: animDuration),
      ),
    );
  }

  @override
  List<BarChartGroupData> getGroups(ExpensesToDaysModel data) {
    var barChartGroupData = List<BarChartGroupData>();
    var chartData = [data.expensesRatio, data.elapsedDaysRatio];

    for (var i = 0; i < chartData.length; i++) {
      barChartGroupData.add(makeGroupData(
          100, i, chartData[i].round().toDouble(),
          limitToMax: true, width: 32, barColor: Color(0xFF7986CB)));
    }

    return barChartGroupData;
  }

  @override
  Color getTitleColor() {
    return Colors.indigo[600];
  }

  @override
  String getTitleItem(ExpensesToDaysModel data, double value) {
    switch (value.toInt()) {
      case 0:
        return 'E';
      case 1:
        return 'D';
      default:
        return '';
    }
  }

  @override
  Color getTooltipBcgColor() {
    return Colors.indigo;
  }

  @override
  BarTooltipItem getTooltipItem(
      ExpensesToDaysModel data, BarChartGroupData group, BarChartRodData rod) {
    String weekDay;
    switch (group.x.toInt()) {
      case 0:
        weekDay = 'expenses';
        break;
      case 1:
        weekDay = 'days';
    }
    return BarTooltipItem(weekDay + '\n' + "${rod.y.round()} %",
        TextStyle(color: Colors.orange[200]));
  }
}
