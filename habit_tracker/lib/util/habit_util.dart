// Given a Habit list of Completion Days
// Is the Habit Completed Today

import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// Prepare the HeatMap dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Normalize Date to avoid Time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // If the date already exists in the dataset, increment its count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      }
      // Else initialize it with a count of 1
      else {
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}
