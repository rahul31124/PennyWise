import 'package:drift/drift.dart';
import 'app_database.dart';

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);


  Stream<List<Transaction>> watchTransactions() {
    return _db.watchAllTransactions();
  }


  Future<void> deleteTransaction(String id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }


  Future<void> clearAllData() async {
    await _db.delete(_db.transactions).go();
  }

  Future<void> addTransaction({
    required double amount,
    required String note,
    required DateTime date,
    required String type,
    required String categoryId,
  }) async {
    await _db.insertTransaction(
      TransactionsCompanion(
        amount: Value(amount),
        note: Value(note),
        date: Value(date),
        type: Value(type),
        categoryId: Value(categoryId),
      ),
    );
  }
}