import 'package:expense_tracker/app_data/smstodata.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});
  final Color leftBarColor = Colors.green;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.teal;

  @override
  State<StatefulWidget> createState() => GraphPageState();
}

final SmsToData sms = Get.put(SmsToData());
String currentMonth = sms.getCurrentMonth();
String previousMonth = sms.getPreviousMonth();
String monthBeforePrevious = sms.getMonthBeforePrevious();
String monthBeforeThat = sms.getMonthBeforeThat();

class GraphPageState extends State<GraphPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  double? limitamount;
  final double width = 10;
  String currentMonth = sms.getCurrentMonth();
  String previousMonth = sms.getPreviousMonth();
  String monthBeforePrevious = sms.getMonthBeforePrevious();
  String monthBeforeThat = sms.getMonthBeforeThat();
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  double? debitSum = sms.sumList(sms.debitAmountlistnow) ?? 0.00;
  double? creditSum = sms.sumList(sms.creditAmountlistnow) ?? 0.00;

  double? debitSumlast = sms.sumList(sms.debitAmountlistlast) ?? 0.00;
  double? creditSumlast = sms.sumList(sms.creditAmountlistlast) ?? 0.00;

  double? debitSumlasttolast =
      sms.sumList(sms.debitAmountlistlasttolast) ?? 0.00;
  double? creditSumlasttolast =
      sms.sumList(sms.creditAmountlistlasttolast) ?? 0.00;

  double? debitSumlast3rd = sms.sumList(sms.debitAmountlistlastt3dr) ?? 0.00;
  double? creditSumlast3rd = sms.sumList(sms.creditAmountlistlast3dr) ?? 0.00;
  int touchedGroupIndex = -1;

  void refresh() async {
    final SharedPreferences preferences = await _prefs;
    setState(() {
      String? amountString = preferences.getString('amount');
      if (amountString != null) {
        limitamount = double.parse(amountString);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    refresh();
    final barGroup1 = makeGroupData(0, creditSumlast3rd!, debitSumlast3rd!);
    final barGroup2 =
        makeGroupData(1, creditSumlasttolast!, debitSumlasttolast!);
    final barGroup3 = makeGroupData(2, creditSumlast!, debitSumlast!);
    final barGroup4 = makeGroupData(3, creditSum!, debitSum!);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Transactions last 3 months',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Graph',
                      style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: Card(
                    child: BarChart(
                      BarChartData(
                        maxY: limitamount!,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (a, b, c, d) => null,
                          ),
                          touchCallback: (FlTouchEvent event, response) {
                            if (response == null || response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot!.touchedBarGroupIndex;

                            setState(() {
                              if (!event.isInterestedForInteractions) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                                return;
                              }
                              showingBarGroups = List.of(rawBarGroups);
                              if (touchedGroupIndex != -1) {
                                var sum = 0.0;
                                for (final rod
                                    in showingBarGroups[touchedGroupIndex]
                                        .barRods) {
                                  sum += rod.toY;
                                }
                                final avg = sum /
                                    showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .length;

                                showingBarGroups[touchedGroupIndex] =
                                    showingBarGroups[touchedGroupIndex]
                                        .copyWith(
                                  barRods: showingBarGroups[touchedGroupIndex]
                                      .barRods
                                      .map((rod) {
                                    return rod.copyWith(
                                        toY: avg, color: widget.avgColor);
                                  }).toList(),
                                );
                              }
                            });
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 42,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: showingBarGroups,
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Card(
                  child: ListTile(
                    title: Text(currentMonth),
                    subtitle: Text(
                        "Credited Rs. $creditSum \nDebited  Rs. $debitSum"),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(previousMonth),
                    subtitle: Text(
                        "Credited Rs. $creditSumlast \nDebited  Rs. $debitSumlast"),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(monthBeforePrevious),
                    subtitle: Text(
                        "Credited Rs. $creditSumlasttolast \nDebited  Rs. $debitSumlasttolast"),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(monthBeforeThat),
                    subtitle: Text(
                        "Credited Rs. $creditSumlast3rd \nDebited  Rs. $debitSumlast3rd"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      monthBeforeThat,
      monthBeforePrevious,
      previousMonth,
      currentMonth,
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 3,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
