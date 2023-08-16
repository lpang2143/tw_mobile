import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tw_mobile/data/mock_price_data.dart';

class LineChartWidget extends StatelessWidget {
  final List<PricePoint> points;
  final Color darkPurple = const Color(0xFF6548EA);
  final Color lineColor = const Color(0xFF8640F9);

  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: priceProjectionChart(),
            ),
          ),
        ],
      ),
    );
  }

  LineChart priceProjectionChart() {
    return LineChart(
      LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: darkPurple,
                    strokeWidth: 0,
                  ),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: darkPurple,
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: darkPurple.withOpacity(0.04),
              tooltipPadding:
                  const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
              tooltipRoundedRadius: 15.0,
              tooltipBorder: BorderSide(
                color: darkPurple,
                width: 1.0,
              ),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final price = barSpot.y.toStringAsFixed(2);
                  return LineTooltipItem(
                    '\$$price',
                    const TextStyle(color: Colors.black),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              color: lineColor,
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: false,
              dotData: const FlDotData(
                show: false,
              ),
              shadow: Shadow(
                color: lineColor.withOpacity(0.7),
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ),
          ],
          borderData: FlBorderData(
            show: false,
          ),
          gridData: const FlGridData(
            show: false,
          ),
          titlesData: const FlTitlesData(
            show: false,
          )),
    );
  }
}
