import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import 'transaction_repository.dart';


final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionRepository(db);
});

final transactionListProvider = StreamProvider<List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchTransactions();
});