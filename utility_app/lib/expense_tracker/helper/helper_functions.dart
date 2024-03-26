/*
These are functions that are useful across the app
*/
import 'package:intl/intl.dart';

//Convert String to Double
double convertStringtoDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

// Format Double Amount into Rupees

String formatAmount(double amount) {
  final format =
      NumberFormat.currency(locale: "en_US", symbol: "\₹", decimalDigits: 2);
  return format.format(amount);
}

// Calculate the number of months since the first month
int calculateMonthCount(
    int startYear, int startMonth, int currentYear, int currentMonth) {
  int monthCount =
      (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
  return monthCount;
}

// Get Current Month Name
String getCurrentMonthName() {
  DateTime now = DateTime.now();
  List<String> months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
  return months[now.month - 1]; 
}
