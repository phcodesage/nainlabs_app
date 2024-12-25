import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';
import '../models/sleep_session.dart';

class SleepTrackingScreen extends StatelessWidget {
  const SleepTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Sleep Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              // Navigate to analytics screen
            },
          ),
        ],
      ),
      body: Consumer<SleepProvider>(
        builder: (context, provider, child) {
          final currentSession = provider.currentSession;
          
          return Column(
            children: [
              _buildCurrentSession(currentSession),
              _buildQuickActions(context, provider),
              _buildRecentSessions(provider.recentSessions),
            ],
          );
        },
      ),
      floatingActionButton: _buildMainAction(context),
    );
  }

  Widget _buildCurrentSession(SleepSession? session) {
    if (session == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Sleep in Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add timer widget
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, SleepProvider provider) {
    return Wrap(
      spacing: 8,
      children: SleepEventType.values.map((type) {
        return ActionChip(
          label: Text(type.name),
          onPressed: () => provider.addEvent(type),
        );
      }).toList(),
    );
  }

  Widget _buildRecentSessions(List<SleepSession> sessions) {
    return Expanded(
      child: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return ListTile(
            title: Text('Sleep Session ${index + 1}'),
            subtitle: Text('Duration: ${session.duration.inHours}h ${session.duration.inMinutes % 60}m'),
            onTap: () {
              // Navigate to session details
            },
          );
        },
      ),
    );
  }

  Widget _buildMainAction(BuildContext context) {
    return Consumer<SleepProvider>(
      builder: (context, provider, child) {
        final isTracking = provider.currentSession != null;
        
        return FloatingActionButton.extended(
          onPressed: () {
            if (isTracking) {
              provider.stopTracking();
            } else {
              provider.startTracking();
            }
          },
          label: Text(isTracking ? 'Stop Tracking' : 'Start Sleep'),
          icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
        );
      },
    );
  }
} 