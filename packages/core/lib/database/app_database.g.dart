// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RestaurantConfigTable extends RestaurantConfig
    with TableInfo<$RestaurantConfigTable, RestaurantConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestaurantConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iceMeta = const VerificationMeta('ice');
  @override
  late final GeneratedColumn<String> ice = GeneratedColumn<String>(
    'ice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rcMeta = const VerificationMeta('rc');
  @override
  late final GeneratedColumn<String> rc = GeneratedColumn<String>(
    'rc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identifiantFiscalMeta = const VerificationMeta(
    'identifiantFiscal',
  );
  @override
  late final GeneratedColumn<String> identifiantFiscal =
      GeneratedColumn<String>(
        'identifiant_fiscal',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MAD'),
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultServiceModeMeta =
      const VerificationMeta('defaultServiceMode');
  @override
  late final GeneratedColumn<String> defaultServiceMode =
      GeneratedColumn<String>(
        'default_service_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('TABLE_SERVICE'),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    phone,
    ice,
    rc,
    identifiantFiscal,
    currency,
    logoPath,
    defaultServiceMode,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restaurant_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestaurantConfigData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('ice')) {
      context.handle(
        _iceMeta,
        ice.isAcceptableOrUnknown(data['ice']!, _iceMeta),
      );
    }
    if (data.containsKey('rc')) {
      context.handle(_rcMeta, rc.isAcceptableOrUnknown(data['rc']!, _rcMeta));
    }
    if (data.containsKey('identifiant_fiscal')) {
      context.handle(
        _identifiantFiscalMeta,
        identifiantFiscal.isAcceptableOrUnknown(
          data['identifiant_fiscal']!,
          _identifiantFiscalMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('default_service_mode')) {
      context.handle(
        _defaultServiceModeMeta,
        defaultServiceMode.isAcceptableOrUnknown(
          data['default_service_mode']!,
          _defaultServiceModeMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantConfigData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      ice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ice'],
      ),
      rc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rc'],
      ),
      identifiantFiscal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifiant_fiscal'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      defaultServiceMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_service_mode'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RestaurantConfigTable createAlias(String alias) {
    return $RestaurantConfigTable(attachedDatabase, alias);
  }
}

class RestaurantConfigData extends DataClass
    implements Insertable<RestaurantConfigData> {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? ice;
  final String? rc;
  final String? identifiantFiscal;
  final String currency;
  final String? logoPath;
  final String defaultServiceMode;
  final DateTime updatedAt;
  const RestaurantConfigData({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.ice,
    this.rc,
    this.identifiantFiscal,
    required this.currency,
    this.logoPath,
    required this.defaultServiceMode,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || ice != null) {
      map['ice'] = Variable<String>(ice);
    }
    if (!nullToAbsent || rc != null) {
      map['rc'] = Variable<String>(rc);
    }
    if (!nullToAbsent || identifiantFiscal != null) {
      map['identifiant_fiscal'] = Variable<String>(identifiantFiscal);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['default_service_mode'] = Variable<String>(defaultServiceMode);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RestaurantConfigCompanion toCompanion(bool nullToAbsent) {
    return RestaurantConfigCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      ice: ice == null && nullToAbsent ? const Value.absent() : Value(ice),
      rc: rc == null && nullToAbsent ? const Value.absent() : Value(rc),
      identifiantFiscal: identifiantFiscal == null && nullToAbsent
          ? const Value.absent()
          : Value(identifiantFiscal),
      currency: Value(currency),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      defaultServiceMode: Value(defaultServiceMode),
      updatedAt: Value(updatedAt),
    );
  }

  factory RestaurantConfigData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantConfigData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      ice: serializer.fromJson<String?>(json['ice']),
      rc: serializer.fromJson<String?>(json['rc']),
      identifiantFiscal: serializer.fromJson<String?>(
        json['identifiantFiscal'],
      ),
      currency: serializer.fromJson<String>(json['currency']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      defaultServiceMode: serializer.fromJson<String>(
        json['defaultServiceMode'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'ice': serializer.toJson<String?>(ice),
      'rc': serializer.toJson<String?>(rc),
      'identifiantFiscal': serializer.toJson<String?>(identifiantFiscal),
      'currency': serializer.toJson<String>(currency),
      'logoPath': serializer.toJson<String?>(logoPath),
      'defaultServiceMode': serializer.toJson<String>(defaultServiceMode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RestaurantConfigData copyWith({
    String? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> ice = const Value.absent(),
    Value<String?> rc = const Value.absent(),
    Value<String?> identifiantFiscal = const Value.absent(),
    String? currency,
    Value<String?> logoPath = const Value.absent(),
    String? defaultServiceMode,
    DateTime? updatedAt,
  }) => RestaurantConfigData(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    ice: ice.present ? ice.value : this.ice,
    rc: rc.present ? rc.value : this.rc,
    identifiantFiscal: identifiantFiscal.present
        ? identifiantFiscal.value
        : this.identifiantFiscal,
    currency: currency ?? this.currency,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    defaultServiceMode: defaultServiceMode ?? this.defaultServiceMode,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RestaurantConfigData copyWithCompanion(RestaurantConfigCompanion data) {
    return RestaurantConfigData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      ice: data.ice.present ? data.ice.value : this.ice,
      rc: data.rc.present ? data.rc.value : this.rc,
      identifiantFiscal: data.identifiantFiscal.present
          ? data.identifiantFiscal.value
          : this.identifiantFiscal,
      currency: data.currency.present ? data.currency.value : this.currency,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      defaultServiceMode: data.defaultServiceMode.present
          ? data.defaultServiceMode.value
          : this.defaultServiceMode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantConfigData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('ice: $ice, ')
          ..write('rc: $rc, ')
          ..write('identifiantFiscal: $identifiantFiscal, ')
          ..write('currency: $currency, ')
          ..write('logoPath: $logoPath, ')
          ..write('defaultServiceMode: $defaultServiceMode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    phone,
    ice,
    rc,
    identifiantFiscal,
    currency,
    logoPath,
    defaultServiceMode,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantConfigData &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.ice == this.ice &&
          other.rc == this.rc &&
          other.identifiantFiscal == this.identifiantFiscal &&
          other.currency == this.currency &&
          other.logoPath == this.logoPath &&
          other.defaultServiceMode == this.defaultServiceMode &&
          other.updatedAt == this.updatedAt);
}

class RestaurantConfigCompanion extends UpdateCompanion<RestaurantConfigData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> ice;
  final Value<String?> rc;
  final Value<String?> identifiantFiscal;
  final Value<String> currency;
  final Value<String?> logoPath;
  final Value<String> defaultServiceMode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RestaurantConfigCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.ice = const Value.absent(),
    this.rc = const Value.absent(),
    this.identifiantFiscal = const Value.absent(),
    this.currency = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.defaultServiceMode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestaurantConfigCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.ice = const Value.absent(),
    this.rc = const Value.absent(),
    this.identifiantFiscal = const Value.absent(),
    this.currency = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.defaultServiceMode = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<RestaurantConfigData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? ice,
    Expression<String>? rc,
    Expression<String>? identifiantFiscal,
    Expression<String>? currency,
    Expression<String>? logoPath,
    Expression<String>? defaultServiceMode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (ice != null) 'ice': ice,
      if (rc != null) 'rc': rc,
      if (identifiantFiscal != null) 'identifiant_fiscal': identifiantFiscal,
      if (currency != null) 'currency': currency,
      if (logoPath != null) 'logo_path': logoPath,
      if (defaultServiceMode != null)
        'default_service_mode': defaultServiceMode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestaurantConfigCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? ice,
    Value<String?>? rc,
    Value<String?>? identifiantFiscal,
    Value<String>? currency,
    Value<String?>? logoPath,
    Value<String>? defaultServiceMode,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RestaurantConfigCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      ice: ice ?? this.ice,
      rc: rc ?? this.rc,
      identifiantFiscal: identifiantFiscal ?? this.identifiantFiscal,
      currency: currency ?? this.currency,
      logoPath: logoPath ?? this.logoPath,
      defaultServiceMode: defaultServiceMode ?? this.defaultServiceMode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (ice.present) {
      map['ice'] = Variable<String>(ice.value);
    }
    if (rc.present) {
      map['rc'] = Variable<String>(rc.value);
    }
    if (identifiantFiscal.present) {
      map['identifiant_fiscal'] = Variable<String>(identifiantFiscal.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (defaultServiceMode.present) {
      map['default_service_mode'] = Variable<String>(defaultServiceMode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantConfigCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('ice: $ice, ')
          ..write('rc: $rc, ')
          ..write('identifiantFiscal: $identifiantFiscal, ')
          ..write('currency: $currency, ')
          ..write('logoPath: $logoPath, ')
          ..write('defaultServiceMode: $defaultServiceMode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accessLevelMeta = const VerificationMeta(
    'accessLevel',
  );
  @override
  late final GeneratedColumn<int> accessLevel = GeneratedColumn<int>(
    'access_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    pinHash,
    role,
    accessLevel,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('access_level')) {
      context.handle(
        _accessLevelMeta,
        accessLevel.isAcceptableOrUnknown(
          data['access_level']!,
          _accessLevelMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      accessLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}access_level'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String pinHash;
  final String role;
  final int accessLevel;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const User({
    required this.id,
    required this.name,
    required this.pinHash,
    required this.role,
    required this.accessLevel,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['pin_hash'] = Variable<String>(pinHash);
    map['role'] = Variable<String>(role);
    map['access_level'] = Variable<int>(accessLevel);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      pinHash: Value(pinHash),
      role: Value(role),
      accessLevel: Value(accessLevel),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      role: serializer.fromJson<String>(json['role']),
      accessLevel: serializer.fromJson<int>(json['accessLevel']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'pinHash': serializer.toJson<String>(pinHash),
      'role': serializer.toJson<String>(role),
      'accessLevel': serializer.toJson<int>(accessLevel),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? pinHash,
    String? role,
    int? accessLevel,
    bool? isActive,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    pinHash: pinHash ?? this.pinHash,
    role: role ?? this.role,
    accessLevel: accessLevel ?? this.accessLevel,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      role: data.role.present ? data.role.value : this.role,
      accessLevel: data.accessLevel.present
          ? data.accessLevel.value
          : this.accessLevel,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pinHash: $pinHash, ')
          ..write('role: $role, ')
          ..write('accessLevel: $accessLevel, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    pinHash,
    role,
    accessLevel,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.pinHash == this.pinHash &&
          other.role == this.role &&
          other.accessLevel == this.accessLevel &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> pinHash;
  final Value<String> role;
  final Value<int> accessLevel;
  final Value<bool> isActive;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.role = const Value.absent(),
    this.accessLevel = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String pinHash,
    required String role,
    this.accessLevel = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       pinHash = Value(pinHash),
       role = Value(role);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? pinHash,
    Expression<String>? role,
    Expression<int>? accessLevel,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pinHash != null) 'pin_hash': pinHash,
      if (role != null) 'role': role,
      if (accessLevel != null) 'access_level': accessLevel,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? pinHash,
    Value<String>? role,
    Value<int>? accessLevel,
    Value<bool>? isActive,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pinHash: pinHash ?? this.pinHash,
      role: role ?? this.role,
      accessLevel: accessLevel ?? this.accessLevel,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (accessLevel.present) {
      map['access_level'] = Variable<int>(accessLevel.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pinHash: $pinHash, ')
          ..write('role: $role, ')
          ..write('accessLevel: $accessLevel, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SecurityRulesTable extends SecurityRules
    with TableInfo<$SecurityRulesTable, SecurityRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SecurityRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationKeyMeta = const VerificationMeta(
    'operationKey',
  );
  @override
  late final GeneratedColumn<String> operationKey = GeneratedColumn<String>(
    'operation_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiredLevelMeta = const VerificationMeta(
    'requiredLevel',
  );
  @override
  late final GeneratedColumn<int> requiredLevel = GeneratedColumn<int>(
    'required_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationKey,
    category,
    label,
    requiredLevel,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'security_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<SecurityRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_key')) {
      context.handle(
        _operationKeyMeta,
        operationKey.isAcceptableOrUnknown(
          data['operation_key']!,
          _operationKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationKeyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('required_level')) {
      context.handle(
        _requiredLevelMeta,
        requiredLevel.isAcceptableOrUnknown(
          data['required_level']!,
          _requiredLevelMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationKey};
  @override
  SecurityRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SecurityRule(
      operationKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_key'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      requiredLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}required_level'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $SecurityRulesTable createAlias(String alias) {
    return $SecurityRulesTable(attachedDatabase, alias);
  }
}

class SecurityRule extends DataClass implements Insertable<SecurityRule> {
  final String operationKey;
  final String category;
  final String label;
  final int requiredLevel;
  final String? description;
  const SecurityRule({
    required this.operationKey,
    required this.category,
    required this.label,
    required this.requiredLevel,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_key'] = Variable<String>(operationKey);
    map['category'] = Variable<String>(category);
    map['label'] = Variable<String>(label);
    map['required_level'] = Variable<int>(requiredLevel);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  SecurityRulesCompanion toCompanion(bool nullToAbsent) {
    return SecurityRulesCompanion(
      operationKey: Value(operationKey),
      category: Value(category),
      label: Value(label),
      requiredLevel: Value(requiredLevel),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory SecurityRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SecurityRule(
      operationKey: serializer.fromJson<String>(json['operationKey']),
      category: serializer.fromJson<String>(json['category']),
      label: serializer.fromJson<String>(json['label']),
      requiredLevel: serializer.fromJson<int>(json['requiredLevel']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationKey': serializer.toJson<String>(operationKey),
      'category': serializer.toJson<String>(category),
      'label': serializer.toJson<String>(label),
      'requiredLevel': serializer.toJson<int>(requiredLevel),
      'description': serializer.toJson<String?>(description),
    };
  }

  SecurityRule copyWith({
    String? operationKey,
    String? category,
    String? label,
    int? requiredLevel,
    Value<String?> description = const Value.absent(),
  }) => SecurityRule(
    operationKey: operationKey ?? this.operationKey,
    category: category ?? this.category,
    label: label ?? this.label,
    requiredLevel: requiredLevel ?? this.requiredLevel,
    description: description.present ? description.value : this.description,
  );
  SecurityRule copyWithCompanion(SecurityRulesCompanion data) {
    return SecurityRule(
      operationKey: data.operationKey.present
          ? data.operationKey.value
          : this.operationKey,
      category: data.category.present ? data.category.value : this.category,
      label: data.label.present ? data.label.value : this.label,
      requiredLevel: data.requiredLevel.present
          ? data.requiredLevel.value
          : this.requiredLevel,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SecurityRule(')
          ..write('operationKey: $operationKey, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('requiredLevel: $requiredLevel, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(operationKey, category, label, requiredLevel, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecurityRule &&
          other.operationKey == this.operationKey &&
          other.category == this.category &&
          other.label == this.label &&
          other.requiredLevel == this.requiredLevel &&
          other.description == this.description);
}

class SecurityRulesCompanion extends UpdateCompanion<SecurityRule> {
  final Value<String> operationKey;
  final Value<String> category;
  final Value<String> label;
  final Value<int> requiredLevel;
  final Value<String?> description;
  final Value<int> rowid;
  const SecurityRulesCompanion({
    this.operationKey = const Value.absent(),
    this.category = const Value.absent(),
    this.label = const Value.absent(),
    this.requiredLevel = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SecurityRulesCompanion.insert({
    required String operationKey,
    required String category,
    required String label,
    this.requiredLevel = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationKey = Value(operationKey),
       category = Value(category),
       label = Value(label);
  static Insertable<SecurityRule> custom({
    Expression<String>? operationKey,
    Expression<String>? category,
    Expression<String>? label,
    Expression<int>? requiredLevel,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationKey != null) 'operation_key': operationKey,
      if (category != null) 'category': category,
      if (label != null) 'label': label,
      if (requiredLevel != null) 'required_level': requiredLevel,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SecurityRulesCompanion copyWith({
    Value<String>? operationKey,
    Value<String>? category,
    Value<String>? label,
    Value<int>? requiredLevel,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return SecurityRulesCompanion(
      operationKey: operationKey ?? this.operationKey,
      category: category ?? this.category,
      label: label ?? this.label,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationKey.present) {
      map['operation_key'] = Variable<String>(operationKey.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (requiredLevel.present) {
      map['required_level'] = Variable<int>(requiredLevel.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecurityRulesCompanion(')
          ..write('operationKey: $operationKey, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('requiredLevel: $requiredLevel, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZonesTable extends Zones with TableInfo<$ZonesTable, Zone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Zone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Zone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Zone(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ZonesTable createAlias(String alias) {
    return $ZonesTable(attachedDatabase, alias);
  }
}

class Zone extends DataClass implements Insertable<Zone> {
  final String id;
  final String name;
  final int sortOrder;
  const Zone({required this.id, required this.name, required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ZonesCompanion toCompanion(bool nullToAbsent) {
    return ZonesCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory Zone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Zone(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Zone copyWith({String? id, String? name, int? sortOrder}) => Zone(
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Zone copyWithCompanion(ZonesCompanion data) {
    return Zone(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Zone(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Zone &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class ZonesCompanion extends UpdateCompanion<Zone> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ZonesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZonesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Zone> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZonesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ZonesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZonesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RestaurantTablesTable extends RestaurantTables
    with TableInfo<$RestaurantTablesTable, RestaurantTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestaurantTablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<String> zoneId = GeneratedColumn<String>(
    'zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zones (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('FREE'),
  );
  static const VerificationMeta _posXMeta = const VerificationMeta('posX');
  @override
  late final GeneratedColumn<double> posX = GeneratedColumn<double>(
    'pos_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posYMeta = const VerificationMeta('posY');
  @override
  late final GeneratedColumn<double> posY = GeneratedColumn<double>(
    'pos_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    zoneId,
    name,
    capacity,
    status,
    posX,
    posY,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restaurant_tables';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestaurantTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone_id')) {
      context.handle(
        _zoneIdMeta,
        zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('pos_x')) {
      context.handle(
        _posXMeta,
        posX.isAcceptableOrUnknown(data['pos_x']!, _posXMeta),
      );
    }
    if (data.containsKey('pos_y')) {
      context.handle(
        _posYMeta,
        posY.isAcceptableOrUnknown(data['pos_y']!, _posYMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      zoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      posX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pos_x'],
      ),
      posY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pos_y'],
      ),
    );
  }

  @override
  $RestaurantTablesTable createAlias(String alias) {
    return $RestaurantTablesTable(attachedDatabase, alias);
  }
}

class RestaurantTable extends DataClass implements Insertable<RestaurantTable> {
  final String id;
  final String zoneId;
  final String name;
  final int capacity;
  final String status;
  final double? posX;
  final double? posY;
  const RestaurantTable({
    required this.id,
    required this.zoneId,
    required this.name,
    required this.capacity,
    required this.status,
    this.posX,
    this.posY,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['zone_id'] = Variable<String>(zoneId);
    map['name'] = Variable<String>(name);
    map['capacity'] = Variable<int>(capacity);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || posX != null) {
      map['pos_x'] = Variable<double>(posX);
    }
    if (!nullToAbsent || posY != null) {
      map['pos_y'] = Variable<double>(posY);
    }
    return map;
  }

  RestaurantTablesCompanion toCompanion(bool nullToAbsent) {
    return RestaurantTablesCompanion(
      id: Value(id),
      zoneId: Value(zoneId),
      name: Value(name),
      capacity: Value(capacity),
      status: Value(status),
      posX: posX == null && nullToAbsent ? const Value.absent() : Value(posX),
      posY: posY == null && nullToAbsent ? const Value.absent() : Value(posY),
    );
  }

  factory RestaurantTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantTable(
      id: serializer.fromJson<String>(json['id']),
      zoneId: serializer.fromJson<String>(json['zoneId']),
      name: serializer.fromJson<String>(json['name']),
      capacity: serializer.fromJson<int>(json['capacity']),
      status: serializer.fromJson<String>(json['status']),
      posX: serializer.fromJson<double?>(json['posX']),
      posY: serializer.fromJson<double?>(json['posY']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'zoneId': serializer.toJson<String>(zoneId),
      'name': serializer.toJson<String>(name),
      'capacity': serializer.toJson<int>(capacity),
      'status': serializer.toJson<String>(status),
      'posX': serializer.toJson<double?>(posX),
      'posY': serializer.toJson<double?>(posY),
    };
  }

  RestaurantTable copyWith({
    String? id,
    String? zoneId,
    String? name,
    int? capacity,
    String? status,
    Value<double?> posX = const Value.absent(),
    Value<double?> posY = const Value.absent(),
  }) => RestaurantTable(
    id: id ?? this.id,
    zoneId: zoneId ?? this.zoneId,
    name: name ?? this.name,
    capacity: capacity ?? this.capacity,
    status: status ?? this.status,
    posX: posX.present ? posX.value : this.posX,
    posY: posY.present ? posY.value : this.posY,
  );
  RestaurantTable copyWithCompanion(RestaurantTablesCompanion data) {
    return RestaurantTable(
      id: data.id.present ? data.id.value : this.id,
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      name: data.name.present ? data.name.value : this.name,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      posX: data.posX.present ? data.posX.value : this.posX,
      posY: data.posY.present ? data.posY.value : this.posY,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTable(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('name: $name, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, zoneId, name, capacity, status, posX, posY);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantTable &&
          other.id == this.id &&
          other.zoneId == this.zoneId &&
          other.name == this.name &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.posX == this.posX &&
          other.posY == this.posY);
}

class RestaurantTablesCompanion extends UpdateCompanion<RestaurantTable> {
  final Value<String> id;
  final Value<String> zoneId;
  final Value<String> name;
  final Value<int> capacity;
  final Value<String> status;
  final Value<double?> posX;
  final Value<double?> posY;
  final Value<int> rowid;
  const RestaurantTablesCompanion({
    this.id = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.name = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestaurantTablesCompanion.insert({
    this.id = const Value.absent(),
    required String zoneId,
    required String name,
    required int capacity,
    this.status = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : zoneId = Value(zoneId),
       name = Value(name),
       capacity = Value(capacity);
  static Insertable<RestaurantTable> custom({
    Expression<String>? id,
    Expression<String>? zoneId,
    Expression<String>? name,
    Expression<int>? capacity,
    Expression<String>? status,
    Expression<double>? posX,
    Expression<double>? posY,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zoneId != null) 'zone_id': zoneId,
      if (name != null) 'name': name,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (posX != null) 'pos_x': posX,
      if (posY != null) 'pos_y': posY,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestaurantTablesCompanion copyWith({
    Value<String>? id,
    Value<String>? zoneId,
    Value<String>? name,
    Value<int>? capacity,
    Value<String>? status,
    Value<double?>? posX,
    Value<double?>? posY,
    Value<int>? rowid,
  }) {
    return RestaurantTablesCompanion(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<String>(zoneId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (posX.present) {
      map['pos_x'] = Variable<double>(posX.value);
    }
    if (posY.present) {
      map['pos_y'] = Variable<double>(posY.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTablesCompanion(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('name: $name, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReservationsTable extends Reservations
    with TableInfo<$ReservationsTable, Reservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _tableIdMeta = const VerificationMeta(
    'tableId',
  );
  @override
  late final GeneratedColumn<String> tableId = GeneratedColumn<String>(
    'table_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES restaurant_tables (id)',
    ),
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guestCountMeta = const VerificationMeta(
    'guestCount',
  );
  @override
  late final GeneratedColumn<int> guestCount = GeneratedColumn<int>(
    'guest_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reservedAtMeta = const VerificationMeta(
    'reservedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reservedAt = GeneratedColumn<DateTime>(
    'reserved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CONFIRMED'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableId,
    customerName,
    customerPhone,
    guestCount,
    reservedAt,
    notes,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reservations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reservation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_id')) {
      context.handle(
        _tableIdMeta,
        tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tableIdMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('guest_count')) {
      context.handle(
        _guestCountMeta,
        guestCount.isAcceptableOrUnknown(data['guest_count']!, _guestCountMeta),
      );
    } else if (isInserting) {
      context.missing(_guestCountMeta);
    }
    if (data.containsKey('reserved_at')) {
      context.handle(
        _reservedAtMeta,
        reservedAt.isAcceptableOrUnknown(data['reserved_at']!, _reservedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reservedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reservation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tableId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      guestCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}guest_count'],
      )!,
      reservedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reserved_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReservationsTable createAlias(String alias) {
    return $ReservationsTable(attachedDatabase, alias);
  }
}

class Reservation extends DataClass implements Insertable<Reservation> {
  final String id;
  final String tableId;
  final String customerName;
  final String? customerPhone;
  final int guestCount;
  final DateTime reservedAt;
  final String? notes;
  final String status;
  final DateTime createdAt;
  const Reservation({
    required this.id,
    required this.tableId,
    required this.customerName,
    this.customerPhone,
    required this.guestCount,
    required this.reservedAt,
    this.notes,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['table_id'] = Variable<String>(tableId);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['guest_count'] = Variable<int>(guestCount);
    map['reserved_at'] = Variable<DateTime>(reservedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReservationsCompanion toCompanion(bool nullToAbsent) {
    return ReservationsCompanion(
      id: Value(id),
      tableId: Value(tableId),
      customerName: Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      guestCount: Value(guestCount),
      reservedAt: Value(reservedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Reservation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reservation(
      id: serializer.fromJson<String>(json['id']),
      tableId: serializer.fromJson<String>(json['tableId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      guestCount: serializer.fromJson<int>(json['guestCount']),
      reservedAt: serializer.fromJson<DateTime>(json['reservedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tableId': serializer.toJson<String>(tableId),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'guestCount': serializer.toJson<int>(guestCount),
      'reservedAt': serializer.toJson<DateTime>(reservedAt),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Reservation copyWith({
    String? id,
    String? tableId,
    String? customerName,
    Value<String?> customerPhone = const Value.absent(),
    int? guestCount,
    DateTime? reservedAt,
    Value<String?> notes = const Value.absent(),
    String? status,
    DateTime? createdAt,
  }) => Reservation(
    id: id ?? this.id,
    tableId: tableId ?? this.tableId,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    guestCount: guestCount ?? this.guestCount,
    reservedAt: reservedAt ?? this.reservedAt,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  Reservation copyWithCompanion(ReservationsCompanion data) {
    return Reservation(
      id: data.id.present ? data.id.value : this.id,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      guestCount: data.guestCount.present
          ? data.guestCount.value
          : this.guestCount,
      reservedAt: data.reservedAt.present
          ? data.reservedAt.value
          : this.reservedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reservation(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('guestCount: $guestCount, ')
          ..write('reservedAt: $reservedAt, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tableId,
    customerName,
    customerPhone,
    guestCount,
    reservedAt,
    notes,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reservation &&
          other.id == this.id &&
          other.tableId == this.tableId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.guestCount == this.guestCount &&
          other.reservedAt == this.reservedAt &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ReservationsCompanion extends UpdateCompanion<Reservation> {
  final Value<String> id;
  final Value<String> tableId;
  final Value<String> customerName;
  final Value<String?> customerPhone;
  final Value<int> guestCount;
  final Value<DateTime> reservedAt;
  final Value<String?> notes;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReservationsCompanion({
    this.id = const Value.absent(),
    this.tableId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.guestCount = const Value.absent(),
    this.reservedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservationsCompanion.insert({
    this.id = const Value.absent(),
    required String tableId,
    required String customerName,
    this.customerPhone = const Value.absent(),
    required int guestCount,
    required DateTime reservedAt,
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : tableId = Value(tableId),
       customerName = Value(customerName),
       guestCount = Value(guestCount),
       reservedAt = Value(reservedAt),
       createdAt = Value(createdAt);
  static Insertable<Reservation> custom({
    Expression<String>? id,
    Expression<String>? tableId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<int>? guestCount,
    Expression<DateTime>? reservedAt,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableId != null) 'table_id': tableId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (guestCount != null) 'guest_count': guestCount,
      if (reservedAt != null) 'reserved_at': reservedAt,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservationsCompanion copyWith({
    Value<String>? id,
    Value<String>? tableId,
    Value<String>? customerName,
    Value<String?>? customerPhone,
    Value<int>? guestCount,
    Value<DateTime>? reservedAt,
    Value<String?>? notes,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReservationsCompanion(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      guestCount: guestCount ?? this.guestCount,
      reservedAt: reservedAt ?? this.reservedAt,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<String>(tableId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (guestCount.present) {
      map['guest_count'] = Variable<int>(guestCount.value);
    }
    if (reservedAt.present) {
      map['reserved_at'] = Variable<DateTime>(reservedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservationsCompanion(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('guestCount: $guestCount, ')
          ..write('reservedAt: $reservedAt, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeAttendanceTable extends TimeAttendance
    with TableInfo<$TimeAttendanceTable, TimeAttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeAttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _clockInMeta = const VerificationMeta(
    'clockIn',
  );
  @override
  late final GeneratedColumn<DateTime> clockIn = GeneratedColumn<DateTime>(
    'clock_in',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockOutMeta = const VerificationMeta(
    'clockOut',
  );
  @override
  late final GeneratedColumn<DateTime> clockOut = GeneratedColumn<DateTime>(
    'clock_out',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    clockIn,
    clockOut,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_attendance';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeAttendanceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('clock_in')) {
      context.handle(
        _clockInMeta,
        clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta),
      );
    } else if (isInserting) {
      context.missing(_clockInMeta);
    }
    if (data.containsKey('clock_out')) {
      context.handle(
        _clockOutMeta,
        clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeAttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeAttendanceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      clockIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clock_in'],
      )!,
      clockOut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clock_out'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TimeAttendanceTable createAlias(String alias) {
    return $TimeAttendanceTable(attachedDatabase, alias);
  }
}

class TimeAttendanceData extends DataClass
    implements Insertable<TimeAttendanceData> {
  final String id;
  final String userId;
  final DateTime clockIn;
  final DateTime? clockOut;
  final String? notes;
  final DateTime createdAt;
  const TimeAttendanceData({
    required this.id,
    required this.userId,
    required this.clockIn,
    this.clockOut,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['clock_in'] = Variable<DateTime>(clockIn);
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<DateTime>(clockOut);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TimeAttendanceCompanion toCompanion(bool nullToAbsent) {
    return TimeAttendanceCompanion(
      id: Value(id),
      userId: Value(userId),
      clockIn: Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory TimeAttendanceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeAttendanceData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      clockIn: serializer.fromJson<DateTime>(json['clockIn']),
      clockOut: serializer.fromJson<DateTime?>(json['clockOut']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'clockIn': serializer.toJson<DateTime>(clockIn),
      'clockOut': serializer.toJson<DateTime?>(clockOut),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TimeAttendanceData copyWith({
    String? id,
    String? userId,
    DateTime? clockIn,
    Value<DateTime?> clockOut = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => TimeAttendanceData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    clockIn: clockIn ?? this.clockIn,
    clockOut: clockOut.present ? clockOut.value : this.clockOut,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  TimeAttendanceData copyWithCompanion(TimeAttendanceCompanion data) {
    return TimeAttendanceData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeAttendanceData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, clockIn, clockOut, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeAttendanceData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TimeAttendanceCompanion extends UpdateCompanion<TimeAttendanceData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> clockIn;
  final Value<DateTime?> clockOut;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TimeAttendanceCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeAttendanceCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime clockIn,
    this.clockOut = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       clockIn = Value(clockIn),
       createdAt = Value(createdAt);
  static Insertable<TimeAttendanceData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? clockIn,
    Expression<DateTime>? clockOut,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeAttendanceCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? clockIn,
    Value<DateTime?>? clockOut,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TimeAttendanceCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<DateTime>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<DateTime>(clockOut.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeAttendanceCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrintStationsTable extends PrintStations
    with TableInfo<$PrintStationsTable, PrintStation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrintStationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ipAddressMeta = const VerificationMeta(
    'ipAddress',
  );
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
    'ip_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('THERMAL_PRINTER'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, ipAddress, type, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'print_stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrintStation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ip_address')) {
      context.handle(
        _ipAddressMeta,
        ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrintStation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrintStation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ipAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ip_address'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $PrintStationsTable createAlias(String alias) {
    return $PrintStationsTable(attachedDatabase, alias);
  }
}

class PrintStation extends DataClass implements Insertable<PrintStation> {
  final String id;
  final String name;
  final String? ipAddress;
  final String type;
  final bool isActive;
  const PrintStation({
    required this.id,
    required this.name,
    this.ipAddress,
    required this.type,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    map['type'] = Variable<String>(type);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PrintStationsCompanion toCompanion(bool nullToAbsent) {
    return PrintStationsCompanion(
      id: Value(id),
      name: Value(name),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      type: Value(type),
      isActive: Value(isActive),
    );
  }

  factory PrintStation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrintStation(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      type: serializer.fromJson<String>(json['type']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'type': serializer.toJson<String>(type),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PrintStation copyWith({
    String? id,
    String? name,
    Value<String?> ipAddress = const Value.absent(),
    String? type,
    bool? isActive,
  }) => PrintStation(
    id: id ?? this.id,
    name: name ?? this.name,
    ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
    type: type ?? this.type,
    isActive: isActive ?? this.isActive,
  );
  PrintStation copyWithCompanion(PrintStationsCompanion data) {
    return PrintStation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      type: data.type.present ? data.type.value : this.type,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrintStation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('type: $type, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, ipAddress, type, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrintStation &&
          other.id == this.id &&
          other.name == this.name &&
          other.ipAddress == this.ipAddress &&
          other.type == this.type &&
          other.isActive == this.isActive);
}

class PrintStationsCompanion extends UpdateCompanion<PrintStation> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> ipAddress;
  final Value<String> type;
  final Value<bool> isActive;
  final Value<int> rowid;
  const PrintStationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.type = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrintStationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.ipAddress = const Value.absent(),
    this.type = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PrintStation> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? ipAddress,
    Expression<String>? type,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (type != null) 'type': type,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrintStationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? ipAddress,
    Value<String>? type,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return PrintStationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrintStationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('type: $type, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _printStationIdMeta = const VerificationMeta(
    'printStationId',
  );
  @override
  late final GeneratedColumn<String> printStationId = GeneratedColumn<String>(
    'print_station_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES print_stations (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scheduledStartTimeMeta =
      const VerificationMeta('scheduledStartTime');
  @override
  late final GeneratedColumn<String> scheduledStartTime =
      GeneratedColumn<String>(
        'scheduled_start_time',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _scheduledEndTimeMeta = const VerificationMeta(
    'scheduledEndTime',
  );
  @override
  late final GeneratedColumn<String> scheduledEndTime = GeneratedColumn<String>(
    'scheduled_end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameAr,
    image,
    colorHex,
    printStationId,
    sortOrder,
    scheduledStartTime,
    scheduledEndTime,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('print_station_id')) {
      context.handle(
        _printStationIdMeta,
        printStationId.isAcceptableOrUnknown(
          data['print_station_id']!,
          _printStationIdMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('scheduled_start_time')) {
      context.handle(
        _scheduledStartTimeMeta,
        scheduledStartTime.isAcceptableOrUnknown(
          data['scheduled_start_time']!,
          _scheduledStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_end_time')) {
      context.handle(
        _scheduledEndTimeMeta,
        scheduledEndTime.isAcceptableOrUnknown(
          data['scheduled_end_time']!,
          _scheduledEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      printStationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}print_station_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      scheduledStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_start_time'],
      ),
      scheduledEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_end_time'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String? nameAr;
  final String? image;
  final String? colorHex;
  final String? printStationId;
  final int sortOrder;
  final String? scheduledStartTime;
  final String? scheduledEndTime;
  final bool isActive;
  const Category({
    required this.id,
    required this.name,
    this.nameAr,
    this.image,
    this.colorHex,
    this.printStationId,
    required this.sortOrder,
    this.scheduledStartTime,
    this.scheduledEndTime,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    if (!nullToAbsent || printStationId != null) {
      map['print_station_id'] = Variable<String>(printStationId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || scheduledStartTime != null) {
      map['scheduled_start_time'] = Variable<String>(scheduledStartTime);
    }
    if (!nullToAbsent || scheduledEndTime != null) {
      map['scheduled_end_time'] = Variable<String>(scheduledEndTime);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      printStationId: printStationId == null && nullToAbsent
          ? const Value.absent()
          : Value(printStationId),
      sortOrder: Value(sortOrder),
      scheduledStartTime: scheduledStartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledStartTime),
      scheduledEndTime: scheduledEndTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledEndTime),
      isActive: Value(isActive),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      image: serializer.fromJson<String?>(json['image']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      printStationId: serializer.fromJson<String?>(json['printStationId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      scheduledStartTime: serializer.fromJson<String?>(
        json['scheduledStartTime'],
      ),
      scheduledEndTime: serializer.fromJson<String?>(json['scheduledEndTime']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'image': serializer.toJson<String?>(image),
      'colorHex': serializer.toJson<String?>(colorHex),
      'printStationId': serializer.toJson<String?>(printStationId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'scheduledStartTime': serializer.toJson<String?>(scheduledStartTime),
      'scheduledEndTime': serializer.toJson<String?>(scheduledEndTime),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    Value<String?> nameAr = const Value.absent(),
    Value<String?> image = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    Value<String?> printStationId = const Value.absent(),
    int? sortOrder,
    Value<String?> scheduledStartTime = const Value.absent(),
    Value<String?> scheduledEndTime = const Value.absent(),
    bool? isActive,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    image: image.present ? image.value : this.image,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    printStationId: printStationId.present
        ? printStationId.value
        : this.printStationId,
    sortOrder: sortOrder ?? this.sortOrder,
    scheduledStartTime: scheduledStartTime.present
        ? scheduledStartTime.value
        : this.scheduledStartTime,
    scheduledEndTime: scheduledEndTime.present
        ? scheduledEndTime.value
        : this.scheduledEndTime,
    isActive: isActive ?? this.isActive,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      image: data.image.present ? data.image.value : this.image,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      printStationId: data.printStationId.present
          ? data.printStationId.value
          : this.printStationId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      scheduledStartTime: data.scheduledStartTime.present
          ? data.scheduledStartTime.value
          : this.scheduledStartTime,
      scheduledEndTime: data.scheduledEndTime.present
          ? data.scheduledEndTime.value
          : this.scheduledEndTime,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('image: $image, ')
          ..write('colorHex: $colorHex, ')
          ..write('printStationId: $printStationId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('scheduledStartTime: $scheduledStartTime, ')
          ..write('scheduledEndTime: $scheduledEndTime, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameAr,
    image,
    colorHex,
    printStationId,
    sortOrder,
    scheduledStartTime,
    scheduledEndTime,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.image == this.image &&
          other.colorHex == this.colorHex &&
          other.printStationId == this.printStationId &&
          other.sortOrder == this.sortOrder &&
          other.scheduledStartTime == this.scheduledStartTime &&
          other.scheduledEndTime == this.scheduledEndTime &&
          other.isActive == this.isActive);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<String?> image;
  final Value<String?> colorHex;
  final Value<String?> printStationId;
  final Value<int> sortOrder;
  final Value<String?> scheduledStartTime;
  final Value<String?> scheduledEndTime;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.image = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.printStationId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.scheduledStartTime = const Value.absent(),
    this.scheduledEndTime = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameAr = const Value.absent(),
    this.image = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.printStationId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.scheduledStartTime = const Value.absent(),
    this.scheduledEndTime = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? image,
    Expression<String>? colorHex,
    Expression<String>? printStationId,
    Expression<int>? sortOrder,
    Expression<String>? scheduledStartTime,
    Expression<String>? scheduledEndTime,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (image != null) 'image': image,
      if (colorHex != null) 'color_hex': colorHex,
      if (printStationId != null) 'print_station_id': printStationId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (scheduledStartTime != null)
        'scheduled_start_time': scheduledStartTime,
      if (scheduledEndTime != null) 'scheduled_end_time': scheduledEndTime,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<String?>? image,
    Value<String?>? colorHex,
    Value<String?>? printStationId,
    Value<int>? sortOrder,
    Value<String?>? scheduledStartTime,
    Value<String?>? scheduledEndTime,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      image: image ?? this.image,
      colorHex: colorHex ?? this.colorHex,
      printStationId: printStationId ?? this.printStationId,
      sortOrder: sortOrder ?? this.sortOrder,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      scheduledEndTime: scheduledEndTime ?? this.scheduledEndTime,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (printStationId.present) {
      map['print_station_id'] = Variable<String>(printStationId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (scheduledStartTime.present) {
      map['scheduled_start_time'] = Variable<String>(scheduledStartTime.value);
    }
    if (scheduledEndTime.present) {
      map['scheduled_end_time'] = Variable<String>(scheduledEndTime.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('image: $image, ')
          ..write('colorHex: $colorHex, ')
          ..write('printStationId: $printStationId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('scheduledStartTime: $scheduledStartTime, ')
          ..write('scheduledEndTime: $scheduledEndTime, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceDineInMeta = const VerificationMeta(
    'priceDineIn',
  );
  @override
  late final GeneratedColumn<double> priceDineIn = GeneratedColumn<double>(
    'price_dine_in',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceTakeawayMeta = const VerificationMeta(
    'priceTakeaway',
  );
  @override
  late final GeneratedColumn<double> priceTakeaway = GeneratedColumn<double>(
    'price_takeaway',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceDeliveryMeta = const VerificationMeta(
    'priceDelivery',
  );
  @override
  late final GeneratedColumn<double> priceDelivery = GeneratedColumn<double>(
    'price_delivery',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(20.0),
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultNotesMeta = const VerificationMeta(
    'defaultNotes',
  );
  @override
  late final GeneratedColumn<String> defaultNotes = GeneratedColumn<String>(
    'default_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackStockMeta = const VerificationMeta(
    'trackStock',
  );
  @override
  late final GeneratedColumn<bool> trackStock = GeneratedColumn<bool>(
    'track_stock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("track_stock" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currentStockMeta = const VerificationMeta(
    'currentStock',
  );
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
    'current_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _productTypeMeta = const VerificationMeta(
    'productType',
  );
  @override
  late final GeneratedColumn<String> productType = GeneratedColumn<String>(
    'product_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('standard'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    name,
    nameAr,
    barcode,
    priceDineIn,
    priceTakeaway,
    priceDelivery,
    cost,
    taxRate,
    image,
    defaultNotes,
    trackStock,
    currentStock,
    productType,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('price_dine_in')) {
      context.handle(
        _priceDineInMeta,
        priceDineIn.isAcceptableOrUnknown(
          data['price_dine_in']!,
          _priceDineInMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priceDineInMeta);
    }
    if (data.containsKey('price_takeaway')) {
      context.handle(
        _priceTakeawayMeta,
        priceTakeaway.isAcceptableOrUnknown(
          data['price_takeaway']!,
          _priceTakeawayMeta,
        ),
      );
    }
    if (data.containsKey('price_delivery')) {
      context.handle(
        _priceDeliveryMeta,
        priceDelivery.isAcceptableOrUnknown(
          data['price_delivery']!,
          _priceDeliveryMeta,
        ),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('default_notes')) {
      context.handle(
        _defaultNotesMeta,
        defaultNotes.isAcceptableOrUnknown(
          data['default_notes']!,
          _defaultNotesMeta,
        ),
      );
    }
    if (data.containsKey('track_stock')) {
      context.handle(
        _trackStockMeta,
        trackStock.isAcceptableOrUnknown(data['track_stock']!, _trackStockMeta),
      );
    }
    if (data.containsKey('current_stock')) {
      context.handle(
        _currentStockMeta,
        currentStock.isAcceptableOrUnknown(
          data['current_stock']!,
          _currentStockMeta,
        ),
      );
    }
    if (data.containsKey('product_type')) {
      context.handle(
        _productTypeMeta,
        productType.isAcceptableOrUnknown(
          data['product_type']!,
          _productTypeMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      priceDineIn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_dine_in'],
      )!,
      priceTakeaway: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_takeaway'],
      ),
      priceDelivery: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_delivery'],
      ),
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      ),
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      defaultNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_notes'],
      ),
      trackStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}track_stock'],
      )!,
      currentStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_stock'],
      )!,
      productType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_type'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String categoryId;
  final String name;
  final String? nameAr;
  final String? barcode;
  final double priceDineIn;
  final double? priceTakeaway;
  final double? priceDelivery;
  final double? cost;
  final double taxRate;
  final String? image;
  final String? defaultNotes;
  final bool trackStock;
  final double currentStock;
  final String productType;
  final int sortOrder;
  final bool isActive;
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    this.nameAr,
    this.barcode,
    required this.priceDineIn,
    this.priceTakeaway,
    this.priceDelivery,
    this.cost,
    required this.taxRate,
    this.image,
    this.defaultNotes,
    required this.trackStock,
    required this.currentStock,
    required this.productType,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['price_dine_in'] = Variable<double>(priceDineIn);
    if (!nullToAbsent || priceTakeaway != null) {
      map['price_takeaway'] = Variable<double>(priceTakeaway);
    }
    if (!nullToAbsent || priceDelivery != null) {
      map['price_delivery'] = Variable<double>(priceDelivery);
    }
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    map['tax_rate'] = Variable<double>(taxRate);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || defaultNotes != null) {
      map['default_notes'] = Variable<String>(defaultNotes);
    }
    map['track_stock'] = Variable<bool>(trackStock);
    map['current_stock'] = Variable<double>(currentStock);
    map['product_type'] = Variable<String>(productType);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      priceDineIn: Value(priceDineIn),
      priceTakeaway: priceTakeaway == null && nullToAbsent
          ? const Value.absent()
          : Value(priceTakeaway),
      priceDelivery: priceDelivery == null && nullToAbsent
          ? const Value.absent()
          : Value(priceDelivery),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      taxRate: Value(taxRate),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      defaultNotes: defaultNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultNotes),
      trackStock: Value(trackStock),
      currentStock: Value(currentStock),
      productType: Value(productType),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      priceDineIn: serializer.fromJson<double>(json['priceDineIn']),
      priceTakeaway: serializer.fromJson<double?>(json['priceTakeaway']),
      priceDelivery: serializer.fromJson<double?>(json['priceDelivery']),
      cost: serializer.fromJson<double?>(json['cost']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      image: serializer.fromJson<String?>(json['image']),
      defaultNotes: serializer.fromJson<String?>(json['defaultNotes']),
      trackStock: serializer.fromJson<bool>(json['trackStock']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      productType: serializer.fromJson<String>(json['productType']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'barcode': serializer.toJson<String?>(barcode),
      'priceDineIn': serializer.toJson<double>(priceDineIn),
      'priceTakeaway': serializer.toJson<double?>(priceTakeaway),
      'priceDelivery': serializer.toJson<double?>(priceDelivery),
      'cost': serializer.toJson<double?>(cost),
      'taxRate': serializer.toJson<double>(taxRate),
      'image': serializer.toJson<String?>(image),
      'defaultNotes': serializer.toJson<String?>(defaultNotes),
      'trackStock': serializer.toJson<bool>(trackStock),
      'currentStock': serializer.toJson<double>(currentStock),
      'productType': serializer.toJson<String>(productType),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Product copyWith({
    String? id,
    String? categoryId,
    String? name,
    Value<String?> nameAr = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    double? priceDineIn,
    Value<double?> priceTakeaway = const Value.absent(),
    Value<double?> priceDelivery = const Value.absent(),
    Value<double?> cost = const Value.absent(),
    double? taxRate,
    Value<String?> image = const Value.absent(),
    Value<String?> defaultNotes = const Value.absent(),
    bool? trackStock,
    double? currentStock,
    String? productType,
    int? sortOrder,
    bool? isActive,
  }) => Product(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    barcode: barcode.present ? barcode.value : this.barcode,
    priceDineIn: priceDineIn ?? this.priceDineIn,
    priceTakeaway: priceTakeaway.present
        ? priceTakeaway.value
        : this.priceTakeaway,
    priceDelivery: priceDelivery.present
        ? priceDelivery.value
        : this.priceDelivery,
    cost: cost.present ? cost.value : this.cost,
    taxRate: taxRate ?? this.taxRate,
    image: image.present ? image.value : this.image,
    defaultNotes: defaultNotes.present ? defaultNotes.value : this.defaultNotes,
    trackStock: trackStock ?? this.trackStock,
    currentStock: currentStock ?? this.currentStock,
    productType: productType ?? this.productType,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      priceDineIn: data.priceDineIn.present
          ? data.priceDineIn.value
          : this.priceDineIn,
      priceTakeaway: data.priceTakeaway.present
          ? data.priceTakeaway.value
          : this.priceTakeaway,
      priceDelivery: data.priceDelivery.present
          ? data.priceDelivery.value
          : this.priceDelivery,
      cost: data.cost.present ? data.cost.value : this.cost,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      image: data.image.present ? data.image.value : this.image,
      defaultNotes: data.defaultNotes.present
          ? data.defaultNotes.value
          : this.defaultNotes,
      trackStock: data.trackStock.present
          ? data.trackStock.value
          : this.trackStock,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      productType: data.productType.present
          ? data.productType.value
          : this.productType,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('barcode: $barcode, ')
          ..write('priceDineIn: $priceDineIn, ')
          ..write('priceTakeaway: $priceTakeaway, ')
          ..write('priceDelivery: $priceDelivery, ')
          ..write('cost: $cost, ')
          ..write('taxRate: $taxRate, ')
          ..write('image: $image, ')
          ..write('defaultNotes: $defaultNotes, ')
          ..write('trackStock: $trackStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('productType: $productType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    name,
    nameAr,
    barcode,
    priceDineIn,
    priceTakeaway,
    priceDelivery,
    cost,
    taxRate,
    image,
    defaultNotes,
    trackStock,
    currentStock,
    productType,
    sortOrder,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.barcode == this.barcode &&
          other.priceDineIn == this.priceDineIn &&
          other.priceTakeaway == this.priceTakeaway &&
          other.priceDelivery == this.priceDelivery &&
          other.cost == this.cost &&
          other.taxRate == this.taxRate &&
          other.image == this.image &&
          other.defaultNotes == this.defaultNotes &&
          other.trackStock == this.trackStock &&
          other.currentStock == this.currentStock &&
          other.productType == this.productType &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<String?> barcode;
  final Value<double> priceDineIn;
  final Value<double?> priceTakeaway;
  final Value<double?> priceDelivery;
  final Value<double?> cost;
  final Value<double> taxRate;
  final Value<String?> image;
  final Value<String?> defaultNotes;
  final Value<bool> trackStock;
  final Value<double> currentStock;
  final Value<String> productType;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.barcode = const Value.absent(),
    this.priceDineIn = const Value.absent(),
    this.priceTakeaway = const Value.absent(),
    this.priceDelivery = const Value.absent(),
    this.cost = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.image = const Value.absent(),
    this.defaultNotes = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.productType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String categoryId,
    required String name,
    this.nameAr = const Value.absent(),
    this.barcode = const Value.absent(),
    required double priceDineIn,
    this.priceTakeaway = const Value.absent(),
    this.priceDelivery = const Value.absent(),
    this.cost = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.image = const Value.absent(),
    this.defaultNotes = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.productType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : categoryId = Value(categoryId),
       name = Value(name),
       priceDineIn = Value(priceDineIn);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? barcode,
    Expression<double>? priceDineIn,
    Expression<double>? priceTakeaway,
    Expression<double>? priceDelivery,
    Expression<double>? cost,
    Expression<double>? taxRate,
    Expression<String>? image,
    Expression<String>? defaultNotes,
    Expression<bool>? trackStock,
    Expression<double>? currentStock,
    Expression<String>? productType,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (barcode != null) 'barcode': barcode,
      if (priceDineIn != null) 'price_dine_in': priceDineIn,
      if (priceTakeaway != null) 'price_takeaway': priceTakeaway,
      if (priceDelivery != null) 'price_delivery': priceDelivery,
      if (cost != null) 'cost': cost,
      if (taxRate != null) 'tax_rate': taxRate,
      if (image != null) 'image': image,
      if (defaultNotes != null) 'default_notes': defaultNotes,
      if (trackStock != null) 'track_stock': trackStock,
      if (currentStock != null) 'current_stock': currentStock,
      if (productType != null) 'product_type': productType,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<String?>? barcode,
    Value<double>? priceDineIn,
    Value<double?>? priceTakeaway,
    Value<double?>? priceDelivery,
    Value<double?>? cost,
    Value<double>? taxRate,
    Value<String?>? image,
    Value<String?>? defaultNotes,
    Value<bool>? trackStock,
    Value<double>? currentStock,
    Value<String>? productType,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      barcode: barcode ?? this.barcode,
      priceDineIn: priceDineIn ?? this.priceDineIn,
      priceTakeaway: priceTakeaway ?? this.priceTakeaway,
      priceDelivery: priceDelivery ?? this.priceDelivery,
      cost: cost ?? this.cost,
      taxRate: taxRate ?? this.taxRate,
      image: image ?? this.image,
      defaultNotes: defaultNotes ?? this.defaultNotes,
      trackStock: trackStock ?? this.trackStock,
      currentStock: currentStock ?? this.currentStock,
      productType: productType ?? this.productType,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (priceDineIn.present) {
      map['price_dine_in'] = Variable<double>(priceDineIn.value);
    }
    if (priceTakeaway.present) {
      map['price_takeaway'] = Variable<double>(priceTakeaway.value);
    }
    if (priceDelivery.present) {
      map['price_delivery'] = Variable<double>(priceDelivery.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (defaultNotes.present) {
      map['default_notes'] = Variable<String>(defaultNotes.value);
    }
    if (trackStock.present) {
      map['track_stock'] = Variable<bool>(trackStock.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (productType.present) {
      map['product_type'] = Variable<String>(productType.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('barcode: $barcode, ')
          ..write('priceDineIn: $priceDineIn, ')
          ..write('priceTakeaway: $priceTakeaway, ')
          ..write('priceDelivery: $priceDelivery, ')
          ..write('cost: $cost, ')
          ..write('taxRate: $taxRate, ')
          ..write('image: $image, ')
          ..write('defaultNotes: $defaultNotes, ')
          ..write('trackStock: $trackStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('productType: $productType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModifierGroupsTable extends ModifierGroups
    with TableInfo<$ModifierGroupsTable, ModifierGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModifierGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isMultipleChoiceMeta = const VerificationMeta(
    'isMultipleChoice',
  );
  @override
  late final GeneratedColumn<bool> isMultipleChoice = GeneratedColumn<bool>(
    'is_multiple_choice',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_multiple_choice" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameAr,
    isMultipleChoice,
    isRequired,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modifier_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModifierGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('is_multiple_choice')) {
      context.handle(
        _isMultipleChoiceMeta,
        isMultipleChoice.isAcceptableOrUnknown(
          data['is_multiple_choice']!,
          _isMultipleChoiceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isMultipleChoiceMeta);
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    } else if (isInserting) {
      context.missing(_isRequiredMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModifierGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModifierGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      isMultipleChoice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_multiple_choice'],
      )!,
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
    );
  }

  @override
  $ModifierGroupsTable createAlias(String alias) {
    return $ModifierGroupsTable(attachedDatabase, alias);
  }
}

class ModifierGroup extends DataClass implements Insertable<ModifierGroup> {
  final String id;
  final String name;
  final String? nameAr;
  final bool isMultipleChoice;
  final bool isRequired;
  const ModifierGroup({
    required this.id,
    required this.name,
    this.nameAr,
    required this.isMultipleChoice,
    required this.isRequired,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['is_multiple_choice'] = Variable<bool>(isMultipleChoice);
    map['is_required'] = Variable<bool>(isRequired);
    return map;
  }

  ModifierGroupsCompanion toCompanion(bool nullToAbsent) {
    return ModifierGroupsCompanion(
      id: Value(id),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      isMultipleChoice: Value(isMultipleChoice),
      isRequired: Value(isRequired),
    );
  }

  factory ModifierGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModifierGroup(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      isMultipleChoice: serializer.fromJson<bool>(json['isMultipleChoice']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'isMultipleChoice': serializer.toJson<bool>(isMultipleChoice),
      'isRequired': serializer.toJson<bool>(isRequired),
    };
  }

  ModifierGroup copyWith({
    String? id,
    String? name,
    Value<String?> nameAr = const Value.absent(),
    bool? isMultipleChoice,
    bool? isRequired,
  }) => ModifierGroup(
    id: id ?? this.id,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,
    isRequired: isRequired ?? this.isRequired,
  );
  ModifierGroup copyWithCompanion(ModifierGroupsCompanion data) {
    return ModifierGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      isMultipleChoice: data.isMultipleChoice.present
          ? data.isMultipleChoice.value
          : this.isMultipleChoice,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModifierGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('isMultipleChoice: $isMultipleChoice, ')
          ..write('isRequired: $isRequired')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameAr, isMultipleChoice, isRequired);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModifierGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.isMultipleChoice == this.isMultipleChoice &&
          other.isRequired == this.isRequired);
}

class ModifierGroupsCompanion extends UpdateCompanion<ModifierGroup> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<bool> isMultipleChoice;
  final Value<bool> isRequired;
  final Value<int> rowid;
  const ModifierGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.isMultipleChoice = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModifierGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameAr = const Value.absent(),
    required bool isMultipleChoice,
    required bool isRequired,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       isMultipleChoice = Value(isMultipleChoice),
       isRequired = Value(isRequired);
  static Insertable<ModifierGroup> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<bool>? isMultipleChoice,
    Expression<bool>? isRequired,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (isMultipleChoice != null) 'is_multiple_choice': isMultipleChoice,
      if (isRequired != null) 'is_required': isRequired,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModifierGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<bool>? isMultipleChoice,
    Value<bool>? isRequired,
    Value<int>? rowid,
  }) {
    return ModifierGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,
      isRequired: isRequired ?? this.isRequired,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (isMultipleChoice.present) {
      map['is_multiple_choice'] = Variable<bool>(isMultipleChoice.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModifierGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('isMultipleChoice: $isMultipleChoice, ')
          ..write('isRequired: $isRequired, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModifierOptionsTable extends ModifierOptions
    with TableInfo<$ModifierOptionsTable, ModifierOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModifierOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _modifierGroupIdMeta = const VerificationMeta(
    'modifierGroupId',
  );
  @override
  late final GeneratedColumn<String> modifierGroupId = GeneratedColumn<String>(
    'modifier_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modifier_groups (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceExtraMeta = const VerificationMeta(
    'priceExtra',
  );
  @override
  late final GeneratedColumn<double> priceExtra = GeneratedColumn<double>(
    'price_extra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modifierGroupId,
    name,
    nameAr,
    priceExtra,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modifier_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModifierOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modifier_group_id')) {
      context.handle(
        _modifierGroupIdMeta,
        modifierGroupId.isAcceptableOrUnknown(
          data['modifier_group_id']!,
          _modifierGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modifierGroupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('price_extra')) {
      context.handle(
        _priceExtraMeta,
        priceExtra.isAcceptableOrUnknown(data['price_extra']!, _priceExtraMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModifierOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModifierOption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      modifierGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modifier_group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      priceExtra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_extra'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ModifierOptionsTable createAlias(String alias) {
    return $ModifierOptionsTable(attachedDatabase, alias);
  }
}

class ModifierOption extends DataClass implements Insertable<ModifierOption> {
  final String id;
  final String modifierGroupId;
  final String name;
  final String? nameAr;
  final double priceExtra;
  final int sortOrder;
  final bool isActive;
  const ModifierOption({
    required this.id,
    required this.modifierGroupId,
    required this.name,
    this.nameAr,
    required this.priceExtra,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['modifier_group_id'] = Variable<String>(modifierGroupId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['price_extra'] = Variable<double>(priceExtra);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ModifierOptionsCompanion toCompanion(bool nullToAbsent) {
    return ModifierOptionsCompanion(
      id: Value(id),
      modifierGroupId: Value(modifierGroupId),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      priceExtra: Value(priceExtra),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory ModifierOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModifierOption(
      id: serializer.fromJson<String>(json['id']),
      modifierGroupId: serializer.fromJson<String>(json['modifierGroupId']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      priceExtra: serializer.fromJson<double>(json['priceExtra']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'modifierGroupId': serializer.toJson<String>(modifierGroupId),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'priceExtra': serializer.toJson<double>(priceExtra),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ModifierOption copyWith({
    String? id,
    String? modifierGroupId,
    String? name,
    Value<String?> nameAr = const Value.absent(),
    double? priceExtra,
    int? sortOrder,
    bool? isActive,
  }) => ModifierOption(
    id: id ?? this.id,
    modifierGroupId: modifierGroupId ?? this.modifierGroupId,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    priceExtra: priceExtra ?? this.priceExtra,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  ModifierOption copyWithCompanion(ModifierOptionsCompanion data) {
    return ModifierOption(
      id: data.id.present ? data.id.value : this.id,
      modifierGroupId: data.modifierGroupId.present
          ? data.modifierGroupId.value
          : this.modifierGroupId,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      priceExtra: data.priceExtra.present
          ? data.priceExtra.value
          : this.priceExtra,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModifierOption(')
          ..write('id: $id, ')
          ..write('modifierGroupId: $modifierGroupId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('priceExtra: $priceExtra, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    modifierGroupId,
    name,
    nameAr,
    priceExtra,
    sortOrder,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModifierOption &&
          other.id == this.id &&
          other.modifierGroupId == this.modifierGroupId &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.priceExtra == this.priceExtra &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class ModifierOptionsCompanion extends UpdateCompanion<ModifierOption> {
  final Value<String> id;
  final Value<String> modifierGroupId;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<double> priceExtra;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ModifierOptionsCompanion({
    this.id = const Value.absent(),
    this.modifierGroupId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.priceExtra = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModifierOptionsCompanion.insert({
    this.id = const Value.absent(),
    required String modifierGroupId,
    required String name,
    this.nameAr = const Value.absent(),
    this.priceExtra = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : modifierGroupId = Value(modifierGroupId),
       name = Value(name);
  static Insertable<ModifierOption> custom({
    Expression<String>? id,
    Expression<String>? modifierGroupId,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<double>? priceExtra,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modifierGroupId != null) 'modifier_group_id': modifierGroupId,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (priceExtra != null) 'price_extra': priceExtra,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModifierOptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? modifierGroupId,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<double>? priceExtra,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return ModifierOptionsCompanion(
      id: id ?? this.id,
      modifierGroupId: modifierGroupId ?? this.modifierGroupId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      priceExtra: priceExtra ?? this.priceExtra,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (modifierGroupId.present) {
      map['modifier_group_id'] = Variable<String>(modifierGroupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (priceExtra.present) {
      map['price_extra'] = Variable<double>(priceExtra.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModifierOptionsCompanion(')
          ..write('id: $id, ')
          ..write('modifierGroupId: $modifierGroupId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('priceExtra: $priceExtra, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductModifiersTable extends ProductModifiers
    with TableInfo<$ProductModifiersTable, ProductModifier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductModifiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _modifierGroupIdMeta = const VerificationMeta(
    'modifierGroupId',
  );
  @override
  late final GeneratedColumn<String> modifierGroupId = GeneratedColumn<String>(
    'modifier_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modifier_groups (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [productId, modifierGroupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_modifiers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductModifier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('modifier_group_id')) {
      context.handle(
        _modifierGroupIdMeta,
        modifierGroupId.isAcceptableOrUnknown(
          data['modifier_group_id']!,
          _modifierGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modifierGroupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId, modifierGroupId};
  @override
  ProductModifier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductModifier(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      modifierGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modifier_group_id'],
      )!,
    );
  }

  @override
  $ProductModifiersTable createAlias(String alias) {
    return $ProductModifiersTable(attachedDatabase, alias);
  }
}

class ProductModifier extends DataClass implements Insertable<ProductModifier> {
  final String productId;
  final String modifierGroupId;
  const ProductModifier({
    required this.productId,
    required this.modifierGroupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['modifier_group_id'] = Variable<String>(modifierGroupId);
    return map;
  }

  ProductModifiersCompanion toCompanion(bool nullToAbsent) {
    return ProductModifiersCompanion(
      productId: Value(productId),
      modifierGroupId: Value(modifierGroupId),
    );
  }

  factory ProductModifier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductModifier(
      productId: serializer.fromJson<String>(json['productId']),
      modifierGroupId: serializer.fromJson<String>(json['modifierGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'modifierGroupId': serializer.toJson<String>(modifierGroupId),
    };
  }

  ProductModifier copyWith({String? productId, String? modifierGroupId}) =>
      ProductModifier(
        productId: productId ?? this.productId,
        modifierGroupId: modifierGroupId ?? this.modifierGroupId,
      );
  ProductModifier copyWithCompanion(ProductModifiersCompanion data) {
    return ProductModifier(
      productId: data.productId.present ? data.productId.value : this.productId,
      modifierGroupId: data.modifierGroupId.present
          ? data.modifierGroupId.value
          : this.modifierGroupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductModifier(')
          ..write('productId: $productId, ')
          ..write('modifierGroupId: $modifierGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, modifierGroupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductModifier &&
          other.productId == this.productId &&
          other.modifierGroupId == this.modifierGroupId);
}

class ProductModifiersCompanion extends UpdateCompanion<ProductModifier> {
  final Value<String> productId;
  final Value<String> modifierGroupId;
  final Value<int> rowid;
  const ProductModifiersCompanion({
    this.productId = const Value.absent(),
    this.modifierGroupId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductModifiersCompanion.insert({
    required String productId,
    required String modifierGroupId,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       modifierGroupId = Value(modifierGroupId);
  static Insertable<ProductModifier> custom({
    Expression<String>? productId,
    Expression<String>? modifierGroupId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (modifierGroupId != null) 'modifier_group_id': modifierGroupId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductModifiersCompanion copyWith({
    Value<String>? productId,
    Value<String>? modifierGroupId,
    Value<int>? rowid,
  }) {
    return ProductModifiersCompanion(
      productId: productId ?? this.productId,
      modifierGroupId: modifierGroupId ?? this.modifierGroupId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (modifierGroupId.present) {
      map['modifier_group_id'] = Variable<String>(modifierGroupId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductModifiersCompanion(')
          ..write('productId: $productId, ')
          ..write('modifierGroupId: $modifierGroupId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPerUnitMeta = const VerificationMeta(
    'costPerUnit',
  );
  @override
  late final GeneratedColumn<double> costPerUnit = GeneratedColumn<double>(
    'cost_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStockMeta = const VerificationMeta(
    'currentStock',
  );
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
    'current_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minimumStockMeta = const VerificationMeta(
    'minimumStock',
  );
  @override
  late final GeneratedColumn<double> minimumStock = GeneratedColumn<double>(
    'minimum_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    unit,
    costPerUnit,
    currentStock,
    minimumStock,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('cost_per_unit')) {
      context.handle(
        _costPerUnitMeta,
        costPerUnit.isAcceptableOrUnknown(
          data['cost_per_unit']!,
          _costPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costPerUnitMeta);
    }
    if (data.containsKey('current_stock')) {
      context.handle(
        _currentStockMeta,
        currentStock.isAcceptableOrUnknown(
          data['current_stock']!,
          _currentStockMeta,
        ),
      );
    }
    if (data.containsKey('minimum_stock')) {
      context.handle(
        _minimumStockMeta,
        minimumStock.isAcceptableOrUnknown(
          data['minimum_stock']!,
          _minimumStockMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      costPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_per_unit'],
      )!,
      currentStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_stock'],
      )!,
      minimumStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}minimum_stock'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final String id;
  final String name;
  final String unit;
  final double costPerUnit;
  final double currentStock;
  final double minimumStock;
  final DateTime updatedAt;
  const Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    required this.costPerUnit,
    required this.currentStock,
    required this.minimumStock,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['cost_per_unit'] = Variable<double>(costPerUnit);
    map['current_stock'] = Variable<double>(currentStock);
    map['minimum_stock'] = Variable<double>(minimumStock);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      unit: Value(unit),
      costPerUnit: Value(costPerUnit),
      currentStock: Value(currentStock),
      minimumStock: Value(minimumStock),
      updatedAt: Value(updatedAt),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      costPerUnit: serializer.fromJson<double>(json['costPerUnit']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      minimumStock: serializer.fromJson<double>(json['minimumStock']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'costPerUnit': serializer.toJson<double>(costPerUnit),
      'currentStock': serializer.toJson<double>(currentStock),
      'minimumStock': serializer.toJson<double>(minimumStock),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    String? unit,
    double? costPerUnit,
    double? currentStock,
    double? minimumStock,
    DateTime? updatedAt,
  }) => Ingredient(
    id: id ?? this.id,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    costPerUnit: costPerUnit ?? this.costPerUnit,
    currentStock: currentStock ?? this.currentStock,
    minimumStock: minimumStock ?? this.minimumStock,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      costPerUnit: data.costPerUnit.present
          ? data.costPerUnit.value
          : this.costPerUnit,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      minimumStock: data.minimumStock.present
          ? data.minimumStock.value
          : this.minimumStock,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('currentStock: $currentStock, ')
          ..write('minimumStock: $minimumStock, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    unit,
    costPerUnit,
    currentStock,
    minimumStock,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.costPerUnit == this.costPerUnit &&
          other.currentStock == this.currentStock &&
          other.minimumStock == this.minimumStock &&
          other.updatedAt == this.updatedAt);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> unit;
  final Value<double> costPerUnit;
  final Value<double> currentStock;
  final Value<double> minimumStock;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.costPerUnit = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minimumStock = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String unit,
    required double costPerUnit,
    this.currentStock = const Value.absent(),
    this.minimumStock = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       unit = Value(unit),
       costPerUnit = Value(costPerUnit),
       updatedAt = Value(updatedAt);
  static Insertable<Ingredient> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? costPerUnit,
    Expression<double>? currentStock,
    Expression<double>? minimumStock,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (costPerUnit != null) 'cost_per_unit': costPerUnit,
      if (currentStock != null) 'current_stock': currentStock,
      if (minimumStock != null) 'minimum_stock': minimumStock,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? unit,
    Value<double>? costPerUnit,
    Value<double>? currentStock,
    Value<double>? minimumStock,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      currentStock: currentStock ?? this.currentStock,
      minimumStock: minimumStock ?? this.minimumStock,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (costPerUnit.present) {
      map['cost_per_unit'] = Variable<double>(costPerUnit.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (minimumStock.present) {
      map['minimum_stock'] = Variable<double>(minimumStock.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('currentStock: $currentStock, ')
          ..write('minimumStock: $minimumStock, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeItemsTable extends RecipeItems
    with TableInfo<$RecipeItemsTable, RecipeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _quantityUsedMeta = const VerificationMeta(
    'quantityUsed',
  );
  @override
  late final GeneratedColumn<double> quantityUsed = GeneratedColumn<double>(
    'quantity_used',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    ingredientId,
    quantityUsed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity_used')) {
      context.handle(
        _quantityUsedMeta,
        quantityUsed.isAcceptableOrUnknown(
          data['quantity_used']!,
          _quantityUsedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityUsedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      quantityUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_used'],
      )!,
    );
  }

  @override
  $RecipeItemsTable createAlias(String alias) {
    return $RecipeItemsTable(attachedDatabase, alias);
  }
}

class RecipeItem extends DataClass implements Insertable<RecipeItem> {
  final String id;
  final String productId;
  final String ingredientId;
  final double quantityUsed;
  const RecipeItem({
    required this.id,
    required this.productId,
    required this.ingredientId,
    required this.quantityUsed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['quantity_used'] = Variable<double>(quantityUsed);
    return map;
  }

  RecipeItemsCompanion toCompanion(bool nullToAbsent) {
    return RecipeItemsCompanion(
      id: Value(id),
      productId: Value(productId),
      ingredientId: Value(ingredientId),
      quantityUsed: Value(quantityUsed),
    );
  }

  factory RecipeItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeItem(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      quantityUsed: serializer.fromJson<double>(json['quantityUsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'quantityUsed': serializer.toJson<double>(quantityUsed),
    };
  }

  RecipeItem copyWith({
    String? id,
    String? productId,
    String? ingredientId,
    double? quantityUsed,
  }) => RecipeItem(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    ingredientId: ingredientId ?? this.ingredientId,
    quantityUsed: quantityUsed ?? this.quantityUsed,
  );
  RecipeItem copyWithCompanion(RecipeItemsCompanion data) {
    return RecipeItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantityUsed: data.quantityUsed.present
          ? data.quantityUsed.value
          : this.quantityUsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityUsed: $quantityUsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, ingredientId, quantityUsed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.ingredientId == this.ingredientId &&
          other.quantityUsed == this.quantityUsed);
}

class RecipeItemsCompanion extends UpdateCompanion<RecipeItem> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> ingredientId;
  final Value<double> quantityUsed;
  final Value<int> rowid;
  const RecipeItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantityUsed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeItemsCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    required String ingredientId,
    required double quantityUsed,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       ingredientId = Value(ingredientId),
       quantityUsed = Value(quantityUsed);
  static Insertable<RecipeItem> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? ingredientId,
    Expression<double>? quantityUsed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantityUsed != null) 'quantity_used': quantityUsed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? ingredientId,
    Value<double>? quantityUsed,
    Value<int>? rowid,
  }) {
    return RecipeItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantityUsed: quantityUsed ?? this.quantityUsed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (quantityUsed.present) {
      map['quantity_used'] = Variable<double>(quantityUsed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityUsed: $quantityUsed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashSessionsTable extends CashSessions
    with TableInfo<$CashSessionsTable, CashSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _cashierIdMeta = const VerificationMeta(
    'cashierId',
  );
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
    'cashier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closingBalanceMeta = const VerificationMeta(
    'closingBalance',
  );
  @override
  late final GeneratedColumn<double> closingBalance = GeneratedColumn<double>(
    'closing_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedBalanceMeta = const VerificationMeta(
    'expectedBalance',
  );
  @override
  late final GeneratedColumn<double> expectedBalance = GeneratedColumn<double>(
    'expected_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closingNoteMeta = const VerificationMeta(
    'closingNote',
  );
  @override
  late final GeneratedColumn<String> closingNote = GeneratedColumn<String>(
    'closing_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OPEN'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cashierId,
    openedAt,
    closedAt,
    openingBalance,
    closingBalance,
    expectedBalance,
    closingNote,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cashier_id')) {
      context.handle(
        _cashierIdMeta,
        cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingBalanceMeta);
    }
    if (data.containsKey('closing_balance')) {
      context.handle(
        _closingBalanceMeta,
        closingBalance.isAcceptableOrUnknown(
          data['closing_balance']!,
          _closingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('expected_balance')) {
      context.handle(
        _expectedBalanceMeta,
        expectedBalance.isAcceptableOrUnknown(
          data['expected_balance']!,
          _expectedBalanceMeta,
        ),
      );
    }
    if (data.containsKey('closing_note')) {
      context.handle(
        _closingNoteMeta,
        closingNote.isAcceptableOrUnknown(
          data['closing_note']!,
          _closingNoteMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_id'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_balance'],
      )!,
      closingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}closing_balance'],
      ),
      expectedBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expected_balance'],
      ),
      closingNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closing_note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $CashSessionsTable createAlias(String alias) {
    return $CashSessionsTable(attachedDatabase, alias);
  }
}

class CashSession extends DataClass implements Insertable<CashSession> {
  final String id;
  final String cashierId;
  final DateTime openedAt;
  final DateTime? closedAt;
  final double openingBalance;
  final double? closingBalance;
  final double? expectedBalance;
  final String? closingNote;
  final String status;
  const CashSession({
    required this.id,
    required this.cashierId,
    required this.openedAt,
    this.closedAt,
    required this.openingBalance,
    this.closingBalance,
    this.expectedBalance,
    this.closingNote,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cashier_id'] = Variable<String>(cashierId);
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    map['opening_balance'] = Variable<double>(openingBalance);
    if (!nullToAbsent || closingBalance != null) {
      map['closing_balance'] = Variable<double>(closingBalance);
    }
    if (!nullToAbsent || expectedBalance != null) {
      map['expected_balance'] = Variable<double>(expectedBalance);
    }
    if (!nullToAbsent || closingNote != null) {
      map['closing_note'] = Variable<String>(closingNote);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  CashSessionsCompanion toCompanion(bool nullToAbsent) {
    return CashSessionsCompanion(
      id: Value(id),
      cashierId: Value(cashierId),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      openingBalance: Value(openingBalance),
      closingBalance: closingBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(closingBalance),
      expectedBalance: expectedBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedBalance),
      closingNote: closingNote == null && nullToAbsent
          ? const Value.absent()
          : Value(closingNote),
      status: Value(status),
    );
  }

  factory CashSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashSession(
      id: serializer.fromJson<String>(json['id']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      closingBalance: serializer.fromJson<double?>(json['closingBalance']),
      expectedBalance: serializer.fromJson<double?>(json['expectedBalance']),
      closingNote: serializer.fromJson<String?>(json['closingNote']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cashierId': serializer.toJson<String>(cashierId),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'closingBalance': serializer.toJson<double?>(closingBalance),
      'expectedBalance': serializer.toJson<double?>(expectedBalance),
      'closingNote': serializer.toJson<String?>(closingNote),
      'status': serializer.toJson<String>(status),
    };
  }

  CashSession copyWith({
    String? id,
    String? cashierId,
    DateTime? openedAt,
    Value<DateTime?> closedAt = const Value.absent(),
    double? openingBalance,
    Value<double?> closingBalance = const Value.absent(),
    Value<double?> expectedBalance = const Value.absent(),
    Value<String?> closingNote = const Value.absent(),
    String? status,
  }) => CashSession(
    id: id ?? this.id,
    cashierId: cashierId ?? this.cashierId,
    openedAt: openedAt ?? this.openedAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    openingBalance: openingBalance ?? this.openingBalance,
    closingBalance: closingBalance.present
        ? closingBalance.value
        : this.closingBalance,
    expectedBalance: expectedBalance.present
        ? expectedBalance.value
        : this.expectedBalance,
    closingNote: closingNote.present ? closingNote.value : this.closingNote,
    status: status ?? this.status,
  );
  CashSession copyWithCompanion(CashSessionsCompanion data) {
    return CashSession(
      id: data.id.present ? data.id.value : this.id,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      closingBalance: data.closingBalance.present
          ? data.closingBalance.value
          : this.closingBalance,
      expectedBalance: data.expectedBalance.present
          ? data.expectedBalance.value
          : this.expectedBalance,
      closingNote: data.closingNote.present
          ? data.closingNote.value
          : this.closingNote,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashSession(')
          ..write('id: $id, ')
          ..write('cashierId: $cashierId, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('expectedBalance: $expectedBalance, ')
          ..write('closingNote: $closingNote, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cashierId,
    openedAt,
    closedAt,
    openingBalance,
    closingBalance,
    expectedBalance,
    closingNote,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashSession &&
          other.id == this.id &&
          other.cashierId == this.cashierId &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.openingBalance == this.openingBalance &&
          other.closingBalance == this.closingBalance &&
          other.expectedBalance == this.expectedBalance &&
          other.closingNote == this.closingNote &&
          other.status == this.status);
}

class CashSessionsCompanion extends UpdateCompanion<CashSession> {
  final Value<String> id;
  final Value<String> cashierId;
  final Value<DateTime> openedAt;
  final Value<DateTime?> closedAt;
  final Value<double> openingBalance;
  final Value<double?> closingBalance;
  final Value<double?> expectedBalance;
  final Value<String?> closingNote;
  final Value<String> status;
  final Value<int> rowid;
  const CashSessionsCompanion({
    this.id = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.closingBalance = const Value.absent(),
    this.expectedBalance = const Value.absent(),
    this.closingNote = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String cashierId,
    required DateTime openedAt,
    this.closedAt = const Value.absent(),
    required double openingBalance,
    this.closingBalance = const Value.absent(),
    this.expectedBalance = const Value.absent(),
    this.closingNote = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cashierId = Value(cashierId),
       openedAt = Value(openedAt),
       openingBalance = Value(openingBalance);
  static Insertable<CashSession> custom({
    Expression<String>? id,
    Expression<String>? cashierId,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<double>? openingBalance,
    Expression<double>? closingBalance,
    Expression<double>? expectedBalance,
    Expression<String>? closingNote,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cashierId != null) 'cashier_id': cashierId,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (closingBalance != null) 'closing_balance': closingBalance,
      if (expectedBalance != null) 'expected_balance': expectedBalance,
      if (closingNote != null) 'closing_note': closingNote,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? cashierId,
    Value<DateTime>? openedAt,
    Value<DateTime?>? closedAt,
    Value<double>? openingBalance,
    Value<double?>? closingBalance,
    Value<double?>? expectedBalance,
    Value<String?>? closingNote,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return CashSessionsCompanion(
      id: id ?? this.id,
      cashierId: cashierId ?? this.cashierId,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      expectedBalance: expectedBalance ?? this.expectedBalance,
      closingNote: closingNote ?? this.closingNote,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (closingBalance.present) {
      map['closing_balance'] = Variable<double>(closingBalance.value);
    }
    if (expectedBalance.present) {
      map['expected_balance'] = Variable<double>(expectedBalance.value);
    }
    if (closingNote.present) {
      map['closing_note'] = Variable<String>(closingNote.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashSessionsCompanion(')
          ..write('id: $id, ')
          ..write('cashierId: $cashierId, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('expectedBalance: $expectedBalance, ')
          ..write('closingNote: $closingNote, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashMovementsTable extends CashMovements
    with TableInfo<$CashMovementsTable, CashMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cash_sessions (id)',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    userId,
    type,
    amount,
    reason,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CashMovementsTable createAlias(String alias) {
    return $CashMovementsTable(attachedDatabase, alias);
  }
}

class CashMovement extends DataClass implements Insertable<CashMovement> {
  final String id;
  final String sessionId;
  final String userId;
  final String type;
  final double amount;
  final String reason;
  final DateTime createdAt;
  const CashMovement({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['reason'] = Variable<String>(reason);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashMovementsCompanion toCompanion(bool nullToAbsent) {
    return CashMovementsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      userId: Value(userId),
      type: Value(type),
      amount: Value(amount),
      reason: Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory CashMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashMovement(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      reason: serializer.fromJson<String>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'reason': serializer.toJson<String>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashMovement copyWith({
    String? id,
    String? sessionId,
    String? userId,
    String? type,
    double? amount,
    String? reason,
    DateTime? createdAt,
  }) => CashMovement(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    reason: reason ?? this.reason,
    createdAt: createdAt ?? this.createdAt,
  );
  CashMovement copyWithCompanion(CashMovementsCompanion data) {
    return CashMovement(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashMovement(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, userId, type, amount, reason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashMovement &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class CashMovementsCompanion extends UpdateCompanion<CashMovement> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> userId;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> reason;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CashMovementsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashMovementsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required String userId,
    required String type,
    required double amount,
    required String reason,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       userId = Value(userId),
       type = Value(type),
       amount = Value(amount),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<CashMovement> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? userId,
    Value<String>? type,
    Value<double>? amount,
    Value<String>? reason,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CashMovementsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashMovementsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cash_sessions (id)',
    ),
  );
  static const VerificationMeta _waiterIdMeta = const VerificationMeta(
    'waiterId',
  );
  @override
  late final GeneratedColumn<String> waiterId = GeneratedColumn<String>(
    'waiter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _tableIdMeta = const VerificationMeta(
    'tableId',
  );
  @override
  late final GeneratedColumn<String> tableId = GeneratedColumn<String>(
    'table_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES restaurant_tables (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderTypeMeta = const VerificationMeta(
    'orderType',
  );
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
    'order_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MANUAL'),
  );
  static const VerificationMeta _externalRefMeta = const VerificationMeta(
    'externalRef',
  );
  @override
  late final GeneratedColumn<String> externalRef = GeneratedColumn<String>(
    'external_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OPEN'),
  );
  static const VerificationMeta _discountTypeMeta = const VerificationMeta(
    'discountType',
  );
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
    'discount_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountValueMeta = const VerificationMeta(
    'discountValue',
  );
  @override
  late final GeneratedColumn<double> discountValue = GeneratedColumn<double>(
    'discount_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountReasonMeta = const VerificationMeta(
    'discountReason',
  );
  @override
  late final GeneratedColumn<String> discountReason = GeneratedColumn<String>(
    'discount_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAuthorizedByMeta =
      const VerificationMeta('discountAuthorizedBy');
  @override
  late final GeneratedColumn<String> discountAuthorizedBy =
      GeneratedColumn<String>(
        'discount_authorized_by',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id)',
        ),
      );
  static const VerificationMeta _guestCountMeta = const VerificationMeta(
    'guestCount',
  );
  @override
  late final GeneratedColumn<int> guestCount = GeneratedColumn<int>(
    'guest_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIceMeta = const VerificationMeta(
    'companyIce',
  );
  @override
  late final GeneratedColumn<String> companyIce = GeneratedColumn<String>(
    'company_ice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<int> invoiceNumber = GeneratedColumn<int>(
    'invoice_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    waiterId,
    tableId,
    customerId,
    orderType,
    source,
    externalRef,
    status,
    discountType,
    discountValue,
    discountReason,
    discountAuthorizedBy,
    guestCount,
    notes,
    companyName,
    companyIce,
    invoiceNumber,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('waiter_id')) {
      context.handle(
        _waiterIdMeta,
        waiterId.isAcceptableOrUnknown(data['waiter_id']!, _waiterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_waiterIdMeta);
    }
    if (data.containsKey('table_id')) {
      context.handle(
        _tableIdMeta,
        tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('order_type')) {
      context.handle(
        _orderTypeMeta,
        orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_orderTypeMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('external_ref')) {
      context.handle(
        _externalRefMeta,
        externalRef.isAcceptableOrUnknown(
          data['external_ref']!,
          _externalRefMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('discount_type')) {
      context.handle(
        _discountTypeMeta,
        discountType.isAcceptableOrUnknown(
          data['discount_type']!,
          _discountTypeMeta,
        ),
      );
    }
    if (data.containsKey('discount_value')) {
      context.handle(
        _discountValueMeta,
        discountValue.isAcceptableOrUnknown(
          data['discount_value']!,
          _discountValueMeta,
        ),
      );
    }
    if (data.containsKey('discount_reason')) {
      context.handle(
        _discountReasonMeta,
        discountReason.isAcceptableOrUnknown(
          data['discount_reason']!,
          _discountReasonMeta,
        ),
      );
    }
    if (data.containsKey('discount_authorized_by')) {
      context.handle(
        _discountAuthorizedByMeta,
        discountAuthorizedBy.isAcceptableOrUnknown(
          data['discount_authorized_by']!,
          _discountAuthorizedByMeta,
        ),
      );
    }
    if (data.containsKey('guest_count')) {
      context.handle(
        _guestCountMeta,
        guestCount.isAcceptableOrUnknown(data['guest_count']!, _guestCountMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('company_ice')) {
      context.handle(
        _companyIceMeta,
        companyIce.isAcceptableOrUnknown(data['company_ice']!, _companyIceMeta),
      );
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      waiterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}waiter_id'],
      )!,
      tableId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      orderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_type'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      externalRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_ref'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      discountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_type'],
      ),
      discountValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_value'],
      ),
      discountReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_reason'],
      ),
      discountAuthorizedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_authorized_by'],
      ),
      guestCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}guest_count'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      ),
      companyIce: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_ice'],
      ),
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_number'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final String id;
  final String sessionId;
  final String waiterId;
  final String? tableId;
  final String? customerId;
  final String orderType;
  final String source;
  final String? externalRef;
  final String status;
  final String? discountType;
  final double? discountValue;
  final String? discountReason;
  final String? discountAuthorizedBy;
  final int guestCount;

  /// Instructions globales (allergies, événement, etc.).
  final String? notes;

  /// Facture entreprise (scénario #34 / étape 7 Sprint 3).
  final String? companyName;
  final String? companyIce;
  final int? invoiceNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Order({
    required this.id,
    required this.sessionId,
    required this.waiterId,
    this.tableId,
    this.customerId,
    required this.orderType,
    required this.source,
    this.externalRef,
    required this.status,
    this.discountType,
    this.discountValue,
    this.discountReason,
    this.discountAuthorizedBy,
    required this.guestCount,
    this.notes,
    this.companyName,
    this.companyIce,
    this.invoiceNumber,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['waiter_id'] = Variable<String>(waiterId);
    if (!nullToAbsent || tableId != null) {
      map['table_id'] = Variable<String>(tableId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['order_type'] = Variable<String>(orderType);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || externalRef != null) {
      map['external_ref'] = Variable<String>(externalRef);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || discountType != null) {
      map['discount_type'] = Variable<String>(discountType);
    }
    if (!nullToAbsent || discountValue != null) {
      map['discount_value'] = Variable<double>(discountValue);
    }
    if (!nullToAbsent || discountReason != null) {
      map['discount_reason'] = Variable<String>(discountReason);
    }
    if (!nullToAbsent || discountAuthorizedBy != null) {
      map['discount_authorized_by'] = Variable<String>(discountAuthorizedBy);
    }
    map['guest_count'] = Variable<int>(guestCount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    if (!nullToAbsent || companyIce != null) {
      map['company_ice'] = Variable<String>(companyIce);
    }
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<int>(invoiceNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      waiterId: Value(waiterId),
      tableId: tableId == null && nullToAbsent
          ? const Value.absent()
          : Value(tableId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      orderType: Value(orderType),
      source: Value(source),
      externalRef: externalRef == null && nullToAbsent
          ? const Value.absent()
          : Value(externalRef),
      status: Value(status),
      discountType: discountType == null && nullToAbsent
          ? const Value.absent()
          : Value(discountType),
      discountValue: discountValue == null && nullToAbsent
          ? const Value.absent()
          : Value(discountValue),
      discountReason: discountReason == null && nullToAbsent
          ? const Value.absent()
          : Value(discountReason),
      discountAuthorizedBy: discountAuthorizedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(discountAuthorizedBy),
      guestCount: Value(guestCount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
      companyIce: companyIce == null && nullToAbsent
          ? const Value.absent()
          : Value(companyIce),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      waiterId: serializer.fromJson<String>(json['waiterId']),
      tableId: serializer.fromJson<String?>(json['tableId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      orderType: serializer.fromJson<String>(json['orderType']),
      source: serializer.fromJson<String>(json['source']),
      externalRef: serializer.fromJson<String?>(json['externalRef']),
      status: serializer.fromJson<String>(json['status']),
      discountType: serializer.fromJson<String?>(json['discountType']),
      discountValue: serializer.fromJson<double?>(json['discountValue']),
      discountReason: serializer.fromJson<String?>(json['discountReason']),
      discountAuthorizedBy: serializer.fromJson<String?>(
        json['discountAuthorizedBy'],
      ),
      guestCount: serializer.fromJson<int>(json['guestCount']),
      notes: serializer.fromJson<String?>(json['notes']),
      companyName: serializer.fromJson<String?>(json['companyName']),
      companyIce: serializer.fromJson<String?>(json['companyIce']),
      invoiceNumber: serializer.fromJson<int?>(json['invoiceNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'waiterId': serializer.toJson<String>(waiterId),
      'tableId': serializer.toJson<String?>(tableId),
      'customerId': serializer.toJson<String?>(customerId),
      'orderType': serializer.toJson<String>(orderType),
      'source': serializer.toJson<String>(source),
      'externalRef': serializer.toJson<String?>(externalRef),
      'status': serializer.toJson<String>(status),
      'discountType': serializer.toJson<String?>(discountType),
      'discountValue': serializer.toJson<double?>(discountValue),
      'discountReason': serializer.toJson<String?>(discountReason),
      'discountAuthorizedBy': serializer.toJson<String?>(discountAuthorizedBy),
      'guestCount': serializer.toJson<int>(guestCount),
      'notes': serializer.toJson<String?>(notes),
      'companyName': serializer.toJson<String?>(companyName),
      'companyIce': serializer.toJson<String?>(companyIce),
      'invoiceNumber': serializer.toJson<int?>(invoiceNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Order copyWith({
    String? id,
    String? sessionId,
    String? waiterId,
    Value<String?> tableId = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    String? orderType,
    String? source,
    Value<String?> externalRef = const Value.absent(),
    String? status,
    Value<String?> discountType = const Value.absent(),
    Value<double?> discountValue = const Value.absent(),
    Value<String?> discountReason = const Value.absent(),
    Value<String?> discountAuthorizedBy = const Value.absent(),
    int? guestCount,
    Value<String?> notes = const Value.absent(),
    Value<String?> companyName = const Value.absent(),
    Value<String?> companyIce = const Value.absent(),
    Value<int?> invoiceNumber = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Order(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    waiterId: waiterId ?? this.waiterId,
    tableId: tableId.present ? tableId.value : this.tableId,
    customerId: customerId.present ? customerId.value : this.customerId,
    orderType: orderType ?? this.orderType,
    source: source ?? this.source,
    externalRef: externalRef.present ? externalRef.value : this.externalRef,
    status: status ?? this.status,
    discountType: discountType.present ? discountType.value : this.discountType,
    discountValue: discountValue.present
        ? discountValue.value
        : this.discountValue,
    discountReason: discountReason.present
        ? discountReason.value
        : this.discountReason,
    discountAuthorizedBy: discountAuthorizedBy.present
        ? discountAuthorizedBy.value
        : this.discountAuthorizedBy,
    guestCount: guestCount ?? this.guestCount,
    notes: notes.present ? notes.value : this.notes,
    companyName: companyName.present ? companyName.value : this.companyName,
    companyIce: companyIce.present ? companyIce.value : this.companyIce,
    invoiceNumber: invoiceNumber.present
        ? invoiceNumber.value
        : this.invoiceNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      waiterId: data.waiterId.present ? data.waiterId.value : this.waiterId,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      source: data.source.present ? data.source.value : this.source,
      externalRef: data.externalRef.present
          ? data.externalRef.value
          : this.externalRef,
      status: data.status.present ? data.status.value : this.status,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      discountReason: data.discountReason.present
          ? data.discountReason.value
          : this.discountReason,
      discountAuthorizedBy: data.discountAuthorizedBy.present
          ? data.discountAuthorizedBy.value
          : this.discountAuthorizedBy,
      guestCount: data.guestCount.present
          ? data.guestCount.value
          : this.guestCount,
      notes: data.notes.present ? data.notes.value : this.notes,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      companyIce: data.companyIce.present
          ? data.companyIce.value
          : this.companyIce,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('waiterId: $waiterId, ')
          ..write('tableId: $tableId, ')
          ..write('customerId: $customerId, ')
          ..write('orderType: $orderType, ')
          ..write('source: $source, ')
          ..write('externalRef: $externalRef, ')
          ..write('status: $status, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountReason: $discountReason, ')
          ..write('discountAuthorizedBy: $discountAuthorizedBy, ')
          ..write('guestCount: $guestCount, ')
          ..write('notes: $notes, ')
          ..write('companyName: $companyName, ')
          ..write('companyIce: $companyIce, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    waiterId,
    tableId,
    customerId,
    orderType,
    source,
    externalRef,
    status,
    discountType,
    discountValue,
    discountReason,
    discountAuthorizedBy,
    guestCount,
    notes,
    companyName,
    companyIce,
    invoiceNumber,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.waiterId == this.waiterId &&
          other.tableId == this.tableId &&
          other.customerId == this.customerId &&
          other.orderType == this.orderType &&
          other.source == this.source &&
          other.externalRef == this.externalRef &&
          other.status == this.status &&
          other.discountType == this.discountType &&
          other.discountValue == this.discountValue &&
          other.discountReason == this.discountReason &&
          other.discountAuthorizedBy == this.discountAuthorizedBy &&
          other.guestCount == this.guestCount &&
          other.notes == this.notes &&
          other.companyName == this.companyName &&
          other.companyIce == this.companyIce &&
          other.invoiceNumber == this.invoiceNumber &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> waiterId;
  final Value<String?> tableId;
  final Value<String?> customerId;
  final Value<String> orderType;
  final Value<String> source;
  final Value<String?> externalRef;
  final Value<String> status;
  final Value<String?> discountType;
  final Value<double?> discountValue;
  final Value<String?> discountReason;
  final Value<String?> discountAuthorizedBy;
  final Value<int> guestCount;
  final Value<String?> notes;
  final Value<String?> companyName;
  final Value<String?> companyIce;
  final Value<int?> invoiceNumber;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.waiterId = const Value.absent(),
    this.tableId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.orderType = const Value.absent(),
    this.source = const Value.absent(),
    this.externalRef = const Value.absent(),
    this.status = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.discountAuthorizedBy = const Value.absent(),
    this.guestCount = const Value.absent(),
    this.notes = const Value.absent(),
    this.companyName = const Value.absent(),
    this.companyIce = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required String waiterId,
    this.tableId = const Value.absent(),
    this.customerId = const Value.absent(),
    required String orderType,
    this.source = const Value.absent(),
    this.externalRef = const Value.absent(),
    this.status = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.discountAuthorizedBy = const Value.absent(),
    this.guestCount = const Value.absent(),
    this.notes = const Value.absent(),
    this.companyName = const Value.absent(),
    this.companyIce = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       waiterId = Value(waiterId),
       orderType = Value(orderType),
       createdAt = Value(createdAt);
  static Insertable<Order> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? waiterId,
    Expression<String>? tableId,
    Expression<String>? customerId,
    Expression<String>? orderType,
    Expression<String>? source,
    Expression<String>? externalRef,
    Expression<String>? status,
    Expression<String>? discountType,
    Expression<double>? discountValue,
    Expression<String>? discountReason,
    Expression<String>? discountAuthorizedBy,
    Expression<int>? guestCount,
    Expression<String>? notes,
    Expression<String>? companyName,
    Expression<String>? companyIce,
    Expression<int>? invoiceNumber,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (waiterId != null) 'waiter_id': waiterId,
      if (tableId != null) 'table_id': tableId,
      if (customerId != null) 'customer_id': customerId,
      if (orderType != null) 'order_type': orderType,
      if (source != null) 'source': source,
      if (externalRef != null) 'external_ref': externalRef,
      if (status != null) 'status': status,
      if (discountType != null) 'discount_type': discountType,
      if (discountValue != null) 'discount_value': discountValue,
      if (discountReason != null) 'discount_reason': discountReason,
      if (discountAuthorizedBy != null)
        'discount_authorized_by': discountAuthorizedBy,
      if (guestCount != null) 'guest_count': guestCount,
      if (notes != null) 'notes': notes,
      if (companyName != null) 'company_name': companyName,
      if (companyIce != null) 'company_ice': companyIce,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? waiterId,
    Value<String?>? tableId,
    Value<String?>? customerId,
    Value<String>? orderType,
    Value<String>? source,
    Value<String?>? externalRef,
    Value<String>? status,
    Value<String?>? discountType,
    Value<double?>? discountValue,
    Value<String?>? discountReason,
    Value<String?>? discountAuthorizedBy,
    Value<int>? guestCount,
    Value<String?>? notes,
    Value<String?>? companyName,
    Value<String?>? companyIce,
    Value<int?>? invoiceNumber,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      waiterId: waiterId ?? this.waiterId,
      tableId: tableId ?? this.tableId,
      customerId: customerId ?? this.customerId,
      orderType: orderType ?? this.orderType,
      source: source ?? this.source,
      externalRef: externalRef ?? this.externalRef,
      status: status ?? this.status,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      discountReason: discountReason ?? this.discountReason,
      discountAuthorizedBy: discountAuthorizedBy ?? this.discountAuthorizedBy,
      guestCount: guestCount ?? this.guestCount,
      notes: notes ?? this.notes,
      companyName: companyName ?? this.companyName,
      companyIce: companyIce ?? this.companyIce,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (waiterId.present) {
      map['waiter_id'] = Variable<String>(waiterId.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<String>(tableId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalRef.present) {
      map['external_ref'] = Variable<String>(externalRef.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<double>(discountValue.value);
    }
    if (discountReason.present) {
      map['discount_reason'] = Variable<String>(discountReason.value);
    }
    if (discountAuthorizedBy.present) {
      map['discount_authorized_by'] = Variable<String>(
        discountAuthorizedBy.value,
      );
    }
    if (guestCount.present) {
      map['guest_count'] = Variable<int>(guestCount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (companyIce.present) {
      map['company_ice'] = Variable<String>(companyIce.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<int>(invoiceNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('waiterId: $waiterId, ')
          ..write('tableId: $tableId, ')
          ..write('customerId: $customerId, ')
          ..write('orderType: $orderType, ')
          ..write('source: $source, ')
          ..write('externalRef: $externalRef, ')
          ..write('status: $status, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountReason: $discountReason, ')
          ..write('discountAuthorizedBy: $discountAuthorizedBy, ')
          ..write('guestCount: $guestCount, ')
          ..write('notes: $notes, ')
          ..write('companyName: $companyName, ')
          ..write('companyIce: $companyIce, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customNotesMeta = const VerificationMeta(
    'customNotes',
  );
  @override
  late final GeneratedColumn<String> customNotes = GeneratedColumn<String>(
    'custom_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _courseNumberMeta = const VerificationMeta(
    'courseNumber',
  );
  @override
  late final GeneratedColumn<int> courseNumber = GeneratedColumn<int>(
    'course_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isFiredMeta = const VerificationMeta(
    'isFired',
  );
  @override
  late final GeneratedColumn<bool> isFired = GeneratedColumn<bool>(
    'is_fired',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_fired" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _voidReasonMeta = const VerificationMeta(
    'voidReason',
  );
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
    'void_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidAuthorizedByMeta = const VerificationMeta(
    'voidAuthorizedBy',
  );
  @override
  late final GeneratedColumn<String> voidAuthorizedBy = GeneratedColumn<String>(
    'void_authorized_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    quantity,
    unitPrice,
    taxRate,
    customNotes,
    courseNumber,
    isFired,
    status,
    voidReason,
    voidAuthorizedBy,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    } else if (isInserting) {
      context.missing(_taxRateMeta);
    }
    if (data.containsKey('custom_notes')) {
      context.handle(
        _customNotesMeta,
        customNotes.isAcceptableOrUnknown(
          data['custom_notes']!,
          _customNotesMeta,
        ),
      );
    }
    if (data.containsKey('course_number')) {
      context.handle(
        _courseNumberMeta,
        courseNumber.isAcceptableOrUnknown(
          data['course_number']!,
          _courseNumberMeta,
        ),
      );
    }
    if (data.containsKey('is_fired')) {
      context.handle(
        _isFiredMeta,
        isFired.isAcceptableOrUnknown(data['is_fired']!, _isFiredMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('void_reason')) {
      context.handle(
        _voidReasonMeta,
        voidReason.isAcceptableOrUnknown(data['void_reason']!, _voidReasonMeta),
      );
    }
    if (data.containsKey('void_authorized_by')) {
      context.handle(
        _voidAuthorizedByMeta,
        voidAuthorizedBy.isAcceptableOrUnknown(
          data['void_authorized_by']!,
          _voidAuthorizedByMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      customNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_notes'],
      ),
      courseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}course_number'],
      )!,
      isFired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_fired'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      voidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason'],
      ),
      voidAuthorizedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_authorized_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final String id;
  final String orderId;
  final String productId;
  final double quantity;
  final double unitPrice;
  final double taxRate;
  final String? customNotes;
  final int courseNumber;
  final bool isFired;
  final String status;
  final String? voidReason;
  final String? voidAuthorizedBy;
  final DateTime createdAt;
  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
    this.customNotes,
    required this.courseNumber,
    required this.isFired,
    required this.status,
    this.voidReason,
    this.voidAuthorizedBy,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['tax_rate'] = Variable<double>(taxRate);
    if (!nullToAbsent || customNotes != null) {
      map['custom_notes'] = Variable<String>(customNotes);
    }
    map['course_number'] = Variable<int>(courseNumber);
    map['is_fired'] = Variable<bool>(isFired);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    if (!nullToAbsent || voidAuthorizedBy != null) {
      map['void_authorized_by'] = Variable<String>(voidAuthorizedBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      taxRate: Value(taxRate),
      customNotes: customNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(customNotes),
      courseNumber: Value(courseNumber),
      isFired: Value(isFired),
      status: Value(status),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
      voidAuthorizedBy: voidAuthorizedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(voidAuthorizedBy),
      createdAt: Value(createdAt),
    );
  }

  factory OrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      customNotes: serializer.fromJson<String?>(json['customNotes']),
      courseNumber: serializer.fromJson<int>(json['courseNumber']),
      isFired: serializer.fromJson<bool>(json['isFired']),
      status: serializer.fromJson<String>(json['status']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
      voidAuthorizedBy: serializer.fromJson<String?>(json['voidAuthorizedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'taxRate': serializer.toJson<double>(taxRate),
      'customNotes': serializer.toJson<String?>(customNotes),
      'courseNumber': serializer.toJson<int>(courseNumber),
      'isFired': serializer.toJson<bool>(isFired),
      'status': serializer.toJson<String>(status),
      'voidReason': serializer.toJson<String?>(voidReason),
      'voidAuthorizedBy': serializer.toJson<String?>(voidAuthorizedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OrderItem copyWith({
    String? id,
    String? orderId,
    String? productId,
    double? quantity,
    double? unitPrice,
    double? taxRate,
    Value<String?> customNotes = const Value.absent(),
    int? courseNumber,
    bool? isFired,
    String? status,
    Value<String?> voidReason = const Value.absent(),
    Value<String?> voidAuthorizedBy = const Value.absent(),
    DateTime? createdAt,
  }) => OrderItem(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    taxRate: taxRate ?? this.taxRate,
    customNotes: customNotes.present ? customNotes.value : this.customNotes,
    courseNumber: courseNumber ?? this.courseNumber,
    isFired: isFired ?? this.isFired,
    status: status ?? this.status,
    voidReason: voidReason.present ? voidReason.value : this.voidReason,
    voidAuthorizedBy: voidAuthorizedBy.present
        ? voidAuthorizedBy.value
        : this.voidAuthorizedBy,
    createdAt: createdAt ?? this.createdAt,
  );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      customNotes: data.customNotes.present
          ? data.customNotes.value
          : this.customNotes,
      courseNumber: data.courseNumber.present
          ? data.courseNumber.value
          : this.courseNumber,
      isFired: data.isFired.present ? data.isFired.value : this.isFired,
      status: data.status.present ? data.status.value : this.status,
      voidReason: data.voidReason.present
          ? data.voidReason.value
          : this.voidReason,
      voidAuthorizedBy: data.voidAuthorizedBy.present
          ? data.voidAuthorizedBy.value
          : this.voidAuthorizedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('customNotes: $customNotes, ')
          ..write('courseNumber: $courseNumber, ')
          ..write('isFired: $isFired, ')
          ..write('status: $status, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidAuthorizedBy: $voidAuthorizedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    productId,
    quantity,
    unitPrice,
    taxRate,
    customNotes,
    courseNumber,
    isFired,
    status,
    voidReason,
    voidAuthorizedBy,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.taxRate == this.taxRate &&
          other.customNotes == this.customNotes &&
          other.courseNumber == this.courseNumber &&
          other.isFired == this.isFired &&
          other.status == this.status &&
          other.voidReason == this.voidReason &&
          other.voidAuthorizedBy == this.voidAuthorizedBy &&
          other.createdAt == this.createdAt);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> taxRate;
  final Value<String?> customNotes;
  final Value<int> courseNumber;
  final Value<bool> isFired;
  final Value<String> status;
  final Value<String?> voidReason;
  final Value<String?> voidAuthorizedBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.customNotes = const Value.absent(),
    this.courseNumber = const Value.absent(),
    this.isFired = const Value.absent(),
    this.status = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidAuthorizedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String productId,
    required double quantity,
    required double unitPrice,
    required double taxRate,
    this.customNotes = const Value.absent(),
    this.courseNumber = const Value.absent(),
    this.isFired = const Value.absent(),
    this.status = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidAuthorizedBy = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : orderId = Value(orderId),
       productId = Value(productId),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice),
       taxRate = Value(taxRate),
       createdAt = Value(createdAt);
  static Insertable<OrderItem> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? taxRate,
    Expression<String>? customNotes,
    Expression<int>? courseNumber,
    Expression<bool>? isFired,
    Expression<String>? status,
    Expression<String>? voidReason,
    Expression<String>? voidAuthorizedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (taxRate != null) 'tax_rate': taxRate,
      if (customNotes != null) 'custom_notes': customNotes,
      if (courseNumber != null) 'course_number': courseNumber,
      if (isFired != null) 'is_fired': isFired,
      if (status != null) 'status': status,
      if (voidReason != null) 'void_reason': voidReason,
      if (voidAuthorizedBy != null) 'void_authorized_by': voidAuthorizedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? productId,
    Value<double>? quantity,
    Value<double>? unitPrice,
    Value<double>? taxRate,
    Value<String?>? customNotes,
    Value<int>? courseNumber,
    Value<bool>? isFired,
    Value<String>? status,
    Value<String?>? voidReason,
    Value<String?>? voidAuthorizedBy,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      taxRate: taxRate ?? this.taxRate,
      customNotes: customNotes ?? this.customNotes,
      courseNumber: courseNumber ?? this.courseNumber,
      isFired: isFired ?? this.isFired,
      status: status ?? this.status,
      voidReason: voidReason ?? this.voidReason,
      voidAuthorizedBy: voidAuthorizedBy ?? this.voidAuthorizedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (customNotes.present) {
      map['custom_notes'] = Variable<String>(customNotes.value);
    }
    if (courseNumber.present) {
      map['course_number'] = Variable<int>(courseNumber.value);
    }
    if (isFired.present) {
      map['is_fired'] = Variable<bool>(isFired.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (voidAuthorizedBy.present) {
      map['void_authorized_by'] = Variable<String>(voidAuthorizedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('customNotes: $customNotes, ')
          ..write('courseNumber: $courseNumber, ')
          ..write('isFired: $isFired, ')
          ..write('status: $status, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidAuthorizedBy: $voidAuthorizedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemModifiersTable extends OrderItemModifiers
    with TableInfo<$OrderItemModifiersTable, OrderItemModifier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemModifiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _orderItemIdMeta = const VerificationMeta(
    'orderItemId',
  );
  @override
  late final GeneratedColumn<String> orderItemId = GeneratedColumn<String>(
    'order_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES order_items (id)',
    ),
  );
  static const VerificationMeta _modifierOptionIdMeta = const VerificationMeta(
    'modifierOptionId',
  );
  @override
  late final GeneratedColumn<String> modifierOptionId = GeneratedColumn<String>(
    'modifier_option_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modifier_options (id)',
    ),
  );
  static const VerificationMeta _priceExtraMeta = const VerificationMeta(
    'priceExtra',
  );
  @override
  late final GeneratedColumn<double> priceExtra = GeneratedColumn<double>(
    'price_extra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderItemId,
    modifierOptionId,
    priceExtra,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_item_modifiers';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemModifier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_item_id')) {
      context.handle(
        _orderItemIdMeta,
        orderItemId.isAcceptableOrUnknown(
          data['order_item_id']!,
          _orderItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderItemIdMeta);
    }
    if (data.containsKey('modifier_option_id')) {
      context.handle(
        _modifierOptionIdMeta,
        modifierOptionId.isAcceptableOrUnknown(
          data['modifier_option_id']!,
          _modifierOptionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modifierOptionIdMeta);
    }
    if (data.containsKey('price_extra')) {
      context.handle(
        _priceExtraMeta,
        priceExtra.isAcceptableOrUnknown(data['price_extra']!, _priceExtraMeta),
      );
    } else if (isInserting) {
      context.missing(_priceExtraMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemModifier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemModifier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_item_id'],
      )!,
      modifierOptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modifier_option_id'],
      )!,
      priceExtra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_extra'],
      )!,
    );
  }

  @override
  $OrderItemModifiersTable createAlias(String alias) {
    return $OrderItemModifiersTable(attachedDatabase, alias);
  }
}

class OrderItemModifier extends DataClass
    implements Insertable<OrderItemModifier> {
  final String id;
  final String orderItemId;
  final String modifierOptionId;
  final double priceExtra;
  const OrderItemModifier({
    required this.id,
    required this.orderItemId,
    required this.modifierOptionId,
    required this.priceExtra,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_item_id'] = Variable<String>(orderItemId);
    map['modifier_option_id'] = Variable<String>(modifierOptionId);
    map['price_extra'] = Variable<double>(priceExtra);
    return map;
  }

  OrderItemModifiersCompanion toCompanion(bool nullToAbsent) {
    return OrderItemModifiersCompanion(
      id: Value(id),
      orderItemId: Value(orderItemId),
      modifierOptionId: Value(modifierOptionId),
      priceExtra: Value(priceExtra),
    );
  }

  factory OrderItemModifier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemModifier(
      id: serializer.fromJson<String>(json['id']),
      orderItemId: serializer.fromJson<String>(json['orderItemId']),
      modifierOptionId: serializer.fromJson<String>(json['modifierOptionId']),
      priceExtra: serializer.fromJson<double>(json['priceExtra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderItemId': serializer.toJson<String>(orderItemId),
      'modifierOptionId': serializer.toJson<String>(modifierOptionId),
      'priceExtra': serializer.toJson<double>(priceExtra),
    };
  }

  OrderItemModifier copyWith({
    String? id,
    String? orderItemId,
    String? modifierOptionId,
    double? priceExtra,
  }) => OrderItemModifier(
    id: id ?? this.id,
    orderItemId: orderItemId ?? this.orderItemId,
    modifierOptionId: modifierOptionId ?? this.modifierOptionId,
    priceExtra: priceExtra ?? this.priceExtra,
  );
  OrderItemModifier copyWithCompanion(OrderItemModifiersCompanion data) {
    return OrderItemModifier(
      id: data.id.present ? data.id.value : this.id,
      orderItemId: data.orderItemId.present
          ? data.orderItemId.value
          : this.orderItemId,
      modifierOptionId: data.modifierOptionId.present
          ? data.modifierOptionId.value
          : this.modifierOptionId,
      priceExtra: data.priceExtra.present
          ? data.priceExtra.value
          : this.priceExtra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemModifier(')
          ..write('id: $id, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('modifierOptionId: $modifierOptionId, ')
          ..write('priceExtra: $priceExtra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderItemId, modifierOptionId, priceExtra);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemModifier &&
          other.id == this.id &&
          other.orderItemId == this.orderItemId &&
          other.modifierOptionId == this.modifierOptionId &&
          other.priceExtra == this.priceExtra);
}

class OrderItemModifiersCompanion extends UpdateCompanion<OrderItemModifier> {
  final Value<String> id;
  final Value<String> orderItemId;
  final Value<String> modifierOptionId;
  final Value<double> priceExtra;
  final Value<int> rowid;
  const OrderItemModifiersCompanion({
    this.id = const Value.absent(),
    this.orderItemId = const Value.absent(),
    this.modifierOptionId = const Value.absent(),
    this.priceExtra = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemModifiersCompanion.insert({
    this.id = const Value.absent(),
    required String orderItemId,
    required String modifierOptionId,
    required double priceExtra,
    this.rowid = const Value.absent(),
  }) : orderItemId = Value(orderItemId),
       modifierOptionId = Value(modifierOptionId),
       priceExtra = Value(priceExtra);
  static Insertable<OrderItemModifier> custom({
    Expression<String>? id,
    Expression<String>? orderItemId,
    Expression<String>? modifierOptionId,
    Expression<double>? priceExtra,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderItemId != null) 'order_item_id': orderItemId,
      if (modifierOptionId != null) 'modifier_option_id': modifierOptionId,
      if (priceExtra != null) 'price_extra': priceExtra,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemModifiersCompanion copyWith({
    Value<String>? id,
    Value<String>? orderItemId,
    Value<String>? modifierOptionId,
    Value<double>? priceExtra,
    Value<int>? rowid,
  }) {
    return OrderItemModifiersCompanion(
      id: id ?? this.id,
      orderItemId: orderItemId ?? this.orderItemId,
      modifierOptionId: modifierOptionId ?? this.modifierOptionId,
      priceExtra: priceExtra ?? this.priceExtra,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderItemId.present) {
      map['order_item_id'] = Variable<String>(orderItemId.value);
    }
    if (modifierOptionId.present) {
      map['modifier_option_id'] = Variable<String>(modifierOptionId.value);
    }
    if (priceExtra.present) {
      map['price_extra'] = Variable<double>(priceExtra.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemModifiersCompanion(')
          ..write('id: $id, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('modifierOptionId: $modifierOptionId, ')
          ..write('priceExtra: $priceExtra, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiscountsTable extends Discounts
    with TableInfo<$DiscountsTable, Discount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxUsesMeta = const VerificationMeta(
    'maxUses',
  );
  @override
  late final GeneratedColumn<int> maxUses = GeneratedColumn<int>(
    'max_uses',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentUsesMeta = const VerificationMeta(
    'currentUses',
  );
  @override
  late final GeneratedColumn<int> currentUses = GeneratedColumn<int>(
    'current_uses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    value,
    code,
    maxUses,
    currentUses,
    validFrom,
    validUntil,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Discount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('max_uses')) {
      context.handle(
        _maxUsesMeta,
        maxUses.isAcceptableOrUnknown(data['max_uses']!, _maxUsesMeta),
      );
    }
    if (data.containsKey('current_uses')) {
      context.handle(
        _currentUsesMeta,
        currentUses.isAcceptableOrUnknown(
          data['current_uses']!,
          _currentUsesMeta,
        ),
      );
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Discount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Discount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      maxUses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_uses'],
      ),
      currentUses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_uses'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_from'],
      ),
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_until'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $DiscountsTable createAlias(String alias) {
    return $DiscountsTable(attachedDatabase, alias);
  }
}

class Discount extends DataClass implements Insertable<Discount> {
  final String id;
  final String name;
  final String type;
  final double value;
  final String? code;
  final int? maxUses;
  final int currentUses;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool isActive;
  const Discount({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    this.code,
    this.maxUses,
    required this.currentUses,
    this.validFrom,
    this.validUntil,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || maxUses != null) {
      map['max_uses'] = Variable<int>(maxUses);
    }
    map['current_uses'] = Variable<int>(currentUses);
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<DateTime>(validFrom);
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DiscountsCompanion toCompanion(bool nullToAbsent) {
    return DiscountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      value: Value(value),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      maxUses: maxUses == null && nullToAbsent
          ? const Value.absent()
          : Value(maxUses),
      currentUses: Value(currentUses),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      isActive: Value(isActive),
    );
  }

  factory Discount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Discount(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<double>(json['value']),
      code: serializer.fromJson<String?>(json['code']),
      maxUses: serializer.fromJson<int?>(json['maxUses']),
      currentUses: serializer.fromJson<int>(json['currentUses']),
      validFrom: serializer.fromJson<DateTime?>(json['validFrom']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<double>(value),
      'code': serializer.toJson<String?>(code),
      'maxUses': serializer.toJson<int?>(maxUses),
      'currentUses': serializer.toJson<int>(currentUses),
      'validFrom': serializer.toJson<DateTime?>(validFrom),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Discount copyWith({
    String? id,
    String? name,
    String? type,
    double? value,
    Value<String?> code = const Value.absent(),
    Value<int?> maxUses = const Value.absent(),
    int? currentUses,
    Value<DateTime?> validFrom = const Value.absent(),
    Value<DateTime?> validUntil = const Value.absent(),
    bool? isActive,
  }) => Discount(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    value: value ?? this.value,
    code: code.present ? code.value : this.code,
    maxUses: maxUses.present ? maxUses.value : this.maxUses,
    currentUses: currentUses ?? this.currentUses,
    validFrom: validFrom.present ? validFrom.value : this.validFrom,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    isActive: isActive ?? this.isActive,
  );
  Discount copyWithCompanion(DiscountsCompanion data) {
    return Discount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      code: data.code.present ? data.code.value : this.code,
      maxUses: data.maxUses.present ? data.maxUses.value : this.maxUses,
      currentUses: data.currentUses.present
          ? data.currentUses.value
          : this.currentUses,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Discount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('code: $code, ')
          ..write('maxUses: $maxUses, ')
          ..write('currentUses: $currentUses, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    value,
    code,
    maxUses,
    currentUses,
    validFrom,
    validUntil,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Discount &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.value == this.value &&
          other.code == this.code &&
          other.maxUses == this.maxUses &&
          other.currentUses == this.currentUses &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.isActive == this.isActive);
}

class DiscountsCompanion extends UpdateCompanion<Discount> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double> value;
  final Value<String?> code;
  final Value<int?> maxUses;
  final Value<int> currentUses;
  final Value<DateTime?> validFrom;
  final Value<DateTime?> validUntil;
  final Value<bool> isActive;
  final Value<int> rowid;
  const DiscountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.code = const Value.absent(),
    this.maxUses = const Value.absent(),
    this.currentUses = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required double value,
    this.code = const Value.absent(),
    this.maxUses = const Value.absent(),
    this.currentUses = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       value = Value(value);
  static Insertable<Discount> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? value,
    Expression<String>? code,
    Expression<int>? maxUses,
    Expression<int>? currentUses,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validUntil,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (code != null) 'code': code,
      if (maxUses != null) 'max_uses': maxUses,
      if (currentUses != null) 'current_uses': currentUses,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<double>? value,
    Value<String?>? code,
    Value<int?>? maxUses,
    Value<int>? currentUses,
    Value<DateTime?>? validFrom,
    Value<DateTime?>? validUntil,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return DiscountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      code: code ?? this.code,
      maxUses: maxUses ?? this.maxUses,
      currentUses: currentUses ?? this.currentUses,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (maxUses.present) {
      map['max_uses'] = Variable<int>(maxUses.value);
    }
    if (currentUses.present) {
      map['current_uses'] = Variable<int>(currentUses.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('code: $code, ')
          ..write('maxUses: $maxUses, ')
          ..write('currentUses: $currentUses, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    paymentMethod,
    amount,
    reference,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String orderId;
  final String paymentMethod;
  final double amount;
  final String? reference;
  final DateTime paidAt;
  const Payment({
    required this.id,
    required this.orderId,
    required this.paymentMethod,
    required this.amount,
    this.reference,
    required this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['paid_at'] = Variable<DateTime>(paidAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      paymentMethod: Value(paymentMethod),
      amount: Value(amount),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      paidAt: Value(paidAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      amount: serializer.fromJson<double>(json['amount']),
      reference: serializer.fromJson<String?>(json['reference']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'amount': serializer.toJson<double>(amount),
      'reference': serializer.toJson<String?>(reference),
      'paidAt': serializer.toJson<DateTime>(paidAt),
    };
  }

  Payment copyWith({
    String? id,
    String? orderId,
    String? paymentMethod,
    double? amount,
    Value<String?> reference = const Value.absent(),
    DateTime? paidAt,
  }) => Payment(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    amount: amount ?? this.amount,
    reference: reference.present ? reference.value : this.reference,
    paidAt: paidAt ?? this.paidAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      amount: data.amount.present ? data.amount.value : this.amount,
      reference: data.reference.present ? data.reference.value : this.reference,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, paymentMethod, amount, reference, paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.paymentMethod == this.paymentMethod &&
          other.amount == this.amount &&
          other.reference == this.reference &&
          other.paidAt == this.paidAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> paymentMethod;
  final Value<double> amount;
  final Value<String?> reference;
  final Value<DateTime> paidAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.amount = const Value.absent(),
    this.reference = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String paymentMethod,
    required double amount,
    this.reference = const Value.absent(),
    required DateTime paidAt,
    this.rowid = const Value.absent(),
  }) : orderId = Value(orderId),
       paymentMethod = Value(paymentMethod),
       amount = Value(amount),
       paidAt = Value(paidAt);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? paymentMethod,
    Expression<double>? amount,
    Expression<String>? reference,
    Expression<DateTime>? paidAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (amount != null) 'amount': amount,
      if (reference != null) 'reference': reference,
      if (paidAt != null) 'paid_at': paidAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? paymentMethod,
    Value<double>? amount,
    Value<String?>? reference,
    Value<DateTime>? paidAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      reference: reference ?? this.reference,
      paidAt: paidAt ?? this.paidAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('paidAt: $paidAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING_SYNC'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    action,
    payload,
    status,
    retryCount,
    createdAt,
    lastAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String action;
  final String payload;
  final String status;
  final int retryCount;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  const SyncQueueData({
    required this.id,
    required this.action,
    required this.payload,
    required this.status,
    required this.retryCount,
    required this.createdAt,
    this.lastAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['action'] = Variable<String>(action);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      action: Value(action),
      payload: Value(payload),
      status: Value(status),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? action,
    String? payload,
    String? status,
    int? retryCount,
    DateTime? createdAt,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    action: action ?? this.action,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    action,
    payload,
    status,
    retryCount,
    createdAt,
    lastAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> action;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String action,
    required String payload,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : action = Value(action),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? action,
    Value<String>? payload,
    Value<String>? status,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastAttemptAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditTrailTable extends AuditTrail
    with TableInfo<$AuditTrailTable, AuditTrailData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditTrailTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    action,
    targetType,
    targetId,
    details,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_trail';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditTrailData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditTrailData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditTrailData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditTrailTable createAlias(String alias) {
    return $AuditTrailTable(attachedDatabase, alias);
  }
}

class AuditTrailData extends DataClass implements Insertable<AuditTrailData> {
  final String id;
  final String userId;
  final String action;
  final String targetType;
  final String targetId;
  final String? details;
  final DateTime createdAt;
  const AuditTrailData({
    required this.id,
    required this.userId,
    required this.action,
    required this.targetType,
    required this.targetId,
    this.details,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['action'] = Variable<String>(action);
    map['target_type'] = Variable<String>(targetType);
    map['target_id'] = Variable<String>(targetId);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditTrailCompanion toCompanion(bool nullToAbsent) {
    return AuditTrailCompanion(
      id: Value(id),
      userId: Value(userId),
      action: Value(action),
      targetType: Value(targetType),
      targetId: Value(targetId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory AuditTrailData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditTrailData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetId: serializer.fromJson<String>(json['targetId']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'action': serializer.toJson<String>(action),
      'targetType': serializer.toJson<String>(targetType),
      'targetId': serializer.toJson<String>(targetId),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditTrailData copyWith({
    String? id,
    String? userId,
    String? action,
    String? targetType,
    String? targetId,
    Value<String?> details = const Value.absent(),
    DateTime? createdAt,
  }) => AuditTrailData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    action: action ?? this.action,
    targetType: targetType ?? this.targetType,
    targetId: targetId ?? this.targetId,
    details: details.present ? details.value : this.details,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditTrailData copyWithCompanion(AuditTrailCompanion data) {
    return AuditTrailData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditTrailData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, action, targetType, targetId, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditTrailData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.targetType == this.targetType &&
          other.targetId == this.targetId &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class AuditTrailCompanion extends UpdateCompanion<AuditTrailData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> action;
  final Value<String> targetType;
  final Value<String> targetId;
  final Value<String?> details;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditTrailCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetId = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditTrailCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String action,
    required String targetType,
    required String targetId,
    this.details = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       action = Value(action),
       targetType = Value(targetType),
       targetId = Value(targetId),
       createdAt = Value(createdAt);
  static Insertable<AuditTrailData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? targetType,
    Expression<String>? targetId,
    Expression<String>? details,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (targetType != null) 'target_type': targetType,
      if (targetId != null) 'target_id': targetId,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditTrailCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? action,
    Value<String>? targetType,
    Value<String>? targetId,
    Value<String?>? details,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AuditTrailCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditTrailCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VouchersTable extends Vouchers with TableInfo<$VouchersTable, Voucher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VouchersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACTIVE'),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _usedAtMeta = const VerificationMeta('usedAt');
  @override
  late final GeneratedColumn<DateTime> usedAt = GeneratedColumn<DateTime>(
    'used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    amount,
    status,
    orderId,
    usedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vouchers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Voucher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('used_at')) {
      context.handle(
        _usedAtMeta,
        usedAt.isAcceptableOrUnknown(data['used_at']!, _usedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Voucher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Voucher(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      ),
      usedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}used_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VouchersTable createAlias(String alias) {
    return $VouchersTable(attachedDatabase, alias);
  }
}

class Voucher extends DataClass implements Insertable<Voucher> {
  final String id;
  final String code;
  final double amount;
  final String status;
  final String? orderId;
  final DateTime? usedAt;
  final DateTime createdAt;
  const Voucher({
    required this.id,
    required this.code,
    required this.amount,
    required this.status,
    this.orderId,
    this.usedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['amount'] = Variable<double>(amount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<String>(orderId);
    }
    if (!nullToAbsent || usedAt != null) {
      map['used_at'] = Variable<DateTime>(usedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VouchersCompanion toCompanion(bool nullToAbsent) {
    return VouchersCompanion(
      id: Value(id),
      code: Value(code),
      amount: Value(amount),
      status: Value(status),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      usedAt: usedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(usedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Voucher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Voucher(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      amount: serializer.fromJson<double>(json['amount']),
      status: serializer.fromJson<String>(json['status']),
      orderId: serializer.fromJson<String?>(json['orderId']),
      usedAt: serializer.fromJson<DateTime?>(json['usedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'amount': serializer.toJson<double>(amount),
      'status': serializer.toJson<String>(status),
      'orderId': serializer.toJson<String?>(orderId),
      'usedAt': serializer.toJson<DateTime?>(usedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Voucher copyWith({
    String? id,
    String? code,
    double? amount,
    String? status,
    Value<String?> orderId = const Value.absent(),
    Value<DateTime?> usedAt = const Value.absent(),
    DateTime? createdAt,
  }) => Voucher(
    id: id ?? this.id,
    code: code ?? this.code,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    orderId: orderId.present ? orderId.value : this.orderId,
    usedAt: usedAt.present ? usedAt.value : this.usedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Voucher copyWithCompanion(VouchersCompanion data) {
    return Voucher(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      usedAt: data.usedAt.present ? data.usedAt.value : this.usedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Voucher(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('orderId: $orderId, ')
          ..write('usedAt: $usedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, amount, status, orderId, usedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Voucher &&
          other.id == this.id &&
          other.code == this.code &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.orderId == this.orderId &&
          other.usedAt == this.usedAt &&
          other.createdAt == this.createdAt);
}

class VouchersCompanion extends UpdateCompanion<Voucher> {
  final Value<String> id;
  final Value<String> code;
  final Value<double> amount;
  final Value<String> status;
  final Value<String?> orderId;
  final Value<DateTime?> usedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VouchersCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.orderId = const Value.absent(),
    this.usedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VouchersCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required double amount,
    this.status = const Value.absent(),
    this.orderId = const Value.absent(),
    this.usedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<Voucher> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<double>? amount,
    Expression<String>? status,
    Expression<String>? orderId,
    Expression<DateTime>? usedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (orderId != null) 'order_id': orderId,
      if (usedAt != null) 'used_at': usedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VouchersCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<double>? amount,
    Value<String>? status,
    Value<String?>? orderId,
    Value<DateTime?>? usedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VouchersCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      usedAt: usedAt ?? this.usedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (usedAt.present) {
      map['used_at'] = Variable<DateTime>(usedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VouchersCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('orderId: $orderId, ')
          ..write('usedAt: $usedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KitchenNotesTable extends KitchenNotes
    with TableInfo<$KitchenNotesTable, KitchenNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KitchenNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, nameAr, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kitchen_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<KitchenNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KitchenNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KitchenNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $KitchenNotesTable createAlias(String alias) {
    return $KitchenNotesTable(attachedDatabase, alias);
  }
}

class KitchenNote extends DataClass implements Insertable<KitchenNote> {
  final String id;
  final String name;
  final String? nameAr;
  final int sortOrder;
  final bool isActive;
  const KitchenNote({
    required this.id,
    required this.name,
    this.nameAr,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  KitchenNotesCompanion toCompanion(bool nullToAbsent) {
    return KitchenNotesCompanion(
      id: Value(id),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory KitchenNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KitchenNote(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  KitchenNote copyWith({
    String? id,
    String? name,
    Value<String?> nameAr = const Value.absent(),
    int? sortOrder,
    bool? isActive,
  }) => KitchenNote(
    id: id ?? this.id,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  KitchenNote copyWithCompanion(KitchenNotesCompanion data) {
    return KitchenNote(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KitchenNote(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nameAr, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KitchenNote &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class KitchenNotesCompanion extends UpdateCompanion<KitchenNote> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const KitchenNotesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KitchenNotesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameAr = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<KitchenNote> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KitchenNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return KitchenNotesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KitchenNotesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxIdMeta = const VerificationMeta('taxId');
  @override
  late final GeneratedColumn<String> taxId = GeneratedColumn<String>(
    'tax_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountBalanceMeta = const VerificationMeta(
    'accountBalance',
  );
  @override
  late final GeneratedColumn<double> accountBalance = GeneratedColumn<double>(
    'account_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
    'credit_limit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(5000.0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    email,
    address,
    taxId,
    accountBalance,
    creditLimit,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('tax_id')) {
      context.handle(
        _taxIdMeta,
        taxId.isAcceptableOrUnknown(data['tax_id']!, _taxIdMeta),
      );
    }
    if (data.containsKey('account_balance')) {
      context.handle(
        _accountBalanceMeta,
        accountBalance.isAcceptableOrUnknown(
          data['account_balance']!,
          _accountBalanceMeta,
        ),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      taxId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_id'],
      ),
      accountBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}account_balance'],
      )!,
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxId;
  final double accountBalance;
  final double creditLimit;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Customer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.taxId,
    required this.accountBalance,
    required this.creditLimit,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || taxId != null) {
      map['tax_id'] = Variable<String>(taxId);
    }
    map['account_balance'] = Variable<double>(accountBalance);
    map['credit_limit'] = Variable<double>(creditLimit);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      taxId: taxId == null && nullToAbsent
          ? const Value.absent()
          : Value(taxId),
      accountBalance: Value(accountBalance),
      creditLimit: Value(creditLimit),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      taxId: serializer.fromJson<String?>(json['taxId']),
      accountBalance: serializer.fromJson<double>(json['accountBalance']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'taxId': serializer.toJson<String?>(taxId),
      'accountBalance': serializer.toJson<double>(accountBalance),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> taxId = const Value.absent(),
    double? accountBalance,
    double? creditLimit,
    bool? isActive,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    taxId: taxId.present ? taxId.value : this.taxId,
    accountBalance: accountBalance ?? this.accountBalance,
    creditLimit: creditLimit ?? this.creditLimit,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      taxId: data.taxId.present ? data.taxId.value : this.taxId,
      accountBalance: data.accountBalance.present
          ? data.accountBalance.value
          : this.accountBalance,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('taxId: $taxId, ')
          ..write('accountBalance: $accountBalance, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    email,
    address,
    taxId,
    accountBalance,
    creditLimit,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.taxId == this.taxId &&
          other.accountBalance == this.accountBalance &&
          other.creditLimit == this.creditLimit &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> taxId;
  final Value<double> accountBalance;
  final Value<double> creditLimit;
  final Value<bool> isActive;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.taxId = const Value.absent(),
    this.accountBalance = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.taxId = const Value.absent(),
    this.accountBalance = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? taxId,
    Expression<double>? accountBalance,
    Expression<double>? creditLimit,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (taxId != null) 'tax_id': taxId,
      if (accountBalance != null) 'account_balance': accountBalance,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? taxId,
    Value<double>? accountBalance,
    Value<double>? creditLimit,
    Value<bool>? isActive,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      taxId: taxId ?? this.taxId,
      accountBalance: accountBalance ?? this.accountBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (taxId.present) {
      map['tax_id'] = Variable<String>(taxId.value);
    }
    if (accountBalance.present) {
      map['account_balance'] = Variable<double>(accountBalance.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('taxId: $taxId, ')
          ..write('accountBalance: $accountBalance, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RestaurantConfigTable restaurantConfig = $RestaurantConfigTable(
    this,
  );
  late final $UsersTable users = $UsersTable(this);
  late final $SecurityRulesTable securityRules = $SecurityRulesTable(this);
  late final $ZonesTable zones = $ZonesTable(this);
  late final $RestaurantTablesTable restaurantTables = $RestaurantTablesTable(
    this,
  );
  late final $ReservationsTable reservations = $ReservationsTable(this);
  late final $TimeAttendanceTable timeAttendance = $TimeAttendanceTable(this);
  late final $PrintStationsTable printStations = $PrintStationsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ModifierGroupsTable modifierGroups = $ModifierGroupsTable(this);
  late final $ModifierOptionsTable modifierOptions = $ModifierOptionsTable(
    this,
  );
  late final $ProductModifiersTable productModifiers = $ProductModifiersTable(
    this,
  );
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $RecipeItemsTable recipeItems = $RecipeItemsTable(this);
  late final $CashSessionsTable cashSessions = $CashSessionsTable(this);
  late final $CashMovementsTable cashMovements = $CashMovementsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $OrderItemModifiersTable orderItemModifiers =
      $OrderItemModifiersTable(this);
  late final $DiscountsTable discounts = $DiscountsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $AuditTrailTable auditTrail = $AuditTrailTable(this);
  late final $VouchersTable vouchers = $VouchersTable(this);
  late final $KitchenNotesTable kitchenNotes = $KitchenNotesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    restaurantConfig,
    users,
    securityRules,
    zones,
    restaurantTables,
    reservations,
    timeAttendance,
    printStations,
    categories,
    products,
    modifierGroups,
    modifierOptions,
    productModifiers,
    ingredients,
    recipeItems,
    cashSessions,
    cashMovements,
    orders,
    orderItems,
    orderItemModifiers,
    discounts,
    payments,
    syncQueue,
    auditTrail,
    vouchers,
    kitchenNotes,
    customers,
  ];
}

typedef $$RestaurantConfigTableCreateCompanionBuilder =
    RestaurantConfigCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> ice,
      Value<String?> rc,
      Value<String?> identifiantFiscal,
      Value<String> currency,
      Value<String?> logoPath,
      Value<String> defaultServiceMode,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RestaurantConfigTableUpdateCompanionBuilder =
    RestaurantConfigCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> ice,
      Value<String?> rc,
      Value<String?> identifiantFiscal,
      Value<String> currency,
      Value<String?> logoPath,
      Value<String> defaultServiceMode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RestaurantConfigTableFilterComposer
    extends Composer<_$AppDatabase, $RestaurantConfigTable> {
  $$RestaurantConfigTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ice => $composableBuilder(
    column: $table.ice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rc => $composableBuilder(
    column: $table.rc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifiantFiscal => $composableBuilder(
    column: $table.identifiantFiscal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultServiceMode => $composableBuilder(
    column: $table.defaultServiceMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestaurantConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $RestaurantConfigTable> {
  $$RestaurantConfigTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ice => $composableBuilder(
    column: $table.ice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rc => $composableBuilder(
    column: $table.rc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifiantFiscal => $composableBuilder(
    column: $table.identifiantFiscal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultServiceMode => $composableBuilder(
    column: $table.defaultServiceMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestaurantConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestaurantConfigTable> {
  $$RestaurantConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get ice =>
      $composableBuilder(column: $table.ice, builder: (column) => column);

  GeneratedColumn<String> get rc =>
      $composableBuilder(column: $table.rc, builder: (column) => column);

  GeneratedColumn<String> get identifiantFiscal => $composableBuilder(
    column: $table.identifiantFiscal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get defaultServiceMode => $composableBuilder(
    column: $table.defaultServiceMode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RestaurantConfigTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestaurantConfigTable,
          RestaurantConfigData,
          $$RestaurantConfigTableFilterComposer,
          $$RestaurantConfigTableOrderingComposer,
          $$RestaurantConfigTableAnnotationComposer,
          $$RestaurantConfigTableCreateCompanionBuilder,
          $$RestaurantConfigTableUpdateCompanionBuilder,
          (
            RestaurantConfigData,
            BaseReferences<
              _$AppDatabase,
              $RestaurantConfigTable,
              RestaurantConfigData
            >,
          ),
          RestaurantConfigData,
          PrefetchHooks Function()
        > {
  $$RestaurantConfigTableTableManager(
    _$AppDatabase db,
    $RestaurantConfigTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestaurantConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestaurantConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestaurantConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> ice = const Value.absent(),
                Value<String?> rc = const Value.absent(),
                Value<String?> identifiantFiscal = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String> defaultServiceMode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestaurantConfigCompanion(
                id: id,
                name: name,
                address: address,
                phone: phone,
                ice: ice,
                rc: rc,
                identifiantFiscal: identifiantFiscal,
                currency: currency,
                logoPath: logoPath,
                defaultServiceMode: defaultServiceMode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> ice = const Value.absent(),
                Value<String?> rc = const Value.absent(),
                Value<String?> identifiantFiscal = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String> defaultServiceMode = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RestaurantConfigCompanion.insert(
                id: id,
                name: name,
                address: address,
                phone: phone,
                ice: ice,
                rc: rc,
                identifiantFiscal: identifiantFiscal,
                currency: currency,
                logoPath: logoPath,
                defaultServiceMode: defaultServiceMode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestaurantConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestaurantConfigTable,
      RestaurantConfigData,
      $$RestaurantConfigTableFilterComposer,
      $$RestaurantConfigTableOrderingComposer,
      $$RestaurantConfigTableAnnotationComposer,
      $$RestaurantConfigTableCreateCompanionBuilder,
      $$RestaurantConfigTableUpdateCompanionBuilder,
      (
        RestaurantConfigData,
        BaseReferences<
          _$AppDatabase,
          $RestaurantConfigTable,
          RestaurantConfigData
        >,
      ),
      RestaurantConfigData,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      required String name,
      required String pinHash,
      required String role,
      Value<int> accessLevel,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> pinHash,
      Value<String> role,
      Value<int> accessLevel,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimeAttendanceTable, List<TimeAttendanceData>>
  _timeAttendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeAttendance,
    aliasName: $_aliasNameGenerator(db.users.id, db.timeAttendance.userId),
  );

  $$TimeAttendanceTableProcessedTableManager get timeAttendanceRefs {
    final manager = $$TimeAttendanceTableTableManager(
      $_db,
      $_db.timeAttendance,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeAttendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CashSessionsTable, List<CashSession>>
  _cashSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cashSessions,
    aliasName: $_aliasNameGenerator(db.users.id, db.cashSessions.cashierId),
  );

  $$CashSessionsTableProcessedTableManager get cashSessionsRefs {
    final manager = $$CashSessionsTableTableManager(
      $_db,
      $_db.cashSessions,
    ).filter((f) => f.cashierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cashSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CashMovementsTable, List<CashMovement>>
  _cashMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cashMovements,
    aliasName: $_aliasNameGenerator(db.users.id, db.cashMovements.userId),
  );

  $$CashMovementsTableProcessedTableManager get cashMovementsRefs {
    final manager = $$CashMovementsTableTableManager(
      $_db,
      $_db.cashMovements,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cashMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>> _order_waiterTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: $_aliasNameGenerator(db.users.id, db.orders.waiterId),
  );

  $$OrdersTableProcessedTableManager get order_waiter {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.waiterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_order_waiterTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>>
  _order_discount_authorizerTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orders,
        aliasName: $_aliasNameGenerator(
          db.users.id,
          db.orders.discountAuthorizedBy,
        ),
      );

  $$OrdersTableProcessedTableManager get order_discount_authorizer {
    final manager = $$OrdersTableTableManager($_db, $_db.orders).filter(
      (f) => f.discountAuthorizedBy.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(
      _order_discount_authorizerTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _order_item_void_authorizerTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderItems,
        aliasName: $_aliasNameGenerator(
          db.users.id,
          db.orderItems.voidAuthorizedBy,
        ),
      );

  $$OrderItemsTableProcessedTableManager get order_item_void_authorizer {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems).filter(
      (f) => f.voidAuthorizedBy.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(
      _order_item_void_authorizerTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AuditTrailTable, List<AuditTrailData>>
  _auditTrailRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditTrail,
    aliasName: $_aliasNameGenerator(db.users.id, db.auditTrail.userId),
  );

  $$AuditTrailTableProcessedTableManager get auditTrailRefs {
    final manager = $$AuditTrailTableTableManager(
      $_db,
      $_db.auditTrail,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditTrailRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accessLevel => $composableBuilder(
    column: $table.accessLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timeAttendanceRefs(
    Expression<bool> Function($$TimeAttendanceTableFilterComposer f) f,
  ) {
    final $$TimeAttendanceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeAttendance,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeAttendanceTableFilterComposer(
            $db: $db,
            $table: $db.timeAttendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cashSessionsRefs(
    Expression<bool> Function($$CashSessionsTableFilterComposer f) f,
  ) {
    final $$CashSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.cashierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableFilterComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cashMovementsRefs(
    Expression<bool> Function($$CashMovementsTableFilterComposer f) f,
  ) {
    final $$CashMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashMovements,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashMovementsTableFilterComposer(
            $db: $db,
            $table: $db.cashMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> order_waiter(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.waiterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> order_discount_authorizer(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.discountAuthorizedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> order_item_void_authorizer(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.voidAuthorizedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> auditTrailRefs(
    Expression<bool> Function($$AuditTrailTableFilterComposer f) f,
  ) {
    final $$AuditTrailTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditTrail,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditTrailTableFilterComposer(
            $db: $db,
            $table: $db.auditTrail,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accessLevel => $composableBuilder(
    column: $table.accessLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get accessLevel => $composableBuilder(
    column: $table.accessLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> timeAttendanceRefs<T extends Object>(
    Expression<T> Function($$TimeAttendanceTableAnnotationComposer a) f,
  ) {
    final $$TimeAttendanceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeAttendance,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeAttendanceTableAnnotationComposer(
            $db: $db,
            $table: $db.timeAttendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cashSessionsRefs<T extends Object>(
    Expression<T> Function($$CashSessionsTableAnnotationComposer a) f,
  ) {
    final $$CashSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.cashierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cashMovementsRefs<T extends Object>(
    Expression<T> Function($$CashMovementsTableAnnotationComposer a) f,
  ) {
    final $$CashMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashMovements,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.cashMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> order_waiter<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.waiterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> order_discount_authorizer<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.discountAuthorizedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> order_item_void_authorizer<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.voidAuthorizedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> auditTrailRefs<T extends Object>(
    Expression<T> Function($$AuditTrailTableAnnotationComposer a) f,
  ) {
    final $$AuditTrailTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditTrail,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditTrailTableAnnotationComposer(
            $db: $db,
            $table: $db.auditTrail,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({
            bool timeAttendanceRefs,
            bool cashSessionsRefs,
            bool cashMovementsRefs,
            bool order_waiter,
            bool order_discount_authorizer,
            bool order_item_void_authorizer,
            bool auditTrailRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> accessLevel = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                pinHash: pinHash,
                role: role,
                accessLevel: accessLevel,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                required String pinHash,
                required String role,
                Value<int> accessLevel = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                pinHash: pinHash,
                role: role,
                accessLevel: accessLevel,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                timeAttendanceRefs = false,
                cashSessionsRefs = false,
                cashMovementsRefs = false,
                order_waiter = false,
                order_discount_authorizer = false,
                order_item_void_authorizer = false,
                auditTrailRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timeAttendanceRefs) db.timeAttendance,
                    if (cashSessionsRefs) db.cashSessions,
                    if (cashMovementsRefs) db.cashMovements,
                    if (order_waiter) db.orders,
                    if (order_discount_authorizer) db.orders,
                    if (order_item_void_authorizer) db.orderItems,
                    if (auditTrailRefs) db.auditTrail,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timeAttendanceRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          TimeAttendanceData
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._timeAttendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).timeAttendanceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cashSessionsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          CashSession
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._cashSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).cashSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cashierId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cashMovementsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          CashMovement
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._cashMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).cashMovementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (order_waiter)
                        await $_getPrefetchedData<User, $UsersTable, Order>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._order_waiterTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).order_waiter,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.waiterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (order_discount_authorizer)
                        await $_getPrefetchedData<User, $UsersTable, Order>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._order_discount_authorizerTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).order_discount_authorizer,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.discountAuthorizedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (order_item_void_authorizer)
                        await $_getPrefetchedData<User, $UsersTable, OrderItem>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._order_item_void_authorizerTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).order_item_void_authorizer,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.voidAuthorizedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (auditTrailRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          AuditTrailData
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._auditTrailRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).auditTrailRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({
        bool timeAttendanceRefs,
        bool cashSessionsRefs,
        bool cashMovementsRefs,
        bool order_waiter,
        bool order_discount_authorizer,
        bool order_item_void_authorizer,
        bool auditTrailRefs,
      })
    >;
typedef $$SecurityRulesTableCreateCompanionBuilder =
    SecurityRulesCompanion Function({
      required String operationKey,
      required String category,
      required String label,
      Value<int> requiredLevel,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$SecurityRulesTableUpdateCompanionBuilder =
    SecurityRulesCompanion Function({
      Value<String> operationKey,
      Value<String> category,
      Value<String> label,
      Value<int> requiredLevel,
      Value<String?> description,
      Value<int> rowid,
    });

class $$SecurityRulesTableFilterComposer
    extends Composer<_$AppDatabase, $SecurityRulesTable> {
  $$SecurityRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationKey => $composableBuilder(
    column: $table.operationKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requiredLevel => $composableBuilder(
    column: $table.requiredLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SecurityRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $SecurityRulesTable> {
  $$SecurityRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationKey => $composableBuilder(
    column: $table.operationKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requiredLevel => $composableBuilder(
    column: $table.requiredLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SecurityRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SecurityRulesTable> {
  $$SecurityRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationKey => $composableBuilder(
    column: $table.operationKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get requiredLevel => $composableBuilder(
    column: $table.requiredLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$SecurityRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SecurityRulesTable,
          SecurityRule,
          $$SecurityRulesTableFilterComposer,
          $$SecurityRulesTableOrderingComposer,
          $$SecurityRulesTableAnnotationComposer,
          $$SecurityRulesTableCreateCompanionBuilder,
          $$SecurityRulesTableUpdateCompanionBuilder,
          (
            SecurityRule,
            BaseReferences<_$AppDatabase, $SecurityRulesTable, SecurityRule>,
          ),
          SecurityRule,
          PrefetchHooks Function()
        > {
  $$SecurityRulesTableTableManager(_$AppDatabase db, $SecurityRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SecurityRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SecurityRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SecurityRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> operationKey = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> requiredLevel = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SecurityRulesCompanion(
                operationKey: operationKey,
                category: category,
                label: label,
                requiredLevel: requiredLevel,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationKey,
                required String category,
                required String label,
                Value<int> requiredLevel = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SecurityRulesCompanion.insert(
                operationKey: operationKey,
                category: category,
                label: label,
                requiredLevel: requiredLevel,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SecurityRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SecurityRulesTable,
      SecurityRule,
      $$SecurityRulesTableFilterComposer,
      $$SecurityRulesTableOrderingComposer,
      $$SecurityRulesTableAnnotationComposer,
      $$SecurityRulesTableCreateCompanionBuilder,
      $$SecurityRulesTableUpdateCompanionBuilder,
      (
        SecurityRule,
        BaseReferences<_$AppDatabase, $SecurityRulesTable, SecurityRule>,
      ),
      SecurityRule,
      PrefetchHooks Function()
    >;
typedef $$ZonesTableCreateCompanionBuilder =
    ZonesCompanion Function({
      Value<String> id,
      required String name,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$ZonesTableUpdateCompanionBuilder =
    ZonesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$ZonesTableReferences
    extends BaseReferences<_$AppDatabase, $ZonesTable, Zone> {
  $$ZonesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RestaurantTablesTable, List<RestaurantTable>>
  _restaurantTablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.restaurantTables,
    aliasName: $_aliasNameGenerator(db.zones.id, db.restaurantTables.zoneId),
  );

  $$RestaurantTablesTableProcessedTableManager get restaurantTablesRefs {
    final manager = $$RestaurantTablesTableTableManager(
      $_db,
      $_db.restaurantTables,
    ).filter((f) => f.zoneId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _restaurantTablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ZonesTableFilterComposer extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> restaurantTablesRefs(
    Expression<bool> Function($$RestaurantTablesTableFilterComposer f) f,
  ) {
    final $$RestaurantTablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.zoneId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableFilterComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZonesTableOrderingComposer
    extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ZonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> restaurantTablesRefs<T extends Object>(
    Expression<T> Function($$RestaurantTablesTableAnnotationComposer a) f,
  ) {
    final $$RestaurantTablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.zoneId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableAnnotationComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZonesTable,
          Zone,
          $$ZonesTableFilterComposer,
          $$ZonesTableOrderingComposer,
          $$ZonesTableAnnotationComposer,
          $$ZonesTableCreateCompanionBuilder,
          $$ZonesTableUpdateCompanionBuilder,
          (Zone, $$ZonesTableReferences),
          Zone,
          PrefetchHooks Function({bool restaurantTablesRefs})
        > {
  $$ZonesTableTableManager(_$AppDatabase db, $ZonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZonesCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZonesCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ZonesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({restaurantTablesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (restaurantTablesRefs) db.restaurantTables,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (restaurantTablesRefs)
                    await $_getPrefetchedData<
                      Zone,
                      $ZonesTable,
                      RestaurantTable
                    >(
                      currentTable: table,
                      referencedTable: $$ZonesTableReferences
                          ._restaurantTablesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ZonesTableReferences(
                        db,
                        table,
                        p0,
                      ).restaurantTablesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.zoneId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ZonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZonesTable,
      Zone,
      $$ZonesTableFilterComposer,
      $$ZonesTableOrderingComposer,
      $$ZonesTableAnnotationComposer,
      $$ZonesTableCreateCompanionBuilder,
      $$ZonesTableUpdateCompanionBuilder,
      (Zone, $$ZonesTableReferences),
      Zone,
      PrefetchHooks Function({bool restaurantTablesRefs})
    >;
typedef $$RestaurantTablesTableCreateCompanionBuilder =
    RestaurantTablesCompanion Function({
      Value<String> id,
      required String zoneId,
      required String name,
      required int capacity,
      Value<String> status,
      Value<double?> posX,
      Value<double?> posY,
      Value<int> rowid,
    });
typedef $$RestaurantTablesTableUpdateCompanionBuilder =
    RestaurantTablesCompanion Function({
      Value<String> id,
      Value<String> zoneId,
      Value<String> name,
      Value<int> capacity,
      Value<String> status,
      Value<double?> posX,
      Value<double?> posY,
      Value<int> rowid,
    });

final class $$RestaurantTablesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RestaurantTablesTable, RestaurantTable> {
  $$RestaurantTablesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ZonesTable _zoneIdTable(_$AppDatabase db) => db.zones.createAlias(
    $_aliasNameGenerator(db.restaurantTables.zoneId, db.zones.id),
  );

  $$ZonesTableProcessedTableManager get zoneId {
    final $_column = $_itemColumn<String>('zone_id')!;

    final manager = $$ZonesTableTableManager(
      $_db,
      $_db.zones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_zoneIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReservationsTable, List<Reservation>>
  _reservationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reservations,
    aliasName: $_aliasNameGenerator(
      db.restaurantTables.id,
      db.reservations.tableId,
    ),
  );

  $$ReservationsTableProcessedTableManager get reservationsRefs {
    final manager = $$ReservationsTableTableManager(
      $_db,
      $_db.reservations,
    ).filter((f) => f.tableId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reservationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: $_aliasNameGenerator(db.restaurantTables.id, db.orders.tableId),
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.tableId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RestaurantTablesTableFilterComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get posX => $composableBuilder(
    column: $table.posX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get posY => $composableBuilder(
    column: $table.posY,
    builder: (column) => ColumnFilters(column),
  );

  $$ZonesTableFilterComposer get zoneId {
    final $$ZonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zoneId,
      referencedTable: $db.zones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonesTableFilterComposer(
            $db: $db,
            $table: $db.zones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reservationsRefs(
    Expression<bool> Function($$ReservationsTableFilterComposer f) f,
  ) {
    final $$ReservationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reservations,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReservationsTableFilterComposer(
            $db: $db,
            $table: $db.reservations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RestaurantTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get posX => $composableBuilder(
    column: $table.posX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get posY => $composableBuilder(
    column: $table.posY,
    builder: (column) => ColumnOrderings(column),
  );

  $$ZonesTableOrderingComposer get zoneId {
    final $$ZonesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zoneId,
      referencedTable: $db.zones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonesTableOrderingComposer(
            $db: $db,
            $table: $db.zones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RestaurantTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get posX =>
      $composableBuilder(column: $table.posX, builder: (column) => column);

  GeneratedColumn<double> get posY =>
      $composableBuilder(column: $table.posY, builder: (column) => column);

  $$ZonesTableAnnotationComposer get zoneId {
    final $$ZonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zoneId,
      referencedTable: $db.zones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonesTableAnnotationComposer(
            $db: $db,
            $table: $db.zones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reservationsRefs<T extends Object>(
    Expression<T> Function($$ReservationsTableAnnotationComposer a) f,
  ) {
    final $$ReservationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reservations,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReservationsTableAnnotationComposer(
            $db: $db,
            $table: $db.reservations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RestaurantTablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestaurantTablesTable,
          RestaurantTable,
          $$RestaurantTablesTableFilterComposer,
          $$RestaurantTablesTableOrderingComposer,
          $$RestaurantTablesTableAnnotationComposer,
          $$RestaurantTablesTableCreateCompanionBuilder,
          $$RestaurantTablesTableUpdateCompanionBuilder,
          (RestaurantTable, $$RestaurantTablesTableReferences),
          RestaurantTable,
          PrefetchHooks Function({
            bool zoneId,
            bool reservationsRefs,
            bool ordersRefs,
          })
        > {
  $$RestaurantTablesTableTableManager(
    _$AppDatabase db,
    $RestaurantTablesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestaurantTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestaurantTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestaurantTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> zoneId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> capacity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> posX = const Value.absent(),
                Value<double?> posY = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestaurantTablesCompanion(
                id: id,
                zoneId: zoneId,
                name: name,
                capacity: capacity,
                status: status,
                posX: posX,
                posY: posY,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String zoneId,
                required String name,
                required int capacity,
                Value<String> status = const Value.absent(),
                Value<double?> posX = const Value.absent(),
                Value<double?> posY = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestaurantTablesCompanion.insert(
                id: id,
                zoneId: zoneId,
                name: name,
                capacity: capacity,
                status: status,
                posX: posX,
                posY: posY,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RestaurantTablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({zoneId = false, reservationsRefs = false, ordersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reservationsRefs) db.reservations,
                    if (ordersRefs) db.orders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (zoneId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.zoneId,
                                    referencedTable:
                                        $$RestaurantTablesTableReferences
                                            ._zoneIdTable(db),
                                    referencedColumn:
                                        $$RestaurantTablesTableReferences
                                            ._zoneIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reservationsRefs)
                        await $_getPrefetchedData<
                          RestaurantTable,
                          $RestaurantTablesTable,
                          Reservation
                        >(
                          currentTable: table,
                          referencedTable: $$RestaurantTablesTableReferences
                              ._reservationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RestaurantTablesTableReferences(
                                db,
                                table,
                                p0,
                              ).reservationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tableId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          RestaurantTable,
                          $RestaurantTablesTable,
                          Order
                        >(
                          currentTable: table,
                          referencedTable: $$RestaurantTablesTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RestaurantTablesTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tableId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RestaurantTablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestaurantTablesTable,
      RestaurantTable,
      $$RestaurantTablesTableFilterComposer,
      $$RestaurantTablesTableOrderingComposer,
      $$RestaurantTablesTableAnnotationComposer,
      $$RestaurantTablesTableCreateCompanionBuilder,
      $$RestaurantTablesTableUpdateCompanionBuilder,
      (RestaurantTable, $$RestaurantTablesTableReferences),
      RestaurantTable,
      PrefetchHooks Function({
        bool zoneId,
        bool reservationsRefs,
        bool ordersRefs,
      })
    >;
typedef $$ReservationsTableCreateCompanionBuilder =
    ReservationsCompanion Function({
      Value<String> id,
      required String tableId,
      required String customerName,
      Value<String?> customerPhone,
      required int guestCount,
      required DateTime reservedAt,
      Value<String?> notes,
      Value<String> status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReservationsTableUpdateCompanionBuilder =
    ReservationsCompanion Function({
      Value<String> id,
      Value<String> tableId,
      Value<String> customerName,
      Value<String?> customerPhone,
      Value<int> guestCount,
      Value<DateTime> reservedAt,
      Value<String?> notes,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ReservationsTableReferences
    extends BaseReferences<_$AppDatabase, $ReservationsTable, Reservation> {
  $$ReservationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RestaurantTablesTable _tableIdTable(_$AppDatabase db) =>
      db.restaurantTables.createAlias(
        $_aliasNameGenerator(db.reservations.tableId, db.restaurantTables.id),
      );

  $$RestaurantTablesTableProcessedTableManager get tableId {
    final $_column = $_itemColumn<String>('table_id')!;

    final manager = $$RestaurantTablesTableTableManager(
      $_db,
      $_db.restaurantTables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReservationsTableFilterComposer
    extends Composer<_$AppDatabase, $ReservationsTable> {
  $$ReservationsTableFilterComposer({
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

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reservedAt => $composableBuilder(
    column: $table.reservedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RestaurantTablesTableFilterComposer get tableId {
    final $$RestaurantTablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableFilterComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReservationsTable> {
  $$ReservationsTableOrderingComposer({
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

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reservedAt => $composableBuilder(
    column: $table.reservedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RestaurantTablesTableOrderingComposer get tableId {
    final $$RestaurantTablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableOrderingComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReservationsTable> {
  $$ReservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reservedAt => $composableBuilder(
    column: $table.reservedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RestaurantTablesTableAnnotationComposer get tableId {
    final $$RestaurantTablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableAnnotationComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReservationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReservationsTable,
          Reservation,
          $$ReservationsTableFilterComposer,
          $$ReservationsTableOrderingComposer,
          $$ReservationsTableAnnotationComposer,
          $$ReservationsTableCreateCompanionBuilder,
          $$ReservationsTableUpdateCompanionBuilder,
          (Reservation, $$ReservationsTableReferences),
          Reservation,
          PrefetchHooks Function({bool tableId})
        > {
  $$ReservationsTableTableManager(_$AppDatabase db, $ReservationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tableId = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<int> guestCount = const Value.absent(),
                Value<DateTime> reservedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReservationsCompanion(
                id: id,
                tableId: tableId,
                customerName: customerName,
                customerPhone: customerPhone,
                guestCount: guestCount,
                reservedAt: reservedAt,
                notes: notes,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String tableId,
                required String customerName,
                Value<String?> customerPhone = const Value.absent(),
                required int guestCount,
                required DateTime reservedAt,
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReservationsCompanion.insert(
                id: id,
                tableId: tableId,
                customerName: customerName,
                customerPhone: customerPhone,
                guestCount: guestCount,
                reservedAt: reservedAt,
                notes: notes,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReservationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tableId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tableId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tableId,
                                referencedTable: $$ReservationsTableReferences
                                    ._tableIdTable(db),
                                referencedColumn: $$ReservationsTableReferences
                                    ._tableIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReservationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReservationsTable,
      Reservation,
      $$ReservationsTableFilterComposer,
      $$ReservationsTableOrderingComposer,
      $$ReservationsTableAnnotationComposer,
      $$ReservationsTableCreateCompanionBuilder,
      $$ReservationsTableUpdateCompanionBuilder,
      (Reservation, $$ReservationsTableReferences),
      Reservation,
      PrefetchHooks Function({bool tableId})
    >;
typedef $$TimeAttendanceTableCreateCompanionBuilder =
    TimeAttendanceCompanion Function({
      Value<String> id,
      required String userId,
      required DateTime clockIn,
      Value<DateTime?> clockOut,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TimeAttendanceTableUpdateCompanionBuilder =
    TimeAttendanceCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> clockIn,
      Value<DateTime?> clockOut,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TimeAttendanceTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TimeAttendanceTable,
          TimeAttendanceData
        > {
  $$TimeAttendanceTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.timeAttendance.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimeAttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $TimeAttendanceTable> {
  $$TimeAttendanceTableFilterComposer({
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

  ColumnFilters<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeAttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeAttendanceTable> {
  $$TimeAttendanceTableOrderingComposer({
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

  ColumnOrderings<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeAttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeAttendanceTable> {
  $$TimeAttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<DateTime> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeAttendanceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeAttendanceTable,
          TimeAttendanceData,
          $$TimeAttendanceTableFilterComposer,
          $$TimeAttendanceTableOrderingComposer,
          $$TimeAttendanceTableAnnotationComposer,
          $$TimeAttendanceTableCreateCompanionBuilder,
          $$TimeAttendanceTableUpdateCompanionBuilder,
          (TimeAttendanceData, $$TimeAttendanceTableReferences),
          TimeAttendanceData,
          PrefetchHooks Function({bool userId})
        > {
  $$TimeAttendanceTableTableManager(
    _$AppDatabase db,
    $TimeAttendanceTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeAttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeAttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeAttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> clockIn = const Value.absent(),
                Value<DateTime?> clockOut = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeAttendanceCompanion(
                id: id,
                userId: userId,
                clockIn: clockIn,
                clockOut: clockOut,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String userId,
                required DateTime clockIn,
                Value<DateTime?> clockOut = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TimeAttendanceCompanion.insert(
                id: id,
                userId: userId,
                clockIn: clockIn,
                clockOut: clockOut,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeAttendanceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$TimeAttendanceTableReferences
                                    ._userIdTable(db),
                                referencedColumn:
                                    $$TimeAttendanceTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimeAttendanceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeAttendanceTable,
      TimeAttendanceData,
      $$TimeAttendanceTableFilterComposer,
      $$TimeAttendanceTableOrderingComposer,
      $$TimeAttendanceTableAnnotationComposer,
      $$TimeAttendanceTableCreateCompanionBuilder,
      $$TimeAttendanceTableUpdateCompanionBuilder,
      (TimeAttendanceData, $$TimeAttendanceTableReferences),
      TimeAttendanceData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$PrintStationsTableCreateCompanionBuilder =
    PrintStationsCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> ipAddress,
      Value<String> type,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$PrintStationsTableUpdateCompanionBuilder =
    PrintStationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> ipAddress,
      Value<String> type,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$PrintStationsTableReferences
    extends BaseReferences<_$AppDatabase, $PrintStationsTable, PrintStation> {
  $$PrintStationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CategoriesTable, List<Category>>
  _categoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categories,
    aliasName: $_aliasNameGenerator(
      db.printStations.id,
      db.categories.printStationId,
    ),
  );

  $$CategoriesTableProcessedTableManager get categoriesRefs {
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.printStationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrintStationsTableFilterComposer
    extends Composer<_$AppDatabase, $PrintStationsTable> {
  $$PrintStationsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ipAddress => $composableBuilder(
    column: $table.ipAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoriesRefs(
    Expression<bool> Function($$CategoriesTableFilterComposer f) f,
  ) {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.printStationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrintStationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrintStationsTable> {
  $$PrintStationsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ipAddress => $composableBuilder(
    column: $table.ipAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrintStationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrintStationsTable> {
  $$PrintStationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ipAddress =>
      $composableBuilder(column: $table.ipAddress, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> categoriesRefs<T extends Object>(
    Expression<T> Function($$CategoriesTableAnnotationComposer a) f,
  ) {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.printStationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrintStationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrintStationsTable,
          PrintStation,
          $$PrintStationsTableFilterComposer,
          $$PrintStationsTableOrderingComposer,
          $$PrintStationsTableAnnotationComposer,
          $$PrintStationsTableCreateCompanionBuilder,
          $$PrintStationsTableUpdateCompanionBuilder,
          (PrintStation, $$PrintStationsTableReferences),
          PrintStation,
          PrefetchHooks Function({bool categoriesRefs})
        > {
  $$PrintStationsTableTableManager(_$AppDatabase db, $PrintStationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrintStationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrintStationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrintStationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> ipAddress = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrintStationsCompanion(
                id: id,
                name: name,
                ipAddress: ipAddress,
                type: type,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> ipAddress = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrintStationsCompanion.insert(
                id: id,
                name: name,
                ipAddress: ipAddress,
                type: type,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrintStationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (categoriesRefs) db.categories],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (categoriesRefs)
                    await $_getPrefetchedData<
                      PrintStation,
                      $PrintStationsTable,
                      Category
                    >(
                      currentTable: table,
                      referencedTable: $$PrintStationsTableReferences
                          ._categoriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PrintStationsTableReferences(
                            db,
                            table,
                            p0,
                          ).categoriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.printStationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PrintStationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrintStationsTable,
      PrintStation,
      $$PrintStationsTableFilterComposer,
      $$PrintStationsTableOrderingComposer,
      $$PrintStationsTableAnnotationComposer,
      $$PrintStationsTableCreateCompanionBuilder,
      $$PrintStationsTableUpdateCompanionBuilder,
      (PrintStation, $$PrintStationsTableReferences),
      PrintStation,
      PrefetchHooks Function({bool categoriesRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> nameAr,
      Value<String?> image,
      Value<String?> colorHex,
      Value<String?> printStationId,
      Value<int> sortOrder,
      Value<String?> scheduledStartTime,
      Value<String?> scheduledEndTime,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> nameAr,
      Value<String?> image,
      Value<String?> colorHex,
      Value<String?> printStationId,
      Value<int> sortOrder,
      Value<String?> scheduledStartTime,
      Value<String?> scheduledEndTime,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PrintStationsTable _printStationIdTable(_$AppDatabase db) =>
      db.printStations.createAlias(
        $_aliasNameGenerator(db.categories.printStationId, db.printStations.id),
      );

  $$PrintStationsTableProcessedTableManager? get printStationId {
    final $_column = $_itemColumn<String>('print_station_id');
    if ($_column == null) return null;
    final manager = $$PrintStationsTableTableManager(
      $_db,
      $_db.printStations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_printStationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: $_aliasNameGenerator(db.categories.id, db.products.categoryId),
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledStartTime => $composableBuilder(
    column: $table.scheduledStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledEndTime => $composableBuilder(
    column: $table.scheduledEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$PrintStationsTableFilterComposer get printStationId {
    final $$PrintStationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.printStationId,
      referencedTable: $db.printStations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrintStationsTableFilterComposer(
            $db: $db,
            $table: $db.printStations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledStartTime => $composableBuilder(
    column: $table.scheduledStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledEndTime => $composableBuilder(
    column: $table.scheduledEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrintStationsTableOrderingComposer get printStationId {
    final $$PrintStationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.printStationId,
      referencedTable: $db.printStations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrintStationsTableOrderingComposer(
            $db: $db,
            $table: $db.printStations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get scheduledStartTime => $composableBuilder(
    column: $table.scheduledStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledEndTime => $composableBuilder(
    column: $table.scheduledEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$PrintStationsTableAnnotationComposer get printStationId {
    final $$PrintStationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.printStationId,
      referencedTable: $db.printStations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrintStationsTableAnnotationComposer(
            $db: $db,
            $table: $db.printStations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool printStationId, bool productsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<String?> printStationId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> scheduledStartTime = const Value.absent(),
                Value<String?> scheduledEndTime = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                nameAr: nameAr,
                image: image,
                colorHex: colorHex,
                printStationId: printStationId,
                sortOrder: sortOrder,
                scheduledStartTime: scheduledStartTime,
                scheduledEndTime: scheduledEndTime,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> nameAr = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<String?> printStationId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> scheduledStartTime = const Value.absent(),
                Value<String?> scheduledEndTime = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                nameAr: nameAr,
                image: image,
                colorHex: colorHex,
                printStationId: printStationId,
                sortOrder: sortOrder,
                scheduledStartTime: scheduledStartTime,
                scheduledEndTime: scheduledEndTime,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({printStationId = false, productsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (productsRefs) db.products],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (printStationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.printStationId,
                                    referencedTable: $$CategoriesTableReferences
                                        ._printStationIdTable(db),
                                    referencedColumn:
                                        $$CategoriesTableReferences
                                            ._printStationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Product
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool printStationId, bool productsRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      required String categoryId,
      required String name,
      Value<String?> nameAr,
      Value<String?> barcode,
      required double priceDineIn,
      Value<double?> priceTakeaway,
      Value<double?> priceDelivery,
      Value<double?> cost,
      Value<double> taxRate,
      Value<String?> image,
      Value<String?> defaultNotes,
      Value<bool> trackStock,
      Value<double> currentStock,
      Value<String> productType,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> categoryId,
      Value<String> name,
      Value<String?> nameAr,
      Value<String?> barcode,
      Value<double> priceDineIn,
      Value<double?> priceTakeaway,
      Value<double?> priceDelivery,
      Value<double?> cost,
      Value<double> taxRate,
      Value<String?> image,
      Value<String?> defaultNotes,
      Value<bool> trackStock,
      Value<double> currentStock,
      Value<String> productType,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.products.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProductModifiersTable, List<ProductModifier>>
  _productModifiersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productModifiers,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.productModifiers.productId,
    ),
  );

  $$ProductModifiersTableProcessedTableManager get productModifiersRefs {
    final manager = $$ProductModifiersTableTableManager(
      $_db,
      $_db.productModifiers,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productModifiersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
  _recipeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeItems,
    aliasName: $_aliasNameGenerator(db.products.id, db.recipeItems.productId),
  );

  $$RecipeItemsTableProcessedTableManager get recipeItemsRefs {
    final manager = $$RecipeItemsTableTableManager(
      $_db,
      $_db.recipeItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: $_aliasNameGenerator(db.products.id, db.orderItems.productId),
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceDineIn => $composableBuilder(
    column: $table.priceDineIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceTakeaway => $composableBuilder(
    column: $table.priceTakeaway,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceDelivery => $composableBuilder(
    column: $table.priceDelivery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultNotes => $composableBuilder(
    column: $table.defaultNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productType => $composableBuilder(
    column: $table.productType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productModifiersRefs(
    Expression<bool> Function($$ProductModifiersTableFilterComposer f) f,
  ) {
    final $$ProductModifiersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productModifiers,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductModifiersTableFilterComposer(
            $db: $db,
            $table: $db.productModifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeItemsRefs(
    Expression<bool> Function($$RecipeItemsTableFilterComposer f) f,
  ) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableFilterComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceDineIn => $composableBuilder(
    column: $table.priceDineIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceTakeaway => $composableBuilder(
    column: $table.priceTakeaway,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceDelivery => $composableBuilder(
    column: $table.priceDelivery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultNotes => $composableBuilder(
    column: $table.defaultNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productType => $composableBuilder(
    column: $table.productType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get priceDineIn => $composableBuilder(
    column: $table.priceDineIn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get priceTakeaway => $composableBuilder(
    column: $table.priceTakeaway,
    builder: (column) => column,
  );

  GeneratedColumn<double> get priceDelivery => $composableBuilder(
    column: $table.priceDelivery,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get defaultNotes => $composableBuilder(
    column: $table.defaultNotes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productType => $composableBuilder(
    column: $table.productType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productModifiersRefs<T extends Object>(
    Expression<T> Function($$ProductModifiersTableAnnotationComposer a) f,
  ) {
    final $$ProductModifiersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productModifiers,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductModifiersTableAnnotationComposer(
            $db: $db,
            $table: $db.productModifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recipeItemsRefs<T extends Object>(
    Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f,
  ) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool categoryId,
            bool productModifiersRefs,
            bool recipeItemsRefs,
            bool orderItemsRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> priceDineIn = const Value.absent(),
                Value<double?> priceTakeaway = const Value.absent(),
                Value<double?> priceDelivery = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> defaultNotes = const Value.absent(),
                Value<bool> trackStock = const Value.absent(),
                Value<double> currentStock = const Value.absent(),
                Value<String> productType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                categoryId: categoryId,
                name: name,
                nameAr: nameAr,
                barcode: barcode,
                priceDineIn: priceDineIn,
                priceTakeaway: priceTakeaway,
                priceDelivery: priceDelivery,
                cost: cost,
                taxRate: taxRate,
                image: image,
                defaultNotes: defaultNotes,
                trackStock: trackStock,
                currentStock: currentStock,
                productType: productType,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String categoryId,
                required String name,
                Value<String?> nameAr = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                required double priceDineIn,
                Value<double?> priceTakeaway = const Value.absent(),
                Value<double?> priceDelivery = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> defaultNotes = const Value.absent(),
                Value<bool> trackStock = const Value.absent(),
                Value<double> currentStock = const Value.absent(),
                Value<String> productType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                categoryId: categoryId,
                name: name,
                nameAr: nameAr,
                barcode: barcode,
                priceDineIn: priceDineIn,
                priceTakeaway: priceTakeaway,
                priceDelivery: priceDelivery,
                cost: cost,
                taxRate: taxRate,
                image: image,
                defaultNotes: defaultNotes,
                trackStock: trackStock,
                currentStock: currentStock,
                productType: productType,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                productModifiersRefs = false,
                recipeItemsRefs = false,
                orderItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productModifiersRefs) db.productModifiers,
                    if (recipeItemsRefs) db.recipeItems,
                    if (orderItemsRefs) db.orderItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ProductsTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productModifiersRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          ProductModifier
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._productModifiersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).productModifiersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          RecipeItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._recipeItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          OrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool categoryId,
        bool productModifiersRefs,
        bool recipeItemsRefs,
        bool orderItemsRefs,
      })
    >;
typedef $$ModifierGroupsTableCreateCompanionBuilder =
    ModifierGroupsCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> nameAr,
      required bool isMultipleChoice,
      required bool isRequired,
      Value<int> rowid,
    });
typedef $$ModifierGroupsTableUpdateCompanionBuilder =
    ModifierGroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> nameAr,
      Value<bool> isMultipleChoice,
      Value<bool> isRequired,
      Value<int> rowid,
    });

final class $$ModifierGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $ModifierGroupsTable, ModifierGroup> {
  $$ModifierGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ModifierOptionsTable, List<ModifierOption>>
  _modifierOptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.modifierOptions,
    aliasName: $_aliasNameGenerator(
      db.modifierGroups.id,
      db.modifierOptions.modifierGroupId,
    ),
  );

  $$ModifierOptionsTableProcessedTableManager get modifierOptionsRefs {
    final manager =
        $$ModifierOptionsTableTableManager($_db, $_db.modifierOptions).filter(
          (f) => f.modifierGroupId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _modifierOptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductModifiersTable, List<ProductModifier>>
  _productModifiersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productModifiers,
    aliasName: $_aliasNameGenerator(
      db.modifierGroups.id,
      db.productModifiers.modifierGroupId,
    ),
  );

  $$ProductModifiersTableProcessedTableManager get productModifiersRefs {
    final manager =
        $$ProductModifiersTableTableManager($_db, $_db.productModifiers).filter(
          (f) => f.modifierGroupId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _productModifiersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModifierGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $ModifierGroupsTable> {
  $$ModifierGroupsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMultipleChoice => $composableBuilder(
    column: $table.isMultipleChoice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> modifierOptionsRefs(
    Expression<bool> Function($$ModifierOptionsTableFilterComposer f) f,
  ) {
    final $$ModifierOptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modifierOptions,
      getReferencedColumn: (t) => t.modifierGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierOptionsTableFilterComposer(
            $db: $db,
            $table: $db.modifierOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productModifiersRefs(
    Expression<bool> Function($$ProductModifiersTableFilterComposer f) f,
  ) {
    final $$ProductModifiersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productModifiers,
      getReferencedColumn: (t) => t.modifierGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductModifiersTableFilterComposer(
            $db: $db,
            $table: $db.productModifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModifierGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ModifierGroupsTable> {
  $$ModifierGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMultipleChoice => $composableBuilder(
    column: $table.isMultipleChoice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModifierGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModifierGroupsTable> {
  $$ModifierGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<bool> get isMultipleChoice => $composableBuilder(
    column: $table.isMultipleChoice,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  Expression<T> modifierOptionsRefs<T extends Object>(
    Expression<T> Function($$ModifierOptionsTableAnnotationComposer a) f,
  ) {
    final $$ModifierOptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modifierOptions,
      getReferencedColumn: (t) => t.modifierGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierOptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.modifierOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productModifiersRefs<T extends Object>(
    Expression<T> Function($$ProductModifiersTableAnnotationComposer a) f,
  ) {
    final $$ProductModifiersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productModifiers,
      getReferencedColumn: (t) => t.modifierGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductModifiersTableAnnotationComposer(
            $db: $db,
            $table: $db.productModifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModifierGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModifierGroupsTable,
          ModifierGroup,
          $$ModifierGroupsTableFilterComposer,
          $$ModifierGroupsTableOrderingComposer,
          $$ModifierGroupsTableAnnotationComposer,
          $$ModifierGroupsTableCreateCompanionBuilder,
          $$ModifierGroupsTableUpdateCompanionBuilder,
          (ModifierGroup, $$ModifierGroupsTableReferences),
          ModifierGroup,
          PrefetchHooks Function({
            bool modifierOptionsRefs,
            bool productModifiersRefs,
          })
        > {
  $$ModifierGroupsTableTableManager(
    _$AppDatabase db,
    $ModifierGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModifierGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModifierGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModifierGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<bool> isMultipleChoice = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModifierGroupsCompanion(
                id: id,
                name: name,
                nameAr: nameAr,
                isMultipleChoice: isMultipleChoice,
                isRequired: isRequired,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> nameAr = const Value.absent(),
                required bool isMultipleChoice,
                required bool isRequired,
                Value<int> rowid = const Value.absent(),
              }) => ModifierGroupsCompanion.insert(
                id: id,
                name: name,
                nameAr: nameAr,
                isMultipleChoice: isMultipleChoice,
                isRequired: isRequired,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ModifierGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({modifierOptionsRefs = false, productModifiersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (modifierOptionsRefs) db.modifierOptions,
                    if (productModifiersRefs) db.productModifiers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (modifierOptionsRefs)
                        await $_getPrefetchedData<
                          ModifierGroup,
                          $ModifierGroupsTable,
                          ModifierOption
                        >(
                          currentTable: table,
                          referencedTable: $$ModifierGroupsTableReferences
                              ._modifierOptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModifierGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).modifierOptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modifierGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productModifiersRefs)
                        await $_getPrefetchedData<
                          ModifierGroup,
                          $ModifierGroupsTable,
                          ProductModifier
                        >(
                          currentTable: table,
                          referencedTable: $$ModifierGroupsTableReferences
                              ._productModifiersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModifierGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).productModifiersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modifierGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ModifierGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModifierGroupsTable,
      ModifierGroup,
      $$ModifierGroupsTableFilterComposer,
      $$ModifierGroupsTableOrderingComposer,
      $$ModifierGroupsTableAnnotationComposer,
      $$ModifierGroupsTableCreateCompanionBuilder,
      $$ModifierGroupsTableUpdateCompanionBuilder,
      (ModifierGroup, $$ModifierGroupsTableReferences),
      ModifierGroup,
      PrefetchHooks Function({
        bool modifierOptionsRefs,
        bool productModifiersRefs,
      })
    >;
typedef $$ModifierOptionsTableCreateCompanionBuilder =
    ModifierOptionsCompanion Function({
      Value<String> id,
      required String modifierGroupId,
      required String name,
      Value<String?> nameAr,
      Value<double> priceExtra,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$ModifierOptionsTableUpdateCompanionBuilder =
    ModifierOptionsCompanion Function({
      Value<String> id,
      Value<String> modifierGroupId,
      Value<String> name,
      Value<String?> nameAr,
      Value<double> priceExtra,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$ModifierOptionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ModifierOptionsTable, ModifierOption> {
  $$ModifierOptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ModifierGroupsTable _modifierGroupIdTable(_$AppDatabase db) =>
      db.modifierGroups.createAlias(
        $_aliasNameGenerator(
          db.modifierOptions.modifierGroupId,
          db.modifierGroups.id,
        ),
      );

  $$ModifierGroupsTableProcessedTableManager get modifierGroupId {
    final $_column = $_itemColumn<String>('modifier_group_id')!;

    final manager = $$ModifierGroupsTableTableManager(
      $_db,
      $_db.modifierGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modifierGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemModifiersTable, List<OrderItemModifier>>
  _orderItemModifiersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderItemModifiers,
        aliasName: $_aliasNameGenerator(
          db.modifierOptions.id,
          db.orderItemModifiers.modifierOptionId,
        ),
      );

  $$OrderItemModifiersTableProcessedTableManager get orderItemModifiersRefs {
    final manager =
        $$OrderItemModifiersTableTableManager(
          $_db,
          $_db.orderItemModifiers,
        ).filter(
          (f) => f.modifierOptionId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _orderItemModifiersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModifierOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $ModifierOptionsTable> {
  $$ModifierOptionsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceExtra => $composableBuilder(
    column: $table.priceExtra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$ModifierGroupsTableFilterComposer get modifierGroupId {
    final $$ModifierGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierGroupId,
      referencedTable: $db.modifierGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierGroupsTableFilterComposer(
            $db: $db,
            $table: $db.modifierGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemModifiersRefs(
    Expression<bool> Function($$OrderItemModifiersTableFilterComposer f) f,
  ) {
    final $$OrderItemModifiersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemModifiers,
      getReferencedColumn: (t) => t.modifierOptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemModifiersTableFilterComposer(
            $db: $db,
            $table: $db.orderItemModifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModifierOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ModifierOptionsTable> {
  $$ModifierOptionsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceExtra => $composableBuilder(
    column: $table.priceExtra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModifierGroupsTableOrderingComposer get modifierGroupId {
    final $$ModifierGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierGroupId,
      referencedTable: $db.modifierGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.modifierGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModifierOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModifierOptionsTable> {
  $$ModifierOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<double> get priceExtra => $composableBuilder(
    column: $table.priceExtra,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$ModifierGroupsTableAnnotationComposer get modifierGroupId {
    final $$ModifierGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierGroupId,
      referencedTable: $db.modifierGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.modifierGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemModifiersRefs<T extends Object>(
    Expression<T> Function($$OrderItemModifiersTableAnnotationComposer a) f,
  ) {
    final $$OrderItemModifiersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderItemModifiers,
          getReferencedColumn: (t) => t.modifierOptionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderItemModifiersTableAnnotationComposer(
                $db: $db,
                $table: $db.orderItemModifiers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ModifierOptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModifierOptionsTable,
          ModifierOption,
          $$ModifierOptionsTableFilterComposer,
          $$ModifierOptionsTableOrderingComposer,
          $$ModifierOptionsTableAnnotationComposer,
          $$ModifierOptionsTableCreateCompanionBuilder,
          $$ModifierOptionsTableUpdateCompanionBuilder,
          (ModifierOption, $$ModifierOptionsTableReferences),
          ModifierOption,
          PrefetchHooks Function({
            bool modifierGroupId,
            bool orderItemModifiersRefs,
          })
        > {
  $$ModifierOptionsTableTableManager(
    _$AppDatabase db,
    $ModifierOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModifierOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModifierOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModifierOptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> modifierGroupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<double> priceExtra = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModifierOptionsCompanion(
                id: id,
                modifierGroupId: modifierGroupId,
                name: name,
                nameAr: nameAr,
                priceExtra: priceExtra,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String modifierGroupId,
                required String name,
                Value<String?> nameAr = const Value.absent(),
                Value<double> priceExtra = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModifierOptionsCompanion.insert(
                id: id,
                modifierGroupId: modifierGroupId,
                name: name,
                nameAr: nameAr,
                priceExtra: priceExtra,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ModifierOptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({modifierGroupId = false, orderItemModifiersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemModifiersRefs) db.orderItemModifiers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (modifierGroupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modifierGroupId,
                                    referencedTable:
                                        $$ModifierOptionsTableReferences
                                            ._modifierGroupIdTable(db),
                                    referencedColumn:
                                        $$ModifierOptionsTableReferences
                                            ._modifierGroupIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemModifiersRefs)
                        await $_getPrefetchedData<
                          ModifierOption,
                          $ModifierOptionsTable,
                          OrderItemModifier
                        >(
                          currentTable: table,
                          referencedTable: $$ModifierOptionsTableReferences
                              ._orderItemModifiersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModifierOptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemModifiersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modifierOptionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ModifierOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModifierOptionsTable,
      ModifierOption,
      $$ModifierOptionsTableFilterComposer,
      $$ModifierOptionsTableOrderingComposer,
      $$ModifierOptionsTableAnnotationComposer,
      $$ModifierOptionsTableCreateCompanionBuilder,
      $$ModifierOptionsTableUpdateCompanionBuilder,
      (ModifierOption, $$ModifierOptionsTableReferences),
      ModifierOption,
      PrefetchHooks Function({
        bool modifierGroupId,
        bool orderItemModifiersRefs,
      })
    >;
typedef $$ProductModifiersTableCreateCompanionBuilder =
    ProductModifiersCompanion Function({
      required String productId,
      required String modifierGroupId,
      Value<int> rowid,
    });
typedef $$ProductModifiersTableUpdateCompanionBuilder =
    ProductModifiersCompanion Function({
      Value<String> productId,
      Value<String> modifierGroupId,
      Value<int> rowid,
    });

final class $$ProductModifiersTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductModifiersTable, ProductModifier> {
  $$ProductModifiersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.productModifiers.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModifierGroupsTable _modifierGroupIdTable(_$AppDatabase db) =>
      db.modifierGroups.createAlias(
        $_aliasNameGenerator(
          db.productModifiers.modifierGroupId,
          db.modifierGroups.id,
        ),
      );

  $$ModifierGroupsTableProcessedTableManager get modifierGroupId {
    final $_column = $_itemColumn<String>('modifier_group_id')!;

    final manager = $$ModifierGroupsTableTableManager(
      $_db,
      $_db.modifierGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modifierGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductModifiersTableFilterComposer
    extends Composer<_$AppDatabase, $ProductModifiersTable> {
  $$ProductModifiersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifierGroupsTableFilterComposer get modifierGroupId {
    final $$ModifierGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierGroupId,
      referencedTable: $db.modifierGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierGroupsTableFilterComposer(
            $db: $db,
            $table: $db.modifierGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductModifiersTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductModifiersTable> {
  $$ProductModifiersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifierGroupsTableOrderingComposer get modifierGroupId {
    final $$ModifierGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierGroupId,
      referencedTable: $db.modifierGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.modifierGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductModifiersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductModifiersTable> {
  $$ProductModifiersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifierGroupsTableAnnotationComposer get modifierGroupId {
    final $$ModifierGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierGroupId,
      referencedTable: $db.modifierGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.modifierGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductModifiersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductModifiersTable,
          ProductModifier,
          $$ProductModifiersTableFilterComposer,
          $$ProductModifiersTableOrderingComposer,
          $$ProductModifiersTableAnnotationComposer,
          $$ProductModifiersTableCreateCompanionBuilder,
          $$ProductModifiersTableUpdateCompanionBuilder,
          (ProductModifier, $$ProductModifiersTableReferences),
          ProductModifier,
          PrefetchHooks Function({bool productId, bool modifierGroupId})
        > {
  $$ProductModifiersTableTableManager(
    _$AppDatabase db,
    $ProductModifiersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductModifiersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductModifiersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductModifiersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<String> modifierGroupId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductModifiersCompanion(
                productId: productId,
                modifierGroupId: modifierGroupId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                required String modifierGroupId,
                Value<int> rowid = const Value.absent(),
              }) => ProductModifiersCompanion.insert(
                productId: productId,
                modifierGroupId: modifierGroupId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductModifiersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productId = false, modifierGroupId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$ProductModifiersTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$ProductModifiersTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (modifierGroupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modifierGroupId,
                                    referencedTable:
                                        $$ProductModifiersTableReferences
                                            ._modifierGroupIdTable(db),
                                    referencedColumn:
                                        $$ProductModifiersTableReferences
                                            ._modifierGroupIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ProductModifiersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductModifiersTable,
      ProductModifier,
      $$ProductModifiersTableFilterComposer,
      $$ProductModifiersTableOrderingComposer,
      $$ProductModifiersTableAnnotationComposer,
      $$ProductModifiersTableCreateCompanionBuilder,
      $$ProductModifiersTableUpdateCompanionBuilder,
      (ProductModifier, $$ProductModifiersTableReferences),
      ProductModifier,
      PrefetchHooks Function({bool productId, bool modifierGroupId})
    >;
typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      Value<String> id,
      required String name,
      required String unit,
      required double costPerUnit,
      Value<double> currentStock,
      Value<double> minimumStock,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> unit,
      Value<double> costPerUnit,
      Value<double> currentStock,
      Value<double> minimumStock,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
  _recipeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeItems,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.recipeItems.ingredientId,
    ),
  );

  $$RecipeItemsTableProcessedTableManager get recipeItemsRefs {
    final manager = $$RecipeItemsTableTableManager(
      $_db,
      $_db.recipeItems,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPerUnit => $composableBuilder(
    column: $table.costPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minimumStock => $composableBuilder(
    column: $table.minimumStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipeItemsRefs(
    Expression<bool> Function($$RecipeItemsTableFilterComposer f) f,
  ) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableFilterComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPerUnit => $composableBuilder(
    column: $table.costPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minimumStock => $composableBuilder(
    column: $table.minimumStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get costPerUnit => $composableBuilder(
    column: $table.costPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minimumStock => $composableBuilder(
    column: $table.minimumStock,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recipeItemsRefs<T extends Object>(
    Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f,
  ) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({bool recipeItemsRefs})
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> costPerUnit = const Value.absent(),
                Value<double> currentStock = const Value.absent(),
                Value<double> minimumStock = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                name: name,
                unit: unit,
                costPerUnit: costPerUnit,
                currentStock: currentStock,
                minimumStock: minimumStock,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                required String unit,
                required double costPerUnit,
                Value<double> currentStock = const Value.absent(),
                Value<double> minimumStock = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                name: name,
                unit: unit,
                costPerUnit: costPerUnit,
                currentStock: currentStock,
                minimumStock: minimumStock,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recipeItemsRefs) db.recipeItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeItemsRefs)
                    await $_getPrefetchedData<
                      Ingredient,
                      $IngredientsTable,
                      RecipeItem
                    >(
                      currentTable: table,
                      referencedTable: $$IngredientsTableReferences
                          ._recipeItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$IngredientsTableReferences(
                            db,
                            table,
                            p0,
                          ).recipeItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.ingredientId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({bool recipeItemsRefs})
    >;
typedef $$RecipeItemsTableCreateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<String> id,
      required String productId,
      required String ingredientId,
      required double quantityUsed,
      Value<int> rowid,
    });
typedef $$RecipeItemsTableUpdateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> ingredientId,
      Value<double> quantityUsed,
      Value<int> rowid,
    });

final class $$RecipeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeItemsTable, RecipeItem> {
  $$RecipeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.recipeItems.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(db.recipeItems.ingredientId, db.ingredients.id),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableFilterComposer({
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

  ColumnFilters<double> get quantityUsed => $composableBuilder(
    column: $table.quantityUsed,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableOrderingComposer({
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

  ColumnOrderings<double> get quantityUsed => $composableBuilder(
    column: $table.quantityUsed,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityUsed => $composableBuilder(
    column: $table.quantityUsed,
    builder: (column) => column,
  );

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeItemsTable,
          RecipeItem,
          $$RecipeItemsTableFilterComposer,
          $$RecipeItemsTableOrderingComposer,
          $$RecipeItemsTableAnnotationComposer,
          $$RecipeItemsTableCreateCompanionBuilder,
          $$RecipeItemsTableUpdateCompanionBuilder,
          (RecipeItem, $$RecipeItemsTableReferences),
          RecipeItem,
          PrefetchHooks Function({bool productId, bool ingredientId})
        > {
  $$RecipeItemsTableTableManager(_$AppDatabase db, $RecipeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<double> quantityUsed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeItemsCompanion(
                id: id,
                productId: productId,
                ingredientId: ingredientId,
                quantityUsed: quantityUsed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String productId,
                required String ingredientId,
                required double quantityUsed,
                Value<int> rowid = const Value.absent(),
              }) => RecipeItemsCompanion.insert(
                id: id,
                productId: productId,
                ingredientId: ingredientId,
                quantityUsed: quantityUsed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$RecipeItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$RecipeItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable: $$RecipeItemsTableReferences
                                    ._ingredientIdTable(db),
                                referencedColumn: $$RecipeItemsTableReferences
                                    ._ingredientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeItemsTable,
      RecipeItem,
      $$RecipeItemsTableFilterComposer,
      $$RecipeItemsTableOrderingComposer,
      $$RecipeItemsTableAnnotationComposer,
      $$RecipeItemsTableCreateCompanionBuilder,
      $$RecipeItemsTableUpdateCompanionBuilder,
      (RecipeItem, $$RecipeItemsTableReferences),
      RecipeItem,
      PrefetchHooks Function({bool productId, bool ingredientId})
    >;
typedef $$CashSessionsTableCreateCompanionBuilder =
    CashSessionsCompanion Function({
      Value<String> id,
      required String cashierId,
      required DateTime openedAt,
      Value<DateTime?> closedAt,
      required double openingBalance,
      Value<double?> closingBalance,
      Value<double?> expectedBalance,
      Value<String?> closingNote,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$CashSessionsTableUpdateCompanionBuilder =
    CashSessionsCompanion Function({
      Value<String> id,
      Value<String> cashierId,
      Value<DateTime> openedAt,
      Value<DateTime?> closedAt,
      Value<double> openingBalance,
      Value<double?> closingBalance,
      Value<double?> expectedBalance,
      Value<String?> closingNote,
      Value<String> status,
      Value<int> rowid,
    });

final class $$CashSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $CashSessionsTable, CashSession> {
  $$CashSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _cashierIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.cashSessions.cashierId, db.users.id),
  );

  $$UsersTableProcessedTableManager get cashierId {
    final $_column = $_itemColumn<String>('cashier_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cashierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CashMovementsTable, List<CashMovement>>
  _cashMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cashMovements,
    aliasName: $_aliasNameGenerator(
      db.cashSessions.id,
      db.cashMovements.sessionId,
    ),
  );

  $$CashMovementsTableProcessedTableManager get cashMovementsRefs {
    final manager = $$CashMovementsTableTableManager(
      $_db,
      $_db.cashMovements,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cashMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: $_aliasNameGenerator(db.cashSessions.id, db.orders.sessionId),
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CashSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get closingBalance => $composableBuilder(
    column: $table.closingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expectedBalance => $composableBuilder(
    column: $table.expectedBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get cashierId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cashierId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cashMovementsRefs(
    Expression<bool> Function($$CashMovementsTableFilterComposer f) f,
  ) {
    final $$CashMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashMovements,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashMovementsTableFilterComposer(
            $db: $db,
            $table: $db.cashMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CashSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get closingBalance => $composableBuilder(
    column: $table.closingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expectedBalance => $composableBuilder(
    column: $table.expectedBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get cashierId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cashierId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get closingBalance => $composableBuilder(
    column: $table.closingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expectedBalance => $composableBuilder(
    column: $table.expectedBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$UsersTableAnnotationComposer get cashierId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cashierId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cashMovementsRefs<T extends Object>(
    Expression<T> Function($$CashMovementsTableAnnotationComposer a) f,
  ) {
    final $$CashMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashMovements,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.cashMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CashSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashSessionsTable,
          CashSession,
          $$CashSessionsTableFilterComposer,
          $$CashSessionsTableOrderingComposer,
          $$CashSessionsTableAnnotationComposer,
          $$CashSessionsTableCreateCompanionBuilder,
          $$CashSessionsTableUpdateCompanionBuilder,
          (CashSession, $$CashSessionsTableReferences),
          CashSession,
          PrefetchHooks Function({
            bool cashierId,
            bool cashMovementsRefs,
            bool ordersRefs,
          })
        > {
  $$CashSessionsTableTableManager(_$AppDatabase db, $CashSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cashierId = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<double> openingBalance = const Value.absent(),
                Value<double?> closingBalance = const Value.absent(),
                Value<double?> expectedBalance = const Value.absent(),
                Value<String?> closingNote = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashSessionsCompanion(
                id: id,
                cashierId: cashierId,
                openedAt: openedAt,
                closedAt: closedAt,
                openingBalance: openingBalance,
                closingBalance: closingBalance,
                expectedBalance: expectedBalance,
                closingNote: closingNote,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String cashierId,
                required DateTime openedAt,
                Value<DateTime?> closedAt = const Value.absent(),
                required double openingBalance,
                Value<double?> closingBalance = const Value.absent(),
                Value<double?> expectedBalance = const Value.absent(),
                Value<String?> closingNote = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashSessionsCompanion.insert(
                id: id,
                cashierId: cashierId,
                openedAt: openedAt,
                closedAt: closedAt,
                openingBalance: openingBalance,
                closingBalance: closingBalance,
                expectedBalance: expectedBalance,
                closingNote: closingNote,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CashSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cashierId = false,
                cashMovementsRefs = false,
                ordersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cashMovementsRefs) db.cashMovements,
                    if (ordersRefs) db.orders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cashierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cashierId,
                                    referencedTable:
                                        $$CashSessionsTableReferences
                                            ._cashierIdTable(db),
                                    referencedColumn:
                                        $$CashSessionsTableReferences
                                            ._cashierIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cashMovementsRefs)
                        await $_getPrefetchedData<
                          CashSession,
                          $CashSessionsTable,
                          CashMovement
                        >(
                          currentTable: table,
                          referencedTable: $$CashSessionsTableReferences
                              ._cashMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CashSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).cashMovementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          CashSession,
                          $CashSessionsTable,
                          Order
                        >(
                          currentTable: table,
                          referencedTable: $$CashSessionsTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CashSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CashSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashSessionsTable,
      CashSession,
      $$CashSessionsTableFilterComposer,
      $$CashSessionsTableOrderingComposer,
      $$CashSessionsTableAnnotationComposer,
      $$CashSessionsTableCreateCompanionBuilder,
      $$CashSessionsTableUpdateCompanionBuilder,
      (CashSession, $$CashSessionsTableReferences),
      CashSession,
      PrefetchHooks Function({
        bool cashierId,
        bool cashMovementsRefs,
        bool ordersRefs,
      })
    >;
typedef $$CashMovementsTableCreateCompanionBuilder =
    CashMovementsCompanion Function({
      Value<String> id,
      required String sessionId,
      required String userId,
      required String type,
      required double amount,
      required String reason,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CashMovementsTableUpdateCompanionBuilder =
    CashMovementsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> userId,
      Value<String> type,
      Value<double> amount,
      Value<String> reason,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CashMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $CashMovementsTable, CashMovement> {
  $$CashMovementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CashSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.cashSessions.createAlias(
        $_aliasNameGenerator(db.cashMovements.sessionId, db.cashSessions.id),
      );

  $$CashSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$CashSessionsTableTableManager(
      $_db,
      $_db.cashSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.cashMovements.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CashMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CashSessionsTableFilterComposer get sessionId {
    final $$CashSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableFilterComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CashSessionsTableOrderingComposer get sessionId {
    final $$CashSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CashSessionsTableAnnotationComposer get sessionId {
    final $$CashSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashMovementsTable,
          CashMovement,
          $$CashMovementsTableFilterComposer,
          $$CashMovementsTableOrderingComposer,
          $$CashMovementsTableAnnotationComposer,
          $$CashMovementsTableCreateCompanionBuilder,
          $$CashMovementsTableUpdateCompanionBuilder,
          (CashMovement, $$CashMovementsTableReferences),
          CashMovement,
          PrefetchHooks Function({bool sessionId, bool userId})
        > {
  $$CashMovementsTableTableManager(_$AppDatabase db, $CashMovementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashMovementsCompanion(
                id: id,
                sessionId: sessionId,
                userId: userId,
                type: type,
                amount: amount,
                reason: reason,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sessionId,
                required String userId,
                required String type,
                required double amount,
                required String reason,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CashMovementsCompanion.insert(
                id: id,
                sessionId: sessionId,
                userId: userId,
                type: type,
                amount: amount,
                reason: reason,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CashMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$CashMovementsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$CashMovementsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$CashMovementsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$CashMovementsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CashMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashMovementsTable,
      CashMovement,
      $$CashMovementsTableFilterComposer,
      $$CashMovementsTableOrderingComposer,
      $$CashMovementsTableAnnotationComposer,
      $$CashMovementsTableCreateCompanionBuilder,
      $$CashMovementsTableUpdateCompanionBuilder,
      (CashMovement, $$CashMovementsTableReferences),
      CashMovement,
      PrefetchHooks Function({bool sessionId, bool userId})
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      Value<String> id,
      required String sessionId,
      required String waiterId,
      Value<String?> tableId,
      Value<String?> customerId,
      required String orderType,
      Value<String> source,
      Value<String?> externalRef,
      Value<String> status,
      Value<String?> discountType,
      Value<double?> discountValue,
      Value<String?> discountReason,
      Value<String?> discountAuthorizedBy,
      Value<int> guestCount,
      Value<String?> notes,
      Value<String?> companyName,
      Value<String?> companyIce,
      Value<int?> invoiceNumber,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> waiterId,
      Value<String?> tableId,
      Value<String?> customerId,
      Value<String> orderType,
      Value<String> source,
      Value<String?> externalRef,
      Value<String> status,
      Value<String?> discountType,
      Value<double?> discountValue,
      Value<String?> discountReason,
      Value<String?> discountAuthorizedBy,
      Value<int> guestCount,
      Value<String?> notes,
      Value<String?> companyName,
      Value<String?> companyIce,
      Value<int?> invoiceNumber,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CashSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.cashSessions.createAlias(
        $_aliasNameGenerator(db.orders.sessionId, db.cashSessions.id),
      );

  $$CashSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$CashSessionsTableTableManager(
      $_db,
      $_db.cashSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _waiterIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.orders.waiterId, db.users.id),
  );

  $$UsersTableProcessedTableManager get waiterId {
    final $_column = $_itemColumn<String>('waiter_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_waiterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RestaurantTablesTable _tableIdTable(_$AppDatabase db) =>
      db.restaurantTables.createAlias(
        $_aliasNameGenerator(db.orders.tableId, db.restaurantTables.id),
      );

  $$RestaurantTablesTableProcessedTableManager? get tableId {
    final $_column = $_itemColumn<String>('table_id');
    if ($_column == null) return null;
    final manager = $$RestaurantTablesTableTableManager(
      $_db,
      $_db.restaurantTables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _discountAuthorizedByTable(_$AppDatabase db) =>
      db.users.createAlias(
        $_aliasNameGenerator(db.orders.discountAuthorizedBy, db.users.id),
      );

  $$UsersTableProcessedTableManager? get discountAuthorizedBy {
    final $_column = $_itemColumn<String>('discount_authorized_by');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _discountAuthorizedByTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId),
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.orders.id, db.payments.orderId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VouchersTable, List<Voucher>> _vouchersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vouchers,
    aliasName: $_aliasNameGenerator(db.orders.id, db.vouchers.orderId),
  );

  $$VouchersTableProcessedTableManager get vouchersRefs {
    final manager = $$VouchersTableTableManager(
      $_db,
      $_db.vouchers,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vouchersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
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

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalRef => $composableBuilder(
    column: $table.externalRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyIce => $composableBuilder(
    column: $table.companyIce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CashSessionsTableFilterComposer get sessionId {
    final $$CashSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableFilterComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get waiterId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.waiterId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RestaurantTablesTableFilterComposer get tableId {
    final $$RestaurantTablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableFilterComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get discountAuthorizedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.discountAuthorizedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vouchersRefs(
    Expression<bool> Function($$VouchersTableFilterComposer f) f,
  ) {
    final $$VouchersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vouchers,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VouchersTableFilterComposer(
            $db: $db,
            $table: $db.vouchers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
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

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalRef => $composableBuilder(
    column: $table.externalRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyIce => $composableBuilder(
    column: $table.companyIce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CashSessionsTableOrderingComposer get sessionId {
    final $$CashSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get waiterId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.waiterId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RestaurantTablesTableOrderingComposer get tableId {
    final $$RestaurantTablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableOrderingComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get discountAuthorizedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.discountAuthorizedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalRef => $composableBuilder(
    column: $table.externalRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => column,
  );

  GeneratedColumn<int> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyIce => $composableBuilder(
    column: $table.companyIce,
    builder: (column) => column,
  );

  GeneratedColumn<int> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CashSessionsTableAnnotationComposer get sessionId {
    final $$CashSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.cashSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.cashSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get waiterId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.waiterId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RestaurantTablesTableAnnotationComposer get tableId {
    final $$RestaurantTablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.restaurantTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestaurantTablesTableAnnotationComposer(
            $db: $db,
            $table: $db.restaurantTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get discountAuthorizedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.discountAuthorizedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vouchersRefs<T extends Object>(
    Expression<T> Function($$VouchersTableAnnotationComposer a) f,
  ) {
    final $$VouchersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vouchers,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VouchersTableAnnotationComposer(
            $db: $db,
            $table: $db.vouchers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({
            bool sessionId,
            bool waiterId,
            bool tableId,
            bool discountAuthorizedBy,
            bool orderItemsRefs,
            bool paymentsRefs,
            bool vouchersRefs,
          })
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> waiterId = const Value.absent(),
                Value<String?> tableId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> orderType = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalRef = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<double?> discountValue = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> discountAuthorizedBy = const Value.absent(),
                Value<int> guestCount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> companyIce = const Value.absent(),
                Value<int?> invoiceNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                sessionId: sessionId,
                waiterId: waiterId,
                tableId: tableId,
                customerId: customerId,
                orderType: orderType,
                source: source,
                externalRef: externalRef,
                status: status,
                discountType: discountType,
                discountValue: discountValue,
                discountReason: discountReason,
                discountAuthorizedBy: discountAuthorizedBy,
                guestCount: guestCount,
                notes: notes,
                companyName: companyName,
                companyIce: companyIce,
                invoiceNumber: invoiceNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sessionId,
                required String waiterId,
                Value<String?> tableId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                required String orderType,
                Value<String> source = const Value.absent(),
                Value<String?> externalRef = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<double?> discountValue = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> discountAuthorizedBy = const Value.absent(),
                Value<int> guestCount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> companyIce = const Value.absent(),
                Value<int?> invoiceNumber = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                sessionId: sessionId,
                waiterId: waiterId,
                tableId: tableId,
                customerId: customerId,
                orderType: orderType,
                source: source,
                externalRef: externalRef,
                status: status,
                discountType: discountType,
                discountValue: discountValue,
                discountReason: discountReason,
                discountAuthorizedBy: discountAuthorizedBy,
                guestCount: guestCount,
                notes: notes,
                companyName: companyName,
                companyIce: companyIce,
                invoiceNumber: invoiceNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                waiterId = false,
                tableId = false,
                discountAuthorizedBy = false,
                orderItemsRefs = false,
                paymentsRefs = false,
                vouchersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemsRefs) db.orderItems,
                    if (paymentsRefs) db.payments,
                    if (vouchersRefs) db.vouchers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable: $$OrdersTableReferences
                                        ._sessionIdTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (waiterId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.waiterId,
                                    referencedTable: $$OrdersTableReferences
                                        ._waiterIdTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._waiterIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (tableId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tableId,
                                    referencedTable: $$OrdersTableReferences
                                        ._tableIdTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._tableIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (discountAuthorizedBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.discountAuthorizedBy,
                                    referencedTable: $$OrdersTableReferences
                                        ._discountAuthorizedByTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._discountAuthorizedByTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          OrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<Order, $OrdersTable, Payment>(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vouchersRefs)
                        await $_getPrefetchedData<Order, $OrdersTable, Voucher>(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._vouchersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).vouchersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({
        bool sessionId,
        bool waiterId,
        bool tableId,
        bool discountAuthorizedBy,
        bool orderItemsRefs,
        bool paymentsRefs,
        bool vouchersRefs,
      })
    >;
typedef $$OrderItemsTableCreateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<String> id,
      required String orderId,
      required String productId,
      required double quantity,
      required double unitPrice,
      required double taxRate,
      Value<String?> customNotes,
      Value<int> courseNumber,
      Value<bool> isFired,
      Value<String> status,
      Value<String?> voidReason,
      Value<String?> voidAuthorizedBy,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$OrderItemsTableUpdateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> productId,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<double> taxRate,
      Value<String?> customNotes,
      Value<int> courseNumber,
      Value<bool> isFired,
      Value<String> status,
      Value<String?> voidReason,
      Value<String?> voidAuthorizedBy,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.orderItems.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.orderItems.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _voidAuthorizedByTable(_$AppDatabase db) =>
      db.users.createAlias(
        $_aliasNameGenerator(db.orderItems.voidAuthorizedBy, db.users.id),
      );

  $$UsersTableProcessedTableManager? get voidAuthorizedBy {
    final $_column = $_itemColumn<String>('void_authorized_by');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_voidAuthorizedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemModifiersTable, List<OrderItemModifier>>
  _orderItemModifiersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderItemModifiers,
        aliasName: $_aliasNameGenerator(
          db.orderItems.id,
          db.orderItemModifiers.orderItemId,
        ),
      );

  $$OrderItemModifiersTableProcessedTableManager get orderItemModifiersRefs {
    final manager = $$OrderItemModifiersTableTableManager(
      $_db,
      $_db.orderItemModifiers,
    ).filter((f) => f.orderItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemModifiersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
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

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get courseNumber => $composableBuilder(
    column: $table.courseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFired => $composableBuilder(
    column: $table.isFired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get voidAuthorizedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidAuthorizedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemModifiersRefs(
    Expression<bool> Function($$OrderItemModifiersTableFilterComposer f) f,
  ) {
    final $$OrderItemModifiersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemModifiers,
      getReferencedColumn: (t) => t.orderItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemModifiersTableFilterComposer(
            $db: $db,
            $table: $db.orderItemModifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
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

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get courseNumber => $composableBuilder(
    column: $table.courseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFired => $composableBuilder(
    column: $table.isFired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get voidAuthorizedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidAuthorizedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get courseNumber => $composableBuilder(
    column: $table.courseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFired =>
      $composableBuilder(column: $table.isFired, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get voidAuthorizedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidAuthorizedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemModifiersRefs<T extends Object>(
    Expression<T> Function($$OrderItemModifiersTableAnnotationComposer a) f,
  ) {
    final $$OrderItemModifiersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderItemModifiers,
          getReferencedColumn: (t) => t.orderItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderItemModifiersTableAnnotationComposer(
                $db: $db,
                $table: $db.orderItemModifiers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItem,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (OrderItem, $$OrderItemsTableReferences),
          OrderItem,
          PrefetchHooks Function({
            bool orderId,
            bool productId,
            bool voidAuthorizedBy,
            bool orderItemModifiersRefs,
          })
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String?> customNotes = const Value.absent(),
                Value<int> courseNumber = const Value.absent(),
                Value<bool> isFired = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<String?> voidAuthorizedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                unitPrice: unitPrice,
                taxRate: taxRate,
                customNotes: customNotes,
                courseNumber: courseNumber,
                isFired: isFired,
                status: status,
                voidReason: voidReason,
                voidAuthorizedBy: voidAuthorizedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String orderId,
                required String productId,
                required double quantity,
                required double unitPrice,
                required double taxRate,
                Value<String?> customNotes = const Value.absent(),
                Value<int> courseNumber = const Value.absent(),
                Value<bool> isFired = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<String?> voidAuthorizedBy = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                unitPrice: unitPrice,
                taxRate: taxRate,
                customNotes: customNotes,
                courseNumber: courseNumber,
                isFired: isFired,
                status: status,
                voidReason: voidReason,
                voidAuthorizedBy: voidAuthorizedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                orderId = false,
                productId = false,
                voidAuthorizedBy = false,
                orderItemModifiersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemModifiersRefs) db.orderItemModifiers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (orderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderId,
                                    referencedTable: $$OrderItemsTableReferences
                                        ._orderIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableReferences
                                            ._orderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable: $$OrderItemsTableReferences
                                        ._productIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (voidAuthorizedBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.voidAuthorizedBy,
                                    referencedTable: $$OrderItemsTableReferences
                                        ._voidAuthorizedByTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableReferences
                                            ._voidAuthorizedByTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemModifiersRefs)
                        await $_getPrefetchedData<
                          OrderItem,
                          $OrderItemsTable,
                          OrderItemModifier
                        >(
                          currentTable: table,
                          referencedTable: $$OrderItemsTableReferences
                              ._orderItemModifiersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemModifiersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItem,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItem, $$OrderItemsTableReferences),
      OrderItem,
      PrefetchHooks Function({
        bool orderId,
        bool productId,
        bool voidAuthorizedBy,
        bool orderItemModifiersRefs,
      })
    >;
typedef $$OrderItemModifiersTableCreateCompanionBuilder =
    OrderItemModifiersCompanion Function({
      Value<String> id,
      required String orderItemId,
      required String modifierOptionId,
      required double priceExtra,
      Value<int> rowid,
    });
typedef $$OrderItemModifiersTableUpdateCompanionBuilder =
    OrderItemModifiersCompanion Function({
      Value<String> id,
      Value<String> orderItemId,
      Value<String> modifierOptionId,
      Value<double> priceExtra,
      Value<int> rowid,
    });

final class $$OrderItemModifiersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrderItemModifiersTable,
          OrderItemModifier
        > {
  $$OrderItemModifiersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrderItemsTable _orderItemIdTable(_$AppDatabase db) =>
      db.orderItems.createAlias(
        $_aliasNameGenerator(
          db.orderItemModifiers.orderItemId,
          db.orderItems.id,
        ),
      );

  $$OrderItemsTableProcessedTableManager get orderItemId {
    final $_column = $_itemColumn<String>('order_item_id')!;

    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModifierOptionsTable _modifierOptionIdTable(_$AppDatabase db) =>
      db.modifierOptions.createAlias(
        $_aliasNameGenerator(
          db.orderItemModifiers.modifierOptionId,
          db.modifierOptions.id,
        ),
      );

  $$ModifierOptionsTableProcessedTableManager get modifierOptionId {
    final $_column = $_itemColumn<String>('modifier_option_id')!;

    final manager = $$ModifierOptionsTableTableManager(
      $_db,
      $_db.modifierOptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modifierOptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemModifiersTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemModifiersTable> {
  $$OrderItemModifiersTableFilterComposer({
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

  ColumnFilters<double> get priceExtra => $composableBuilder(
    column: $table.priceExtra,
    builder: (column) => ColumnFilters(column),
  );

  $$OrderItemsTableFilterComposer get orderItemId {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifierOptionsTableFilterComposer get modifierOptionId {
    final $$ModifierOptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierOptionId,
      referencedTable: $db.modifierOptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierOptionsTableFilterComposer(
            $db: $db,
            $table: $db.modifierOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemModifiersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemModifiersTable> {
  $$OrderItemModifiersTableOrderingComposer({
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

  ColumnOrderings<double> get priceExtra => $composableBuilder(
    column: $table.priceExtra,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrderItemsTableOrderingComposer get orderItemId {
    final $$OrderItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableOrderingComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifierOptionsTableOrderingComposer get modifierOptionId {
    final $$ModifierOptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierOptionId,
      referencedTable: $db.modifierOptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierOptionsTableOrderingComposer(
            $db: $db,
            $table: $db.modifierOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemModifiersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemModifiersTable> {
  $$OrderItemModifiersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get priceExtra => $composableBuilder(
    column: $table.priceExtra,
    builder: (column) => column,
  );

  $$OrderItemsTableAnnotationComposer get orderItemId {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifierOptionsTableAnnotationComposer get modifierOptionId {
    final $$ModifierOptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierOptionId,
      referencedTable: $db.modifierOptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierOptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.modifierOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemModifiersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemModifiersTable,
          OrderItemModifier,
          $$OrderItemModifiersTableFilterComposer,
          $$OrderItemModifiersTableOrderingComposer,
          $$OrderItemModifiersTableAnnotationComposer,
          $$OrderItemModifiersTableCreateCompanionBuilder,
          $$OrderItemModifiersTableUpdateCompanionBuilder,
          (OrderItemModifier, $$OrderItemModifiersTableReferences),
          OrderItemModifier,
          PrefetchHooks Function({bool orderItemId, bool modifierOptionId})
        > {
  $$OrderItemModifiersTableTableManager(
    _$AppDatabase db,
    $OrderItemModifiersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemModifiersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemModifiersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemModifiersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderItemId = const Value.absent(),
                Value<String> modifierOptionId = const Value.absent(),
                Value<double> priceExtra = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemModifiersCompanion(
                id: id,
                orderItemId: orderItemId,
                modifierOptionId: modifierOptionId,
                priceExtra: priceExtra,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String orderItemId,
                required String modifierOptionId,
                required double priceExtra,
                Value<int> rowid = const Value.absent(),
              }) => OrderItemModifiersCompanion.insert(
                id: id,
                orderItemId: orderItemId,
                modifierOptionId: modifierOptionId,
                priceExtra: priceExtra,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemModifiersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({orderItemId = false, modifierOptionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (orderItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderItemId,
                                    referencedTable:
                                        $$OrderItemModifiersTableReferences
                                            ._orderItemIdTable(db),
                                    referencedColumn:
                                        $$OrderItemModifiersTableReferences
                                            ._orderItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (modifierOptionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modifierOptionId,
                                    referencedTable:
                                        $$OrderItemModifiersTableReferences
                                            ._modifierOptionIdTable(db),
                                    referencedColumn:
                                        $$OrderItemModifiersTableReferences
                                            ._modifierOptionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$OrderItemModifiersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemModifiersTable,
      OrderItemModifier,
      $$OrderItemModifiersTableFilterComposer,
      $$OrderItemModifiersTableOrderingComposer,
      $$OrderItemModifiersTableAnnotationComposer,
      $$OrderItemModifiersTableCreateCompanionBuilder,
      $$OrderItemModifiersTableUpdateCompanionBuilder,
      (OrderItemModifier, $$OrderItemModifiersTableReferences),
      OrderItemModifier,
      PrefetchHooks Function({bool orderItemId, bool modifierOptionId})
    >;
typedef $$DiscountsTableCreateCompanionBuilder =
    DiscountsCompanion Function({
      Value<String> id,
      required String name,
      required String type,
      required double value,
      Value<String?> code,
      Value<int?> maxUses,
      Value<int> currentUses,
      Value<DateTime?> validFrom,
      Value<DateTime?> validUntil,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$DiscountsTableUpdateCompanionBuilder =
    DiscountsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<double> value,
      Value<String?> code,
      Value<int?> maxUses,
      Value<int> currentUses,
      Value<DateTime?> validFrom,
      Value<DateTime?> validUntil,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$DiscountsTableFilterComposer
    extends Composer<_$AppDatabase, $DiscountsTable> {
  $$DiscountsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxUses => $composableBuilder(
    column: $table.maxUses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentUses => $composableBuilder(
    column: $table.currentUses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiscountsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscountsTable> {
  $$DiscountsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxUses => $composableBuilder(
    column: $table.maxUses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentUses => $composableBuilder(
    column: $table.currentUses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiscountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscountsTable> {
  $$DiscountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get maxUses =>
      $composableBuilder(column: $table.maxUses, builder: (column) => column);

  GeneratedColumn<int> get currentUses => $composableBuilder(
    column: $table.currentUses,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$DiscountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiscountsTable,
          Discount,
          $$DiscountsTableFilterComposer,
          $$DiscountsTableOrderingComposer,
          $$DiscountsTableAnnotationComposer,
          $$DiscountsTableCreateCompanionBuilder,
          $$DiscountsTableUpdateCompanionBuilder,
          (Discount, BaseReferences<_$AppDatabase, $DiscountsTable, Discount>),
          Discount,
          PrefetchHooks Function()
        > {
  $$DiscountsTableTableManager(_$AppDatabase db, $DiscountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<int?> maxUses = const Value.absent(),
                Value<int> currentUses = const Value.absent(),
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiscountsCompanion(
                id: id,
                name: name,
                type: type,
                value: value,
                code: code,
                maxUses: maxUses,
                currentUses: currentUses,
                validFrom: validFrom,
                validUntil: validUntil,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                required String type,
                required double value,
                Value<String?> code = const Value.absent(),
                Value<int?> maxUses = const Value.absent(),
                Value<int> currentUses = const Value.absent(),
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiscountsCompanion.insert(
                id: id,
                name: name,
                type: type,
                value: value,
                code: code,
                maxUses: maxUses,
                currentUses: currentUses,
                validFrom: validFrom,
                validUntil: validUntil,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiscountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiscountsTable,
      Discount,
      $$DiscountsTableFilterComposer,
      $$DiscountsTableOrderingComposer,
      $$DiscountsTableAnnotationComposer,
      $$DiscountsTableCreateCompanionBuilder,
      $$DiscountsTableUpdateCompanionBuilder,
      (Discount, BaseReferences<_$AppDatabase, $DiscountsTable, Discount>),
      Discount,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      required String orderId,
      required String paymentMethod,
      required double amount,
      Value<String?> reference,
      required DateTime paidAt,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> paymentMethod,
      Value<double> amount,
      Value<String?> reference,
      Value<DateTime> paidAt,
      Value<int> rowid,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.payments.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
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

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
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

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool orderId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                orderId: orderId,
                paymentMethod: paymentMethod,
                amount: amount,
                reference: reference,
                paidAt: paidAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String orderId,
                required String paymentMethod,
                required double amount,
                Value<String?> reference = const Value.absent(),
                required DateTime paidAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                orderId: orderId,
                paymentMethod: paymentMethod,
                amount: amount,
                reference: reference,
                paidAt: paidAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$PaymentsTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._orderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      required String action,
      required String payload,
      Value<String> status,
      Value<int> retryCount,
      required DateTime createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> action,
      Value<String> payload,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
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

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
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

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                action: action,
                payload: payload,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String action,
                required String payload,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                action: action,
                payload: payload,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$AuditTrailTableCreateCompanionBuilder =
    AuditTrailCompanion Function({
      Value<String> id,
      required String userId,
      required String action,
      required String targetType,
      required String targetId,
      Value<String?> details,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AuditTrailTableUpdateCompanionBuilder =
    AuditTrailCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> action,
      Value<String> targetType,
      Value<String> targetId,
      Value<String?> details,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AuditTrailTableReferences
    extends BaseReferences<_$AppDatabase, $AuditTrailTable, AuditTrailData> {
  $$AuditTrailTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.auditTrail.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuditTrailTableFilterComposer
    extends Composer<_$AppDatabase, $AuditTrailTable> {
  $$AuditTrailTableFilterComposer({
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

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditTrailTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditTrailTable> {
  $$AuditTrailTableOrderingComposer({
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

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditTrailTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditTrailTable> {
  $$AuditTrailTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditTrailTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditTrailTable,
          AuditTrailData,
          $$AuditTrailTableFilterComposer,
          $$AuditTrailTableOrderingComposer,
          $$AuditTrailTableAnnotationComposer,
          $$AuditTrailTableCreateCompanionBuilder,
          $$AuditTrailTableUpdateCompanionBuilder,
          (AuditTrailData, $$AuditTrailTableReferences),
          AuditTrailData,
          PrefetchHooks Function({bool userId})
        > {
  $$AuditTrailTableTableManager(_$AppDatabase db, $AuditTrailTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditTrailTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditTrailTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditTrailTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditTrailCompanion(
                id: id,
                userId: userId,
                action: action,
                targetType: targetType,
                targetId: targetId,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String userId,
                required String action,
                required String targetType,
                required String targetId,
                Value<String?> details = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AuditTrailCompanion.insert(
                id: id,
                userId: userId,
                action: action,
                targetType: targetType,
                targetId: targetId,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditTrailTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$AuditTrailTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$AuditTrailTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AuditTrailTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditTrailTable,
      AuditTrailData,
      $$AuditTrailTableFilterComposer,
      $$AuditTrailTableOrderingComposer,
      $$AuditTrailTableAnnotationComposer,
      $$AuditTrailTableCreateCompanionBuilder,
      $$AuditTrailTableUpdateCompanionBuilder,
      (AuditTrailData, $$AuditTrailTableReferences),
      AuditTrailData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$VouchersTableCreateCompanionBuilder =
    VouchersCompanion Function({
      Value<String> id,
      required String code,
      required double amount,
      Value<String> status,
      Value<String?> orderId,
      Value<DateTime?> usedAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VouchersTableUpdateCompanionBuilder =
    VouchersCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<double> amount,
      Value<String> status,
      Value<String?> orderId,
      Value<DateTime?> usedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$VouchersTableReferences
    extends BaseReferences<_$AppDatabase, $VouchersTable, Voucher> {
  $$VouchersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.vouchers.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager? get orderId {
    final $_column = $_itemColumn<String>('order_id');
    if ($_column == null) return null;
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VouchersTableFilterComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get usedAt => $composableBuilder(
    column: $table.usedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VouchersTableOrderingComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get usedAt => $composableBuilder(
    column: $table.usedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VouchersTableAnnotationComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VouchersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VouchersTable,
          Voucher,
          $$VouchersTableFilterComposer,
          $$VouchersTableOrderingComposer,
          $$VouchersTableAnnotationComposer,
          $$VouchersTableCreateCompanionBuilder,
          $$VouchersTableUpdateCompanionBuilder,
          (Voucher, $$VouchersTableReferences),
          Voucher,
          PrefetchHooks Function({bool orderId})
        > {
  $$VouchersTableTableManager(_$AppDatabase db, $VouchersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VouchersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VouchersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VouchersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<DateTime?> usedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VouchersCompanion(
                id: id,
                code: code,
                amount: amount,
                status: status,
                orderId: orderId,
                usedAt: usedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String code,
                required double amount,
                Value<String> status = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<DateTime?> usedAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VouchersCompanion.insert(
                id: id,
                code: code,
                amount: amount,
                status: status,
                orderId: orderId,
                usedAt: usedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VouchersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$VouchersTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$VouchersTableReferences
                                    ._orderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VouchersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VouchersTable,
      Voucher,
      $$VouchersTableFilterComposer,
      $$VouchersTableOrderingComposer,
      $$VouchersTableAnnotationComposer,
      $$VouchersTableCreateCompanionBuilder,
      $$VouchersTableUpdateCompanionBuilder,
      (Voucher, $$VouchersTableReferences),
      Voucher,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$KitchenNotesTableCreateCompanionBuilder =
    KitchenNotesCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> nameAr,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$KitchenNotesTableUpdateCompanionBuilder =
    KitchenNotesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> nameAr,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$KitchenNotesTableFilterComposer
    extends Composer<_$AppDatabase, $KitchenNotesTable> {
  $$KitchenNotesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KitchenNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $KitchenNotesTable> {
  $$KitchenNotesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KitchenNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KitchenNotesTable> {
  $$KitchenNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$KitchenNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KitchenNotesTable,
          KitchenNote,
          $$KitchenNotesTableFilterComposer,
          $$KitchenNotesTableOrderingComposer,
          $$KitchenNotesTableAnnotationComposer,
          $$KitchenNotesTableCreateCompanionBuilder,
          $$KitchenNotesTableUpdateCompanionBuilder,
          (
            KitchenNote,
            BaseReferences<_$AppDatabase, $KitchenNotesTable, KitchenNote>,
          ),
          KitchenNote,
          PrefetchHooks Function()
        > {
  $$KitchenNotesTableTableManager(_$AppDatabase db, $KitchenNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KitchenNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KitchenNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KitchenNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitchenNotesCompanion(
                id: id,
                name: name,
                nameAr: nameAr,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> nameAr = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitchenNotesCompanion.insert(
                id: id,
                name: name,
                nameAr: nameAr,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KitchenNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KitchenNotesTable,
      KitchenNote,
      $$KitchenNotesTableFilterComposer,
      $$KitchenNotesTableOrderingComposer,
      $$KitchenNotesTableAnnotationComposer,
      $$KitchenNotesTableCreateCompanionBuilder,
      $$KitchenNotesTableUpdateCompanionBuilder,
      (
        KitchenNote,
        BaseReferences<_$AppDatabase, $KitchenNotesTable, KitchenNote>,
      ),
      KitchenNote,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> taxId,
      Value<double> accountBalance,
      Value<double> creditLimit,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> taxId,
      Value<double> accountBalance,
      Value<double> creditLimit,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxId => $composableBuilder(
    column: $table.taxId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accountBalance => $composableBuilder(
    column: $table.accountBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxId => $composableBuilder(
    column: $table.taxId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accountBalance => $composableBuilder(
    column: $table.accountBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get taxId =>
      $composableBuilder(column: $table.taxId, builder: (column) => column);

  GeneratedColumn<double> get accountBalance => $composableBuilder(
    column: $table.accountBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> taxId = const Value.absent(),
                Value<double> accountBalance = const Value.absent(),
                Value<double> creditLimit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                email: email,
                address: address,
                taxId: taxId,
                accountBalance: accountBalance,
                creditLimit: creditLimit,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> taxId = const Value.absent(),
                Value<double> accountBalance = const Value.absent(),
                Value<double> creditLimit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                email: email,
                address: address,
                taxId: taxId,
                accountBalance: accountBalance,
                creditLimit: creditLimit,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RestaurantConfigTableTableManager get restaurantConfig =>
      $$RestaurantConfigTableTableManager(_db, _db.restaurantConfig);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SecurityRulesTableTableManager get securityRules =>
      $$SecurityRulesTableTableManager(_db, _db.securityRules);
  $$ZonesTableTableManager get zones =>
      $$ZonesTableTableManager(_db, _db.zones);
  $$RestaurantTablesTableTableManager get restaurantTables =>
      $$RestaurantTablesTableTableManager(_db, _db.restaurantTables);
  $$ReservationsTableTableManager get reservations =>
      $$ReservationsTableTableManager(_db, _db.reservations);
  $$TimeAttendanceTableTableManager get timeAttendance =>
      $$TimeAttendanceTableTableManager(_db, _db.timeAttendance);
  $$PrintStationsTableTableManager get printStations =>
      $$PrintStationsTableTableManager(_db, _db.printStations);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ModifierGroupsTableTableManager get modifierGroups =>
      $$ModifierGroupsTableTableManager(_db, _db.modifierGroups);
  $$ModifierOptionsTableTableManager get modifierOptions =>
      $$ModifierOptionsTableTableManager(_db, _db.modifierOptions);
  $$ProductModifiersTableTableManager get productModifiers =>
      $$ProductModifiersTableTableManager(_db, _db.productModifiers);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db, _db.recipeItems);
  $$CashSessionsTableTableManager get cashSessions =>
      $$CashSessionsTableTableManager(_db, _db.cashSessions);
  $$CashMovementsTableTableManager get cashMovements =>
      $$CashMovementsTableTableManager(_db, _db.cashMovements);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$OrderItemModifiersTableTableManager get orderItemModifiers =>
      $$OrderItemModifiersTableTableManager(_db, _db.orderItemModifiers);
  $$DiscountsTableTableManager get discounts =>
      $$DiscountsTableTableManager(_db, _db.discounts);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$AuditTrailTableTableManager get auditTrail =>
      $$AuditTrailTableTableManager(_db, _db.auditTrail);
  $$VouchersTableTableManager get vouchers =>
      $$VouchersTableTableManager(_db, _db.vouchers);
  $$KitchenNotesTableTableManager get kitchenNotes =>
      $$KitchenNotesTableTableManager(_db, _db.kitchenNotes);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
}
