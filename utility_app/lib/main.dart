import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:utility_app/expense_tracker/models/expense_database.dart';
import 'package:utility_app/habit_tracker/database/habit_database.dart';
import 'package:utility_app/pages/homepage.dart';
import 'package:utility_app/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Database
  Isar isar = await ExpenseDatabase.initialize();
  await HabitDatabase.initialize(isar);
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
    MultiProvider(
      providers: [
        // Expense Provider
        ChangeNotifierProvider(create: (context) => ExpenseDatabase()),
        // Habit Provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        // Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context)
          .themeData, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
