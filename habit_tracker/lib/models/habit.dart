import 'package:isar/isar.dart';

// Run Command to generate file: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // Habit ID
  Id id = Isar.autoIncrement;

  // Habit Name
  late String name;

  // Completed Days
  List<DateTime> completedDays = [
    // DataTime(year, month, day),
    // DataTime(2024, 1, 1),
    // DataTime(2024, 1, 2),
  ];
}
