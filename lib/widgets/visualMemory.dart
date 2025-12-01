import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constant.dart';
import 'package:task_manager/provider.dart';

class VisualMemory extends ConsumerStatefulWidget {
  const VisualMemory({super.key, required this.showGrid});
  final bool showGrid;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VisualMemoryState();
}

class _VisualMemoryState extends ConsumerState<VisualMemory> {
  List<FlSpot> spots = [];
  double x = 0;
  double xMax = 60;
  double xMin = 0;
  double yMax=100;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,

      width: 700,
      child: Consumer(
        builder: (context, ref, child) {
          final streams = ref.watch(memoryBuilder);
          //print("1");
          return streams.when(
            data: (data) {
             // print("2");
              
              if (data.containsKey("used")) {
                double yValue = (data["used"]!/data["total"]!)*100;
                //print(yValue);
                spots.add(FlSpot(x, yValue));
                x++;
              }
              if (spots.length >59) {
                spots.removeAt(0);
              }
              if (x >59) {
                xMax = x;
                xMin += 1;
              }
              return LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  lineTouchData: LineTouchData(enabled: false),
                  maxX: xMax,
                  minX: xMin,
                  maxY: yMax,
                  minY: 0,
                  gridData: FlGridData(
                    show: widget.showGrid,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Color(0xFF37434D), strokeWidth: 2),
                    getDrawingVerticalLine: (value) =>
                        FlLine(color: Color(0xFF37434D), strokeWidth: 2),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Color(0xFF37434D), width: 2),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      dotData: FlDotData(show: false),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: gradientColor
                            .map((color) => color.withOpacity(0.8))
                            .toList(),
                      ),
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColor
                              .map((color) => color.withOpacity(0.7))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stack) => Text("Error"),
            loading: () => Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
