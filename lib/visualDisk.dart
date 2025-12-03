import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constant.dart';
//import 'package:task_manager/provider.dart';
import 'package:task_manager/providers/diskProvider.dart';

class VisualDisk extends ConsumerStatefulWidget {
 VisualDisk({super.key, required this.showGrid});
  final bool showGrid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VisualDiskState();
}

class _VisualDiskState extends ConsumerState<VisualDisk> {
 List<FlSpot> spots = [];
  double x = 0;
  double xMax = 60;
  double xMin = 0;
  double yMax=100;
   List<FlSpot> spots1 = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,

      width: 700,
      child: Consumer(
        builder: (context, ref, child) {
          final streams = ref.watch(diskBuilder);
          //print("1");
          return streams.when(
            data: (data) {
             // print("2");
              
              if (data.containsKey("read")) {
                double yValue = (data["read"]??0);
                spots.add(FlSpot(x, yValue));
                yValue = (data["write"]??0);
                spots1.add(FlSpot(x, yValue));
                x++;
              }
              if (spots.length >=63) {
                spots.removeAt(0);
                spots1.removeAt(0);
              }
              if (x >60) {
                xMax = x;
                xMin += 1;
              }
              return LineChart(
                LineChartData(
                  clipData: FlClipData.all(),
                  titlesData: FlTitlesData(show: false),
                  lineTouchData: LineTouchData(enabled: false),
                  maxX: xMax,
                  minX: xMin,
                  maxY: data["max"],
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
                  
                  LineChartBarData(
                      spots: spots1,
                      dotData: FlDotData(show: false),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: gradientColor1
                            .map((color) => color.withOpacity(0.8))
                            .toList(),
                      ),
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColor1
                              .map((color) => color.withOpacity(0.3))
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