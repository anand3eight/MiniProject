import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utility_app/expense_tracker/pages/expense_page.dart';
import 'package:utility_app/habit_tracker/pages/habit_tracker_page.dart';
import 'package:utility_app/theme/theme_provider.dart';
import 'package:utility_app/tictactoe/main.dart';
import 'package:utility_app/weather_app/pages/weather_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Utility App",
            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )
                          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.inversePrimary),
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
                    height:
                        20), // Add spacing between "Home" and CupertinoSwitch
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
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpensePage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text('Note your Expenses! 💵',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitTrackerPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text('Track your Habits! 🏃‍♂️',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text('What\'s the Weather? 🌡️',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicTacToe()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text('Just Another Game! ⚾',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
