import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utility_app/habit_tracker/components/my_habit_tile.dart';
import 'package:utility_app/habit_tracker/components/my_heat_map.dart';
import 'package:utility_app/habit_tracker/models/habit.dart';
import 'package:utility_app/habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';
import 'package:utility_app/habit_tracker/database/habit_database.dart';
import 'package:utility_app/pages/homepage.dart';
import 'package:utility_app/theme/theme_provider.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
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
                decoration: InputDecoration(
                  hintText: "Create New Habit",
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
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
                  child: Text("Save", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                ),
                // Cancel Button
                MaterialButton(
                  onPressed: () {
                    // Pop Box
                    Navigator.pop(context);

                    // Clear Controller
                    textController.clear();
                  },
                  child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
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
            child: Text("Save", style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          // Cancel Button
          MaterialButton(
            onPressed: () {
              // Pop Box
              Navigator.pop(context);

              // Clear Controller
              textController.clear();
            },
            child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
          )
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to Delete?", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        actions: [
          // Delete Button
          MaterialButton(
            onPressed: () {
              // Save to DB
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // Pop Box
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
          ),

          // Cancel Button
          MaterialButton(
            onPressed: () {
              // Pop Box
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
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
        title: Text("Track Your Habits!🏃‍♂️",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.inversePrimary,
            )),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              const SizedBox(
                  height: 20), // Add spacing between "Home" and CupertinoSwitch
              CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
              ),
            ],
          ),
        ),
      ),
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
