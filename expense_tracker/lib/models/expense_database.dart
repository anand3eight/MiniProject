import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> allExpense = [];

  // SETUP
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  // GETTER
  List<Expense> getAllExpenses() => allExpense;

  // OPERATIONS
  // Create - Add an Expense
  Future<void> createNewExpense(Expense newExpense) async {
    // add to DB
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    //re-read from db
    readExpenses();
  }

  // Read - Expenses from DB

  Future<void> readExpenses() async {
    //Fetch All Expenses from DB
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // Store to local expense list
    allExpense.clear();
    allExpense.addAll(fetchedExpenses);

    // update UI
    notifyListeners();
  }

  // Update - Edit an Expense
  Future<void> updateExpense(int id, Expense updatedExpense) async {
    // Check if ID exists
    updatedExpense.id = id;
    // Update in DB
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));
    // Re-read from DB
    await readExpenses();
  }

  // Delete - An Expense
  Future<void> deleteExpense(int id) async {
    // Delete from DB
    await isar.writeTxn(() => isar.expenses.delete(id));

    // Re-read from DB
    await readExpenses();
  }

  // Helper Methods

  // Calculate Total Expenses for Each Month

  /*
  2023-1 : 250
  2024-2 : 500 and so on 
  */

  Future<Map<String, double>> calculateMonthlyTotals() async {
    // Ensure the expense are read from the DB
    await readExpenses();

    // Create a Map to keep track of total expenses per month
    Map<String, double> monthlyTotals = {};
    for (var expense in allExpense) {
      // Extract the Year and Month From the Date of the Expense
      String yearMonth = "${expense.date.year}-${expense.date.month}";

      // If the year-month is not yet in the map, initialize it to Zero
      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }

      // Add the Expense amount to the total for the month
      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
    }

    return monthlyTotals;
  }

  // Calculate Current Month Total
  Future<double> calculateCurrentMonthTotal() async {
    // Ensure Expenses are read from the DB first
    await readExpenses();

    // Get Current Month, Year
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;

    // Filter Expenses to include onl those for this month this year
    List<Expense> currentMonthExpenses = allExpense.where((expense) {
      return expense.date.month == currentMonth &&
          expense.date.year == currentYear;
    }).toList();

    // Calculate Total Amount for the Current Month
    double total =
        currentMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return total;
  }

  // Get Start Month
  int getStartMonth() {
    if (allExpense.isEmpty) {
      return DateTime.now().month;
    }

    // Sort Expense by Date to find the earliest month
    allExpense.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return allExpense.first.date.month;
  }

  // Get Start Year
  int getStartYear() {
    if (allExpense.isEmpty) {
      return DateTime.now().year;
    }

    // Sort Expense by Date to find the earliest month
    allExpense.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return allExpense.first.date.year;
  }
}
