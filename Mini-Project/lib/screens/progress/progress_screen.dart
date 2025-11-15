import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    final data = app.dailyActivity;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Progress")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // STREAK SUMMARY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox("Streak", "${app.streak}", Icons.local_fire_department),
                _statBox("Questions", "${app.totalQuestions}", Icons.help),
                _statBox("Challenges", "${app.totalChallenges}", Icons.flag),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // GRAPH TITLE
            const Text("Last 7 Days Activity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // GRAPH
            Expanded(
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (i, _) {
                          const labels = ["M", "T", "W", "T", "F", "S", "S"];
                          return Text(labels[i.toInt() % 7]);
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    7,
                        (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i].toDouble(),
                          color: colors.primary,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ]),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.deepPurple),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
