import 'package:utility_app/expense_tracker/bar_graph/bar_graph.dart';
import 'package:utility_app/expense_tracker/components/my_list_tile.dart';
import 'package:utility_app/expense_tracker/helper/helper_functions.dart';
import 'package:utility_app/expense_tracker/models/expense.dart';
import 'package:utility_app/expense_tracker/models/expense_database.dart';
import 'package:utility_app/pages/homepage.dart';
import 'package:utility_app/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  // Text Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Future to Load Graph Data and Monthly Total
  Future<Map<String, double>>? _monthlyTotalsFuture;
  Future<double>? _calculateCurrentMonthTotal;

  @override
  void initState() {
    // Read DB on Initial Startup
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    // Load Futures
    refreshData();
    super.initState();
  }

  // Refresh Graph Data
  void refreshData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
    _calculateCurrentMonthTotal =
        Provider.of<ExpenseDatabase>(context, listen: false)
            .calculateCurrentMonthTotal();
  }

  // open New Expense Box
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "New Expense",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expense Name - User Input
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )),
            ),
            // Expense Amount - User Input
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                  hintText: "Amount",
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          _cancelButton(),

          // Save Button
          _createMewExpenseButton(),
        ],
      ),
    );
  }

  void openEditBox(Expense expense) {
    // Pre-fill the existing values
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expense Name - User Input
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: existingName),
            ),
            // Expense Amount - User Input
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: existingAmount),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          _cancelButton(),

          // Save Button
          _editExpenseButton(expense),
        ],
      ),
    );
  }

  void openDeleteBox(Expense expense) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Delete Expense?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              actions: [
                // Cancel Button
                _cancelButton(),

                // Delete Button
                _deleteExpenseButton(expense.id),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      // Get Dates
      int startMonth = DateTime.january;
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;

      // Calculate the Number of Months since the first Month
      int monthCount =
          calculateMonthCount(startYear, startMonth, currentYear, currentMonth);

      // Only Display the expenses from the current month
      List<Expense> currentMonthExpenses = value.allExpense.where((expense) {
        return expense.date.year == currentYear &&
            expense.date.month == currentMonth;
      }).toList();

      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.inversePrimary),
            title: FutureBuilder<double>(
                future: _calculateCurrentMonthTotal,
                builder: (context, snapshot) {
                  // Loaded
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Amount total
                        Text(
                          '₹${snapshot.data!.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),

                        // Month
                        Text(getCurrentMonthName(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            )),
                      ],
                    );
                  }
                  return Text(
                    "Loading... ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  );
                }),
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
          body: SafeArea(
            child: Column(
              children: [
                // Graph UI
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                      future: _monthlyTotalsFuture,
                      builder: (context, snapshot) {
                        // Data is Loaded
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, double> monthlyTotals =
                              snapshot.data ?? {};

                          // Create the List of Monthly Summary
                          List<double> monthlySummary =
                              List.generate(monthCount, (index) {
                            // Calculate year-month considering startmonth & index
                            int year =
                                startYear + (startMonth + index - 1) ~/ 12;
                            int month = (startMonth + index - 1) % 12 + 1;

                            // Create the key in the format 'year-month'
                            String yearmonthKey = '$year-$month';

                            // Return the total for year-month or 0.0 if non-existent
                            return monthlyTotals[yearmonthKey] ?? 0.0;
                          });
                          return MyBarGraph(
                              monthlySummary: monthlySummary,
                              startMonth: startMonth);
                        }

                        // Loading
                        else {
                          return Center(
                            child: Text(
                              "Loading...",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          );
                        }
                      }),
                ),
                const SizedBox(
                  height: 25,
                ),
                // Expense List UI
                Expanded(
                  child: ListView.builder(
                    itemCount: currentMonthExpenses.length,
                    itemBuilder: (context, index) {
                      // Reverse the Index to show latest item first
                      int reversedIndex =
                          currentMonthExpenses.length - 1 - index;

                      // Get Individiual Expense
                      Expense individualExpense =
                          currentMonthExpenses[reversedIndex];

                      // Return List File UI
                      return MyListTile(
                        title: individualExpense.name,
                        trailing: formatAmount(individualExpense.amount),
                        onEditPressed: (context) =>
                            openEditBox(individualExpense),
                        onDeletePressed: (context) =>
                            openDeleteBox(individualExpense),
                      );
                    },
                  ),
                )
              ],
            ),
          ));
    });
  }

  // Cancel Button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        // Pop Box
        Navigator.pop(context);

        // Clear Controllers
        nameController.clear();
        amountController.clear();
      },
      child: Text(
        'Cancel',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  // Save Button
  Widget _createMewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        //only save if there is something in the text field
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //Pop Box
          Navigator.pop(context);

          //Create New Expense
          Expense newExpense = Expense(
            name: nameController.text,
            amount: convertStringtoDouble(amountController.text),
            date: DateTime.now(),
          );

          // Save to DB
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          // Refresh Graph
          refreshData();

          // Clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: Text(
        'Save',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  // Save Button - Edit Existing Response
  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        // Save as Long as at least one textfield has been changed
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          // Pop Box
          Navigator.pop(context);

          // Create a new updated Expense
          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : expense.name,
            amount: amountController.text.isNotEmpty
                ? convertStringtoDouble(amountController.text)
                : expense.amount,
            date: DateTime.now(),
          );

          // Old Expense ID
          int existingID = expense.id;

          // Save to DB
          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingID, updatedExpense);

          // Refresh Graph
          refreshData();
        }
      },
      child: Text(
        "Save",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  // Delete Button
  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        // Pop Box
        Navigator.pop(context);

        // Delete Expense from DB
        await context.read<ExpenseDatabase>().deleteExpense(id);

        // Refresh Graph
        refreshData();
      },
      child: Text(
        "Delete",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
