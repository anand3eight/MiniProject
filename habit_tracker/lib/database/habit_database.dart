import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // SETUP

  // INITIALIZE THE DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save First Date of App startup (For HeatMap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get First Date of App startup (For HeatMap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // CRUD Operations

  // List of Habits
  final List<Habit> currentHabits = [];

  // CREATE - Add a New Habit
  Future<void> addHabit(String habitName) async {
    // Create a new Habit
    final newHabit = Habit()..name = habitName;

    // Save to DB
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // Re-Read from DB
    readHabits();
  }

  // READ - Read Saved Habits from the Database
  Future<void> readHabits() async {
    // Fetch all Habits from DB
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // Give to Current Habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // Update UI
    notifyListeners();
  }

  // UPDATE - Check Habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // Find the Specific Habit
    final habit = await isar.habits.get(id);

    // Update the Completion Status
    if (habit != null) {
      await isar.writeTxn(() async {
        // If Habit is Completed -> Add the Current Date to the CompletedDays list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          // Today
          final today = DateTime.now();

          // Add the current date if it's not already in the list
          habit.completedDays.add(
            DateTime(today.year, today.month, today.day),
          );
        }

        // If Habit is NOT Completed -> remove the current date from the list
        else {
          // Remove the Current Date if the Habit is Marked as not Completed
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }

        // Save the Updated Habits Back to the DB
        await isar.habits.put(habit);
      });
    }
    // Re-Read from the DB
    readHabits();
  }

  // UPDATE - Edit Habit Name
  Future<void> updateHabitName(int id, String newName) async {
    // Find the Specific Habit
    final habit = await isar.habits.get(id);

    // Update Habit Name
    if (habit != null) {
      // Update Name
      await isar.writeTxn(() async {
        habit.name = newName;
        // Save Updated Habit Back to the DB
        await isar.habits.put(habit);
      });
    }

    // Re-Read from DB
    readHabits();
  }

  // DELETE - Delete a Habit
  Future<void> deleteHabit(int id) async {
    // Perform the Delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // Re-Read from the DB
    readHabits();
  }
}
