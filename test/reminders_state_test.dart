import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/reminder.dart';
import 'package:mobile/features/reminders/reminders_controller.dart';

Reminder _reminder(String id, DateTime dueAt) => Reminder(
  id: id,
  assignedToUserId: 'u1',
  createdByUserId: 'u1',
  title: id,
  dueAt: dueAt.toUtc().toIso8601String(),
);

void main() {
  test('sections partition without overlap: overdue / today / upcoming', () {
    final now = DateTime.now();
    final overdue = _reminder('overdue', now.subtract(const Duration(hours: 1)));
    // Clamp "later today" so it never crosses midnight during the test run.
    final laterToday = _reminder(
      'today',
      DateTime(now.year, now.month, now.day, 23, 59),
    );
    final nextWeek = _reminder('upcoming', now.add(const Duration(days: 7)));

    final state = RemindersState(
      items: [overdue, laterToday, nextWeek],
      loading: false,
    );

    expect(state.overdue.map((r) => r.id), ['overdue']);
    expect(state.dueToday.map((r) => r.id), ['today']);
    expect(state.upcoming.map((r) => r.id), ['upcoming']);
  });

  test('badge counts overdue + dueToday from the server summary', () {
    const state = RemindersState(
      summary: ReminderSummary(overdue: 2, dueToday: 3, upcoming: 9),
    );
    expect(state.dueCount, 5);
  });

  test('Reminder JSON round-trips and derives overdue', () {
    final json = {
      'id': 'rem-1',
      'clientId': 'client-9',
      'assignedToUserId': 'u1',
      'createdByUserId': 'u2',
      'title': 'Chase the quote',
      'priority': 'high',
      'dueAt': '2020-01-01T00:00:00.000Z',
      'status': 'pending',
      'snoozeCount': 1,
    };
    final reminder = Reminder.fromJson(json);
    expect(reminder.priority, ReminderPriority.high);
    expect(reminder.isOverdue, isTrue);
    expect(Reminder.fromJson(reminder.toJson()), reminder);
  });
}
