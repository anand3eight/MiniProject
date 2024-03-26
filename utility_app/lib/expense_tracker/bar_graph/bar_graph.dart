import 'package:utility_app/expense_tracker/bar_graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;
  const MyBarGraph(
      {super.key, required this.monthlySummary, required this.startMonth});

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  // This list will hold the data for each bar
  List<IndividualBar> barData = [];

  @override
  void initState() {
    super.initState();

    // We Need to scroll to the latest month automatically
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrollToEnd());
  }

  // Initialize the Bar Data
  void initializeBarData() {

    barData = List.generate(widget.monthlySummary.length,
        (index) => IndividualBar(x: index, y: widget.monthlySummary[index]));
  }

  // Recalculate Maximum Value for upperlimit
  double calculateMax() {
    // Initially Set it at 500, but adjust if spending is past this amount
    double max = 500;

    // Get Month with the higherst amount
    widget.monthlySummary.sort();

    // increase the upper limit by a bit
    max = widget.monthlySummary.last * 1.05;

    if (max < 500) {
      return 500;
    }
    return max;
  }

  // Scroll Contoller to make it scrolls to the end / latest month
  final ScrollController _scrollController = ScrollController();
  void scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize Upon Build
    initializeBarData();

    // Bar Dimension Sizes
    double barWidth = 20;
    double spaceBetweenBars = 15;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: SizedBox(
          width: barWidth * barData.length +
              spaceBetweenBars * (barData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: getBottomTitles,
                  reservedSize: 24,
                )),
              ),
              barGroups: barData
                  .map((data) => BarChartGroupData(
                        x: data.x,
                        barRods: [
                          BarChartRodData(
                              toY: data.y,
                              width: barWidth,
                              borderRadius: BorderRadius.circular(4),
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: calculateMax(),
                                color: Theme.of(context).colorScheme.primary,
                              ))
                        ],
                      ))
                  .toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweenBars,
            ),
          ),
        ),
      ),
    );
  }
}

// Bottom Titles

Widget getBottomTitles(double value, TitleMeta meta) {
  const textstyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  String text;
  switch (value.toInt() % 12) {
    case 0:
      text = 'J';
      break;
    case 1:
      text = 'F';
      break;
    case 2:
      text = 'M';
      break;
    case 3:
      text = 'A';
      break;
    case 4:
      text = 'M';
      break;
    case 5:
      text = 'J';
      break;
    case 6:
      text = 'J';
      break;
    case 7:
      text = 'A';
      break;
    case 8:
      text = 'S';
      break;
    case 9:
      text = 'O';
      break;
    case 10:
      text = 'N';
      break;
    case 11:
      text = 'D';
      break;
    default:
      text = '';
      break;
  }

  return SideTitleWidget(
      child: Text(text, style: textstyle), axisSide: meta.axisSide);
}
