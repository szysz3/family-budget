import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BaseChartState<T extends StatefulWidget, D> extends State<T> {
  final Duration animDuration = Duration(milliseconds: 250);
  final Color barBackgroundColor = const Color(0xFFCFD8DC);

  Function _getData;
  DateTime _dateTime;

  BaseChartState(Function getData, DateTime dateTime) {
    _getData = getData;
    _dateTime = dateTime;
  }

  Widget getChart(D data);

  Color getTooltipBcgColor();

  Color getTitleColor();

  BarTooltipItem getTooltipItem(
      D data, BarChartGroupData group, BarChartRodData rod);

  String getTitleItem(D data, double value);

  List<BarChartGroupData> getGroups(D data);

  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  Widget buildWidget() {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done &&
            !snap.hasError &&
            snap.hasData) {
          return getChart(snap.data);
        } else {
          return SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(),
          );
        }
      },
      future: _getData(_dateTime),
    );
  }

  BarChartData getBarChartData(D data) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: getTooltipBcgColor(),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return getTooltipItem(data, group, rod);
            }),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: getTitleColor(),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 16,
            getTitles: (double value) {
              return getTitleItem(data, value);
            }),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: getGroups(data),
    );
  }

  BarChartGroupData makeGroupData(double max, int x, double y,
      {bool isTouched = false,
      Color barColor = const Color(0xFF90A4AE),
      double width = 22,
      List<int> showTooltips = const [],
      limitToMax = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: limitToMax ? (y > max ? max : y) : y,
          color: isTouched ? Colors.orange[400] : barColor,
          width: width,
          isRound: true,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: max,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
