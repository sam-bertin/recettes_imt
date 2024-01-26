// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecetteTable extends Recette
    with TableInfo<$RecetteTable, RecetteTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecetteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dureeMeta = const VerificationMeta('duree');
  @override
  late final GeneratedColumn<int> duree = GeneratedColumn<int>(
      'duree', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name, description, duree];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recette';
  @override
  VerificationContext validateIntegrity(Insertable<RecetteTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('duree')) {
      context.handle(
          _dureeMeta, duree.isAcceptableOrUnknown(data['duree']!, _dureeMeta));
    } else if (isInserting) {
      context.missing(_dureeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  RecetteTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecetteTable(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      duree: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duree'])!,
    );
  }

  @override
  $RecetteTable createAlias(String alias) {
    return $RecetteTable(attachedDatabase, alias);
  }
}

class RecetteTable extends DataClass implements Insertable<RecetteTable> {
  final String name;
  final String description;
  final int duree;
  const RecetteTable(
      {required this.name, required this.description, required this.duree});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['duree'] = Variable<int>(duree);
    return map;
  }

  RecetteCompanion toCompanion(bool nullToAbsent) {
    return RecetteCompanion(
      name: Value(name),
      description: Value(description),
      duree: Value(duree),
    );
  }

  factory RecetteTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecetteTable(
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      duree: serializer.fromJson<int>(json['duree']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'duree': serializer.toJson<int>(duree),
    };
  }

  RecetteTable copyWith({String? name, String? description, int? duree}) =>
      RecetteTable(
        name: name ?? this.name,
        description: description ?? this.description,
        duree: duree ?? this.duree,
      );
  @override
  String toString() {
    return (StringBuffer('RecetteTable(')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('duree: $duree')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, description, duree);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecetteTable &&
          other.name == this.name &&
          other.description == this.description &&
          other.duree == this.duree);
}

class RecetteCompanion extends UpdateCompanion<RecetteTable> {
  final Value<String> name;
  final Value<String> description;
  final Value<int> duree;
  final Value<int> rowid;
  const RecetteCompanion({
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.duree = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecetteCompanion.insert({
    required String name,
    required String description,
    required int duree,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        description = Value(description),
        duree = Value(duree);
  static Insertable<RecetteTable> custom({
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? duree,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (duree != null) 'duree': duree,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecetteCompanion copyWith(
      {Value<String>? name,
      Value<String>? description,
      Value<int>? duree,
      Value<int>? rowid}) {
    return RecetteCompanion(
      name: name ?? this.name,
      description: description ?? this.description,
      duree: duree ?? this.duree,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (duree.present) {
      map['duree'] = Variable<int>(duree.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecetteCompanion(')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('duree: $duree, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientTable extends Ingredient
    with TableInfo<$IngredientTable, IngredientTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recetteNameMeta =
      const VerificationMeta('recetteName');
  @override
  late final GeneratedColumn<String> recetteName = GeneratedColumn<String>(
      'recette_name', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES recette(name)');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, recetteName, name, quantity, unit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient';
  @override
  VerificationContext validateIntegrity(Insertable<IngredientTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recette_name')) {
      context.handle(
          _recetteNameMeta,
          recetteName.isAcceptableOrUnknown(
              data['recette_name']!, _recetteNameMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recetteName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recette_name']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
    );
  }

  @override
  $IngredientTable createAlias(String alias) {
    return $IngredientTable(attachedDatabase, alias);
  }
}

class IngredientTable extends DataClass implements Insertable<IngredientTable> {
  final int id;
  final String? recetteName;
  final String name;
  final int quantity;
  final String unit;
  const IngredientTable(
      {required this.id,
      this.recetteName,
      required this.name,
      required this.quantity,
      required this.unit});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || recetteName != null) {
      map['recette_name'] = Variable<String>(recetteName);
    }
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    map['unit'] = Variable<String>(unit);
    return map;
  }

  IngredientCompanion toCompanion(bool nullToAbsent) {
    return IngredientCompanion(
      id: Value(id),
      recetteName: recetteName == null && nullToAbsent
          ? const Value.absent()
          : Value(recetteName),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
    );
  }

  factory IngredientTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientTable(
      id: serializer.fromJson<int>(json['id']),
      recetteName: serializer.fromJson<String?>(json['recetteName']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recetteName': serializer.toJson<String?>(recetteName),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'unit': serializer.toJson<String>(unit),
    };
  }

  IngredientTable copyWith(
          {int? id,
          Value<String?> recetteName = const Value.absent(),
          String? name,
          int? quantity,
          String? unit}) =>
      IngredientTable(
        id: id ?? this.id,
        recetteName: recetteName.present ? recetteName.value : this.recetteName,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
      );
  @override
  String toString() {
    return (StringBuffer('IngredientTable(')
          ..write('id: $id, ')
          ..write('recetteName: $recetteName, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recetteName, name, quantity, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientTable &&
          other.id == this.id &&
          other.recetteName == this.recetteName &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit);
}

class IngredientCompanion extends UpdateCompanion<IngredientTable> {
  final Value<int> id;
  final Value<String?> recetteName;
  final Value<String> name;
  final Value<int> quantity;
  final Value<String> unit;
  const IngredientCompanion({
    this.id = const Value.absent(),
    this.recetteName = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
  });
  IngredientCompanion.insert({
    this.id = const Value.absent(),
    this.recetteName = const Value.absent(),
    required String name,
    required int quantity,
    required String unit,
  })  : name = Value(name),
        quantity = Value(quantity),
        unit = Value(unit);
  static Insertable<IngredientTable> custom({
    Expression<int>? id,
    Expression<String>? recetteName,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<String>? unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recetteName != null) 'recette_name': recetteName,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
    });
  }

  IngredientCompanion copyWith(
      {Value<int>? id,
      Value<String?>? recetteName,
      Value<String>? name,
      Value<int>? quantity,
      Value<String>? unit}) {
    return IngredientCompanion(
      id: id ?? this.id,
      recetteName: recetteName ?? this.recetteName,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recetteName.present) {
      map['recette_name'] = Variable<String>(recetteName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCompanion(')
          ..write('id: $id, ')
          ..write('recetteName: $recetteName, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $RecetteTable recette = $RecetteTable(this);
  late final $IngredientTable ingredient = $IngredientTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [recette, ingredient];
}

mixin _$AppDatabaseAccessorMixin on DatabaseAccessor<AppDatabase> {
  $RecetteTable get recette => attachedDatabase.recette;
  $IngredientTable get ingredient => attachedDatabase.ingredient;
}
