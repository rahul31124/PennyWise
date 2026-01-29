part of 'app_database.dart';

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () =>
    "${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}",
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expense'),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    note,
    date,
    categoryId,
    type,
    isSynced,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<Transaction> instance, {
        bool isInserting = false,
      }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final double amount;
  final String? note;
  final DateTime date;
  final String categoryId;
  final String type;
  final bool isSynced;
  final DateTime updatedAt;
  final bool isDeleted;
  const Transaction({
    required this.id,
    required this.amount,
    this.note,
    required this.date,
    required this.categoryId,
    required this.type,
    required this.isSynced,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    map['category_id'] = Variable<String>(categoryId);
    map['type'] = Variable<String>(type);
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
      categoryId: Value(categoryId),
      type: Value(type),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Transaction.fromJson(
      Map<String, dynamic> json, {
        ValueSerializer? serializer,
      }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      type: serializer.fromJson<String>(json['type']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
      'categoryId': serializer.toJson<String>(categoryId),
      'type': serializer.toJson<String>(type),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Transaction copyWith({
    String? id,
    double? amount,
    Value<String?> note = const Value.absent(),
    DateTime? date,
    String? categoryId,
    String? type,
    bool? isSynced,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => Transaction(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    type: type ?? this.type,
    isSynced: isSynced ?? this.isSynced,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      type: data.type.present ? data.type.value : this.type,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
      ..write('id: $id, ')
      ..write('amount: $amount, ')
      ..write('note: $note, ')
      ..write('date: $date, ')
      ..write('categoryId: $categoryId, ')
      ..write('type: $type, ')
      ..write('isSynced: $isSynced, ')
      ..write('updatedAt: $updatedAt, ')
      ..write('isDeleted: $isDeleted')
      ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    note,
    date,
    categoryId,
    type,
    isSynced,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Transaction &&
              other.id == this.id &&
              other.amount == this.amount &&
              other.note == this.note &&
              other.date == this.date &&
              other.categoryId == this.categoryId &&
              other.type == this.type &&
              other.isSynced == this.isSynced &&
              other.updatedAt == this.updatedAt &&
              other.isDeleted == this.isDeleted);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<double> amount;
  final Value<String?> note;
  final Value<DateTime> date;
  final Value<String> categoryId;
  final Value<String> type;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    this.note = const Value.absent(),
    required DateTime date,
    required String categoryId,
    this.type = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : amount = Value(amount),
        date = Value(date),
        categoryId = Value(categoryId);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<String>? categoryId,
    Expression<String>? type,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (categoryId != null) 'category_id': categoryId,
      if (type != null) 'type': type,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<double>? amount,
    Value<String?>? note,
    Value<DateTime>? date,
    Value<String>? categoryId,
    Value<String>? type,
    Value<bool>? isSynced,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
      ..write('id: $id, ')
      ..write('amount: $amount, ')
      ..write('note: $note, ')
      ..write('date: $date, ')
      ..write('categoryId: $categoryId, ')
      ..write('type: $type, ')
      ..write('isSynced: $isSynced, ')
      ..write('updatedAt: $updatedAt, ')
      ..write('isDeleted: $isDeleted, ')
      ..write('rowid: $rowid')
      ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactions];
}

typedef $$TransactionsTableCreateCompanionBuilder =
TransactionsCompanion Function({
Value<String> id,
required double amount,
Value<String?> note,
required DateTime date,
required String categoryId,
Value<String> type,
Value<bool> isSynced,
Value<DateTime> updatedAt,
Value<bool> isDeleted,
Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder =
TransactionsCompanion Function({
Value<String> id,
Value<double> amount,
Value<String?> note,
Value<DateTime> date,
Value<String> categoryId,
Value<String> type,
Value<bool> isSynced,
Value<DateTime> updatedAt,
Value<bool> isDeleted,
Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
    RootTableManager<
        _$AppDatabase,
        $TransactionsTable,
        Transaction,
        $$TransactionsTableFilterComposer,
        $$TransactionsTableOrderingComposer,
        $$TransactionsTableAnnotationComposer,
        $$TransactionsTableCreateCompanionBuilder,
        $$TransactionsTableUpdateCompanionBuilder,
        (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
        ),
        Transaction,
        PrefetchHooks Function()
    > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(
    TableManagerState(
      db: db,
      table: table,
      createFilteringComposer: () =>
          $$TransactionsTableFilterComposer($db: db, $table: table),
      createOrderingComposer: () =>
          $$TransactionsTableOrderingComposer($db: db, $table: table),
      createComputedFieldComposer: () =>
          $$TransactionsTableAnnotationComposer($db: db, $table: table),
      updateCompanionCallback:
          ({
        Value<String> id = const Value.absent(),
        Value<double> amount = const Value.absent(),
        Value<String?> note = const Value.absent(),
        Value<DateTime> date = const Value.absent(),
        Value<String> categoryId = const Value.absent(),
        Value<String> type = const Value.absent(),
        Value<bool> isSynced = const Value.absent(),
        Value<DateTime> updatedAt = const Value.absent(),
        Value<bool> isDeleted = const Value.absent(),
        Value<int> rowid = const Value.absent(),
      }) => TransactionsCompanion(
        id: id,
        amount: amount,
        note: note,
        date: date,
        categoryId: categoryId,
        type: type,
        isSynced: isSynced,
        updatedAt: updatedAt,
        isDeleted: isDeleted,
        rowid: rowid,
      ),
      createCompanionCallback:
          ({
        Value<String> id = const Value.absent(),
        required double amount,
        Value<String?> note = const Value.absent(),
        required DateTime date,
        required String categoryId,
        Value<String> type = const Value.absent(),
        Value<bool> isSynced = const Value.absent(),
        Value<DateTime> updatedAt = const Value.absent(),
        Value<bool> isDeleted = const Value.absent(),
        Value<int> rowid = const Value.absent(),
      }) => TransactionsCompanion.insert(
        id: id,
        amount: amount,
        note: note,
        date: date,
        categoryId: categoryId,
        type: type,
        isSynced: isSynced,
        updatedAt: updatedAt,
        isDeleted: isDeleted,
        rowid: rowid,
      ),
      withReferenceMapper: (p0) => p0
          .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
          .toList(),
      prefetchHooksCallback: null,
    ),
  );
}

typedef $$TransactionsTableProcessedTableManager =
ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
    Transaction,
    BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
    ),
    Transaction,
    PrefetchHooks Function()
>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}