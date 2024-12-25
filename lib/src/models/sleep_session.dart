import 'package:flutter/material.dart';

class SleepSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final SleepQuality quality;
  final List<String> notes;
  final List<SleepEvent> events;

  SleepSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.quality = SleepQuality.unknown,
    this.notes = const [],
    this.events = const [],
  });

  Duration get duration {
    return endTime?.difference(startTime) ?? Duration.zero;
  }

  bool get isOngoing => endTime == null;
}

enum SleepQuality {
  excellent,
  good,
  fair,
  poor,
  unknown,
}

class SleepEvent {
  final DateTime time;
  final SleepEventType type;
  final String? note;

  SleepEvent({
    required this.time,
    required this.type,
    this.note,
  });
}

enum SleepEventType {
  wakeup,
  crying,
  feeding,
  diaperChange,
  other,
} 