import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';


class Transactions extends Table {
  TextColumn get id => text().clientDefault(() =>
  "${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}")();

  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get categoryId => text()();
  TextColumn get type => text().withDefault(const Constant('expense'))();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> insertTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}