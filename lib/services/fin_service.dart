import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m_track/models/expense_model.dart';
import 'package:m_track/models/income_model.dart';

class UserService with ChangeNotifier {
  static const String _incomeBoxName = 'incomes';
  static const String _expenseBoxName = 'expenses';

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;

  Future<Box<IncomeModel>> openIncomeBox() async {
    return await Hive.openBox<IncomeModel>(_incomeBoxName);
  }

  Future<Box<ExpenseModel>> openExpenseBox() async {
    return await Hive.openBox<ExpenseModel>(_expenseBoxName);
  }

  Future<void> addIncome(IncomeModel income) async {
    final incomeBox = await openIncomeBox();

    await incomeBox.add(income);

    await _calculateTotalIncome(income.userId);
    notifyListeners();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final expenseBox = await openExpenseBox();

    await expenseBox.add(expense);

    await _calculateTotalExpense(expense.userId);
    notifyListeners();
  }

  Future<void> _calculateTotalIncome(String uid) async {
    //final incomeBox = await openIncomeBox();

    final List<IncomeModel> incomes = await getAllIncome(uid);

    _totalIncome = incomes.fold(
      0.0,
      (previousValue, income) => previousValue + income.amount,
    );
    notifyListeners();
  }

  Future<void> _calculateTotalExpense(String uid) async {
    //final expenseBox = await openExpenseBox();

    final List<ExpenseModel> expenses = await getAllExpense(uid);

    _totalExpense = expenses.fold(
      0.0,
      (previousValue, expense) => previousValue + expense.amount,
    );
    notifyListeners();
  }

  Future<List<IncomeModel>> getAllIncome(String uid) async {
    final incomeBox = await openIncomeBox();
    return incomeBox.values.where((income) => income.userId == uid).toList();
  }

  Future<List<ExpenseModel>> getAllExpense(String uid) async {
    final expenseBox = await openExpenseBox();
    return expenseBox.values.where((income) => income.userId == uid).toList();
  }

  Future<void> initializeTotals(String uid) async {
    await _calculateTotalIncome(uid);
    await _calculateTotalExpense(uid);
  }
}
