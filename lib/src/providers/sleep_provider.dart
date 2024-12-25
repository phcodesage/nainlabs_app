import 'package:flutter/foundation.dart';
import '../models/sleep_session.dart';
import '../services/sleep_tracking_service.dart';

class SleepProvider extends ChangeNotifier {
  final SleepTrackingService _service;
  SleepSession? _currentSession;
  List<SleepSession> _recentSessions = [];
  Map<String, dynamic> _analytics = {};

  SleepProvider(this._service);

  SleepSession? get currentSession => _currentSession;
  List<SleepSession> get recentSessions => _recentSessions;
  Map<String, dynamic> get analytics => _analytics;

  Future<void> startTracking() async {
    await _service.startSession();
    // Update state and notify listeners
    notifyListeners();
  }

  Future<void> stopTracking() async {
    if (_currentSession != null) {
      await _service.endSession(_currentSession!.id);
      _currentSession = null;
      notifyListeners();
    }
  }

  Future<void> addEvent(SleepEventType type, {String? note}) async {
    if (_currentSession != null) {
      final event = SleepEvent(
        time: DateTime.now(),
        type: type,
        note: note,
      );
      await _service.addEvent(_currentSession!.id, event);
      notifyListeners();
    }
  }

  Future<void> loadRecentSessions() async {
    _recentSessions = await _service.getRecentSessions();
    _analytics = await _service.getAnalytics();
    notifyListeners();
  }
} 