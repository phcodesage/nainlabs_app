import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';
import '../models/sleep_session.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Analytics'),
      ),
      body: Consumer<SleepProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSleepChart(provider.recentSessions),
                const SizedBox(height: 24),
                _buildSleepStats(provider.analytics),
                const SizedBox(height: 24),
                _buildSleepQualityDistribution(provider.recentSessions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSleepChart(List<SleepSession> sessions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Duration (Last 7 Days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSleepDataPoints(sessions),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getSleepDataPoints(List<SleepSession> sessions) {
    // Convert sessions to data points
    return sessions.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.duration.inHours.toDouble(),
      );
    }).toList();
  }

  Widget _buildSleepStats(Map<String, dynamic> analytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Average Sleep Duration', '${analytics['avgDuration'] ?? 0} hours'),
            _buildStatRow('Longest Sleep', '${analytics['maxDuration'] ?? 0} hours'),
            _buildStatRow('Sleep Quality', analytics['qualityText'] ?? 'N/A'),
            _buildStatRow('Total Sleep Time', '${analytics['totalSleep'] ?? 0} hours'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualityDistribution(List<SleepSession> sessions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Quality Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _getQualityDistribution(sessions),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getQualityDistribution(List<SleepSession> sessions) {
    // Calculate quality distribution
    final Map<SleepQuality, int> distribution = {};
    for (final session in sessions) {
      distribution[session.quality] = (distribution[session.quality] ?? 0) + 1;
    }

    // Convert to pie chart sections
    return distribution.entries.map((entry) {
      final color = _getQualityColor(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.key.name}\n${entry.value}',
        color: color,
        radius: 100,
      );
    }).toList();
  }

  Color _getQualityColor(SleepQuality quality) {
    switch (quality) {
      case SleepQuality.excellent:
        return Colors.green;
      case SleepQuality.good:
        return Colors.lightGreen;
      case SleepQuality.fair:
        return Colors.yellow;
      case SleepQuality.poor:
        return Colors.red;
      case SleepQuality.unknown:
        return Colors.grey;
    }
  }
} 