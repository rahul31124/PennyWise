import 'package:shared_preferences/shared_preferences.dart';

class BudgetService {
  static const String _key = 'global_monthly_budget_v2';

  static Future<void> setBudget(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, amount);
  }

  static Future<double> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_key) ?? 0;
  }

  static Future<void> removeBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}