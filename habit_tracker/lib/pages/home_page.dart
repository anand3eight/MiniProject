import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Read Existing Habits on App Startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  // Text Controller
  final TextEditingController textController = TextEditingController();

  // Create New Habit
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Create New Habit",
                ),
              ),
              actions: [
                // Save Button
                MaterialButton(
                  onPressed: () {
                    // Get the New Habit Name
                    String newHabitName = textController.text;

                    // Save to DB
                    context.read<HabitDatabase>().addHabit(newHabitName);

                    // Pop Box
                    Navigator.pop(context);

                    // Clear Controller
                    textController.clear();
                  },
                  child: const Text("Save"),
                ),
                // Cancel Button
                MaterialButton(
                  onPressed: () {
                    // Pop Box
                    Navigator.pop(context);

                    // Clear Controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  // Check Habit On and Off
  void checkHabitOnOff(bool? value, Habit habit) {
    // Update Habit Completion Satus
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // Edit Habit Box
  void editHabitBox(Habit habit) {
    // Set the Controller's text to the Habit's Current Name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // Save Button
          MaterialButton(
            onPressed: () {
              // Get the New Habit Name
              String newHabitName = textController.text;

              // Save to DB
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              // Pop Box
              Navigator.pop(context);

              // Clear Controller
              textController.clear();
            },
            child: const Text("Save"),
          ),
          // Cancel Button
          MaterialButton(
            onPressed: () {
              // Pop Box
              Navigator.pop(context);

              // Clear Controller
              textController.clear();
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to Delete?"),
        actions: [
          // Delete Button
          MaterialButton(
            onPressed: () {
              // Save to DB
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // Pop Box
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),

          // Cancel Button
          MaterialButton(
            onPressed: () {
              // Pop Box
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: createNewHabit,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: const Icon(
            Icons.add,
          )),
      body: ListView(
        children: [
          // HeatMap
          _buildHeatMap(),
          // HabitList
          _buildHabitList(),
        ],
      ),
    );
  }

  // Build Heat Map
  Widget _buildHeatMap() {
    // Habit DataBase
    final habitDatabase = context.watch<HabitDatabase>();

    // Current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return Heat Map UI
    return FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          // Once the Data is available -> Build Heatmap
          if (snapshot.hasData) {
            return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits),
            );
          }
          return Container();
          // Handle Case where no data is returned
        });
  }

  // Build Habit List
  Widget _buildHabitList() {
    // Habit DB
    final habitDatabase = context.watch<HabitDatabase>();

    // Current Habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return List of Habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // Get Each Individual Habit
        final habit = currentHabits[index];

        // Check if the Habit is completed Today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // Return Habit Tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
