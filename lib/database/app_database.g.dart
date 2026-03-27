// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
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
    defaultValue: const Constant('IN_PROGRESS'),
  );
  static const VerificationMeta _swingCountMeta = const VerificationMeta(
    'swingCount',
  );
  @override
  late final GeneratedColumn<int> swingCount = GeneratedColumn<int>(
    'swing_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _peakSpeedMphMeta = const VerificationMeta(
    'peakSpeedMph',
  );
  @override
  late final GeneratedColumn<double> peakSpeedMph = GeneratedColumn<double>(
    'peak_speed_mph',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _avgSpeedMphMeta = const VerificationMeta(
    'avgSpeedMph',
  );
  @override
  late final GeneratedColumn<double> avgSpeedMph = GeneratedColumn<double>(
    'avg_speed_mph',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _consistencyScoreMeta = const VerificationMeta(
    'consistencyScore',
  );
  @override
  late final GeneratedColumn<double> consistencyScore = GeneratedColumn<double>(
    'consistency_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clubLengthOffsetMMeta = const VerificationMeta(
    'clubLengthOffsetM',
  );
  @override
  late final GeneratedColumn<double> clubLengthOffsetM =
      GeneratedColumn<double>(
        'club_length_offset_m',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    status,
    swingCount,
    peakSpeedMph,
    avgSpeedMph,
    consistencyScore,
    clubLengthOffsetM,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('swing_count')) {
      context.handle(
        _swingCountMeta,
        swingCount.isAcceptableOrUnknown(data['swing_count']!, _swingCountMeta),
      );
    }
    if (data.containsKey('peak_speed_mph')) {
      context.handle(
        _peakSpeedMphMeta,
        peakSpeedMph.isAcceptableOrUnknown(
          data['peak_speed_mph']!,
          _peakSpeedMphMeta,
        ),
      );
    }
    if (data.containsKey('avg_speed_mph')) {
      context.handle(
        _avgSpeedMphMeta,
        avgSpeedMph.isAcceptableOrUnknown(
          data['avg_speed_mph']!,
          _avgSpeedMphMeta,
        ),
      );
    }
    if (data.containsKey('consistency_score')) {
      context.handle(
        _consistencyScoreMeta,
        consistencyScore.isAcceptableOrUnknown(
          data['consistency_score']!,
          _consistencyScoreMeta,
        ),
      );
    }
    if (data.containsKey('club_length_offset_m')) {
      context.handle(
        _clubLengthOffsetMMeta,
        clubLengthOffsetM.isAcceptableOrUnknown(
          data['club_length_offset_m']!,
          _clubLengthOffsetMMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clubLengthOffsetMMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      swingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}swing_count'],
      )!,
      peakSpeedMph: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peak_speed_mph'],
      )!,
      avgSpeedMph: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_speed_mph'],
      )!,
      consistencyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consistency_score'],
      ),
      clubLengthOffsetM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}club_length_offset_m'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int date;
  final String status;
  final int swingCount;
  final double peakSpeedMph;
  final double avgSpeedMph;
  final double? consistencyScore;
  final double clubLengthOffsetM;
  const Session({
    required this.id,
    required this.date,
    required this.status,
    required this.swingCount,
    required this.peakSpeedMph,
    required this.avgSpeedMph,
    this.consistencyScore,
    required this.clubLengthOffsetM,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['status'] = Variable<String>(status);
    map['swing_count'] = Variable<int>(swingCount);
    map['peak_speed_mph'] = Variable<double>(peakSpeedMph);
    map['avg_speed_mph'] = Variable<double>(avgSpeedMph);
    if (!nullToAbsent || consistencyScore != null) {
      map['consistency_score'] = Variable<double>(consistencyScore);
    }
    map['club_length_offset_m'] = Variable<double>(clubLengthOffsetM);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      date: Value(date),
      status: Value(status),
      swingCount: Value(swingCount),
      peakSpeedMph: Value(peakSpeedMph),
      avgSpeedMph: Value(avgSpeedMph),
      consistencyScore: consistencyScore == null && nullToAbsent
          ? const Value.absent()
          : Value(consistencyScore),
      clubLengthOffsetM: Value(clubLengthOffsetM),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      swingCount: serializer.fromJson<int>(json['swingCount']),
      peakSpeedMph: serializer.fromJson<double>(json['peakSpeedMph']),
      avgSpeedMph: serializer.fromJson<double>(json['avgSpeedMph']),
      consistencyScore: serializer.fromJson<double?>(json['consistencyScore']),
      clubLengthOffsetM: serializer.fromJson<double>(json['clubLengthOffsetM']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'status': serializer.toJson<String>(status),
      'swingCount': serializer.toJson<int>(swingCount),
      'peakSpeedMph': serializer.toJson<double>(peakSpeedMph),
      'avgSpeedMph': serializer.toJson<double>(avgSpeedMph),
      'consistencyScore': serializer.toJson<double?>(consistencyScore),
      'clubLengthOffsetM': serializer.toJson<double>(clubLengthOffsetM),
    };
  }

  Session copyWith({
    int? id,
    int? date,
    String? status,
    int? swingCount,
    double? peakSpeedMph,
    double? avgSpeedMph,
    Value<double?> consistencyScore = const Value.absent(),
    double? clubLengthOffsetM,
  }) => Session(
    id: id ?? this.id,
    date: date ?? this.date,
    status: status ?? this.status,
    swingCount: swingCount ?? this.swingCount,
    peakSpeedMph: peakSpeedMph ?? this.peakSpeedMph,
    avgSpeedMph: avgSpeedMph ?? this.avgSpeedMph,
    consistencyScore: consistencyScore.present
        ? consistencyScore.value
        : this.consistencyScore,
    clubLengthOffsetM: clubLengthOffsetM ?? this.clubLengthOffsetM,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      swingCount: data.swingCount.present
          ? data.swingCount.value
          : this.swingCount,
      peakSpeedMph: data.peakSpeedMph.present
          ? data.peakSpeedMph.value
          : this.peakSpeedMph,
      avgSpeedMph: data.avgSpeedMph.present
          ? data.avgSpeedMph.value
          : this.avgSpeedMph,
      consistencyScore: data.consistencyScore.present
          ? data.consistencyScore.value
          : this.consistencyScore,
      clubLengthOffsetM: data.clubLengthOffsetM.present
          ? data.clubLengthOffsetM.value
          : this.clubLengthOffsetM,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('swingCount: $swingCount, ')
          ..write('peakSpeedMph: $peakSpeedMph, ')
          ..write('avgSpeedMph: $avgSpeedMph, ')
          ..write('consistencyScore: $consistencyScore, ')
          ..write('clubLengthOffsetM: $clubLengthOffsetM')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    status,
    swingCount,
    peakSpeedMph,
    avgSpeedMph,
    consistencyScore,
    clubLengthOffsetM,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.date == this.date &&
          other.status == this.status &&
          other.swingCount == this.swingCount &&
          other.peakSpeedMph == this.peakSpeedMph &&
          other.avgSpeedMph == this.avgSpeedMph &&
          other.consistencyScore == this.consistencyScore &&
          other.clubLengthOffsetM == this.clubLengthOffsetM);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> date;
  final Value<String> status;
  final Value<int> swingCount;
  final Value<double> peakSpeedMph;
  final Value<double> avgSpeedMph;
  final Value<double?> consistencyScore;
  final Value<double> clubLengthOffsetM;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.swingCount = const Value.absent(),
    this.peakSpeedMph = const Value.absent(),
    this.avgSpeedMph = const Value.absent(),
    this.consistencyScore = const Value.absent(),
    this.clubLengthOffsetM = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    this.status = const Value.absent(),
    this.swingCount = const Value.absent(),
    this.peakSpeedMph = const Value.absent(),
    this.avgSpeedMph = const Value.absent(),
    this.consistencyScore = const Value.absent(),
    required double clubLengthOffsetM,
  }) : date = Value(date),
       clubLengthOffsetM = Value(clubLengthOffsetM);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<String>? status,
    Expression<int>? swingCount,
    Expression<double>? peakSpeedMph,
    Expression<double>? avgSpeedMph,
    Expression<double>? consistencyScore,
    Expression<double>? clubLengthOffsetM,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (swingCount != null) 'swing_count': swingCount,
      if (peakSpeedMph != null) 'peak_speed_mph': peakSpeedMph,
      if (avgSpeedMph != null) 'avg_speed_mph': avgSpeedMph,
      if (consistencyScore != null) 'consistency_score': consistencyScore,
      if (clubLengthOffsetM != null) 'club_length_offset_m': clubLengthOffsetM,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? date,
    Value<String>? status,
    Value<int>? swingCount,
    Value<double>? peakSpeedMph,
    Value<double>? avgSpeedMph,
    Value<double?>? consistencyScore,
    Value<double>? clubLengthOffsetM,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      swingCount: swingCount ?? this.swingCount,
      peakSpeedMph: peakSpeedMph ?? this.peakSpeedMph,
      avgSpeedMph: avgSpeedMph ?? this.avgSpeedMph,
      consistencyScore: consistencyScore ?? this.consistencyScore,
      clubLengthOffsetM: clubLengthOffsetM ?? this.clubLengthOffsetM,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (swingCount.present) {
      map['swing_count'] = Variable<int>(swingCount.value);
    }
    if (peakSpeedMph.present) {
      map['peak_speed_mph'] = Variable<double>(peakSpeedMph.value);
    }
    if (avgSpeedMph.present) {
      map['avg_speed_mph'] = Variable<double>(avgSpeedMph.value);
    }
    if (consistencyScore.present) {
      map['consistency_score'] = Variable<double>(consistencyScore.value);
    }
    if (clubLengthOffsetM.present) {
      map['club_length_offset_m'] = Variable<double>(clubLengthOffsetM.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('swingCount: $swingCount, ')
          ..write('peakSpeedMph: $peakSpeedMph, ')
          ..write('avgSpeedMph: $avgSpeedMph, ')
          ..write('consistencyScore: $consistencyScore, ')
          ..write('clubLengthOffsetM: $clubLengthOffsetM')
          ..write(')'))
        .toString();
  }
}

class $SwingsTable extends Swings with TableInfo<$SwingsTable, Swing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peakSpeedMphMeta = const VerificationMeta(
    'peakSpeedMph',
  );
  @override
  late final GeneratedColumn<double> peakSpeedMph = GeneratedColumn<double>(
    'peak_speed_mph',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    timestamp,
    peakSpeedMph,
    durationMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'swings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Swing> instance, {
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
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('peak_speed_mph')) {
      context.handle(
        _peakSpeedMphMeta,
        peakSpeedMph.isAcceptableOrUnknown(
          data['peak_speed_mph']!,
          _peakSpeedMphMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_peakSpeedMphMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Swing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Swing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      peakSpeedMph: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peak_speed_mph'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
    );
  }

  @override
  $SwingsTable createAlias(String alias) {
    return $SwingsTable(attachedDatabase, alias);
  }
}

class Swing extends DataClass implements Insertable<Swing> {
  final int id;
  final int sessionId;
  final int timestamp;
  final double peakSpeedMph;
  final int durationMs;
  const Swing({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.peakSpeedMph,
    required this.durationMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['timestamp'] = Variable<int>(timestamp);
    map['peak_speed_mph'] = Variable<double>(peakSpeedMph);
    map['duration_ms'] = Variable<int>(durationMs);
    return map;
  }

  SwingsCompanion toCompanion(bool nullToAbsent) {
    return SwingsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      timestamp: Value(timestamp),
      peakSpeedMph: Value(peakSpeedMph),
      durationMs: Value(durationMs),
    );
  }

  factory Swing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Swing(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      peakSpeedMph: serializer.fromJson<double>(json['peakSpeedMph']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'timestamp': serializer.toJson<int>(timestamp),
      'peakSpeedMph': serializer.toJson<double>(peakSpeedMph),
      'durationMs': serializer.toJson<int>(durationMs),
    };
  }

  Swing copyWith({
    int? id,
    int? sessionId,
    int? timestamp,
    double? peakSpeedMph,
    int? durationMs,
  }) => Swing(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    timestamp: timestamp ?? this.timestamp,
    peakSpeedMph: peakSpeedMph ?? this.peakSpeedMph,
    durationMs: durationMs ?? this.durationMs,
  );
  Swing copyWithCompanion(SwingsCompanion data) {
    return Swing(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      peakSpeedMph: data.peakSpeedMph.present
          ? data.peakSpeedMph.value
          : this.peakSpeedMph,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Swing(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('peakSpeedMph: $peakSpeedMph, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, timestamp, peakSpeedMph, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Swing &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.timestamp == this.timestamp &&
          other.peakSpeedMph == this.peakSpeedMph &&
          other.durationMs == this.durationMs);
}

class SwingsCompanion extends UpdateCompanion<Swing> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> timestamp;
  final Value<double> peakSpeedMph;
  final Value<int> durationMs;
  const SwingsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.peakSpeedMph = const Value.absent(),
    this.durationMs = const Value.absent(),
  });
  SwingsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int timestamp,
    required double peakSpeedMph,
    required int durationMs,
  }) : sessionId = Value(sessionId),
       timestamp = Value(timestamp),
       peakSpeedMph = Value(peakSpeedMph),
       durationMs = Value(durationMs);
  static Insertable<Swing> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? timestamp,
    Expression<double>? peakSpeedMph,
    Expression<int>? durationMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (peakSpeedMph != null) 'peak_speed_mph': peakSpeedMph,
      if (durationMs != null) 'duration_ms': durationMs,
    });
  }

  SwingsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? timestamp,
    Value<double>? peakSpeedMph,
    Value<int>? durationMs,
  }) {
    return SwingsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      peakSpeedMph: peakSpeedMph ?? this.peakSpeedMph,
      durationMs: durationMs ?? this.durationMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (peakSpeedMph.present) {
      map['peak_speed_mph'] = Variable<double>(peakSpeedMph.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwingsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('peakSpeedMph: $peakSpeedMph, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _clubLengthOffsetMMeta = const VerificationMeta(
    'clubLengthOffsetM',
  );
  @override
  late final GeneratedColumn<double> clubLengthOffsetM =
      GeneratedColumn<double>(
        'club_length_offset_m',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.5),
      );
  static const VerificationMeta _allTimePeakMphMeta = const VerificationMeta(
    'allTimePeakMph',
  );
  @override
  late final GeneratedColumn<double> allTimePeakMph = GeneratedColumn<double>(
    'all_time_peak_mph',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _swingStartThresholdMeta =
      const VerificationMeta('swingStartThreshold');
  @override
  late final GeneratedColumn<double> swingStartThreshold =
      GeneratedColumn<double>(
        'swing_start_threshold',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(3.0),
      );
  static const VerificationMeta _swingEndThresholdMeta = const VerificationMeta(
    'swingEndThreshold',
  );
  @override
  late final GeneratedColumn<double> swingEndThreshold =
      GeneratedColumn<double>(
        'swing_end_threshold',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.0),
      );
  static const VerificationMeta _cooldownMsMeta = const VerificationMeta(
    'cooldownMs',
  );
  @override
  late final GeneratedColumn<int> cooldownMs = GeneratedColumn<int>(
    'cooldown_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1500),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clubLengthOffsetM,
    allTimePeakMph,
    swingStartThreshold,
    swingEndThreshold,
    cooldownMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('club_length_offset_m')) {
      context.handle(
        _clubLengthOffsetMMeta,
        clubLengthOffsetM.isAcceptableOrUnknown(
          data['club_length_offset_m']!,
          _clubLengthOffsetMMeta,
        ),
      );
    }
    if (data.containsKey('all_time_peak_mph')) {
      context.handle(
        _allTimePeakMphMeta,
        allTimePeakMph.isAcceptableOrUnknown(
          data['all_time_peak_mph']!,
          _allTimePeakMphMeta,
        ),
      );
    }
    if (data.containsKey('swing_start_threshold')) {
      context.handle(
        _swingStartThresholdMeta,
        swingStartThreshold.isAcceptableOrUnknown(
          data['swing_start_threshold']!,
          _swingStartThresholdMeta,
        ),
      );
    }
    if (data.containsKey('swing_end_threshold')) {
      context.handle(
        _swingEndThresholdMeta,
        swingEndThreshold.isAcceptableOrUnknown(
          data['swing_end_threshold']!,
          _swingEndThresholdMeta,
        ),
      );
    }
    if (data.containsKey('cooldown_ms')) {
      context.handle(
        _cooldownMsMeta,
        cooldownMs.isAcceptableOrUnknown(data['cooldown_ms']!, _cooldownMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clubLengthOffsetM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}club_length_offset_m'],
      )!,
      allTimePeakMph: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}all_time_peak_mph'],
      )!,
      swingStartThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}swing_start_threshold'],
      )!,
      swingEndThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}swing_end_threshold'],
      )!,
      cooldownMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cooldown_ms'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final double clubLengthOffsetM;
  final double allTimePeakMph;
  final double swingStartThreshold;
  final double swingEndThreshold;
  final int cooldownMs;
  const Setting({
    required this.id,
    required this.clubLengthOffsetM,
    required this.allTimePeakMph,
    required this.swingStartThreshold,
    required this.swingEndThreshold,
    required this.cooldownMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['club_length_offset_m'] = Variable<double>(clubLengthOffsetM);
    map['all_time_peak_mph'] = Variable<double>(allTimePeakMph);
    map['swing_start_threshold'] = Variable<double>(swingStartThreshold);
    map['swing_end_threshold'] = Variable<double>(swingEndThreshold);
    map['cooldown_ms'] = Variable<int>(cooldownMs);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      clubLengthOffsetM: Value(clubLengthOffsetM),
      allTimePeakMph: Value(allTimePeakMph),
      swingStartThreshold: Value(swingStartThreshold),
      swingEndThreshold: Value(swingEndThreshold),
      cooldownMs: Value(cooldownMs),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      clubLengthOffsetM: serializer.fromJson<double>(json['clubLengthOffsetM']),
      allTimePeakMph: serializer.fromJson<double>(json['allTimePeakMph']),
      swingStartThreshold: serializer.fromJson<double>(
        json['swingStartThreshold'],
      ),
      swingEndThreshold: serializer.fromJson<double>(json['swingEndThreshold']),
      cooldownMs: serializer.fromJson<int>(json['cooldownMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clubLengthOffsetM': serializer.toJson<double>(clubLengthOffsetM),
      'allTimePeakMph': serializer.toJson<double>(allTimePeakMph),
      'swingStartThreshold': serializer.toJson<double>(swingStartThreshold),
      'swingEndThreshold': serializer.toJson<double>(swingEndThreshold),
      'cooldownMs': serializer.toJson<int>(cooldownMs),
    };
  }

  Setting copyWith({
    int? id,
    double? clubLengthOffsetM,
    double? allTimePeakMph,
    double? swingStartThreshold,
    double? swingEndThreshold,
    int? cooldownMs,
  }) => Setting(
    id: id ?? this.id,
    clubLengthOffsetM: clubLengthOffsetM ?? this.clubLengthOffsetM,
    allTimePeakMph: allTimePeakMph ?? this.allTimePeakMph,
    swingStartThreshold: swingStartThreshold ?? this.swingStartThreshold,
    swingEndThreshold: swingEndThreshold ?? this.swingEndThreshold,
    cooldownMs: cooldownMs ?? this.cooldownMs,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      clubLengthOffsetM: data.clubLengthOffsetM.present
          ? data.clubLengthOffsetM.value
          : this.clubLengthOffsetM,
      allTimePeakMph: data.allTimePeakMph.present
          ? data.allTimePeakMph.value
          : this.allTimePeakMph,
      swingStartThreshold: data.swingStartThreshold.present
          ? data.swingStartThreshold.value
          : this.swingStartThreshold,
      swingEndThreshold: data.swingEndThreshold.present
          ? data.swingEndThreshold.value
          : this.swingEndThreshold,
      cooldownMs: data.cooldownMs.present
          ? data.cooldownMs.value
          : this.cooldownMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('clubLengthOffsetM: $clubLengthOffsetM, ')
          ..write('allTimePeakMph: $allTimePeakMph, ')
          ..write('swingStartThreshold: $swingStartThreshold, ')
          ..write('swingEndThreshold: $swingEndThreshold, ')
          ..write('cooldownMs: $cooldownMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clubLengthOffsetM,
    allTimePeakMph,
    swingStartThreshold,
    swingEndThreshold,
    cooldownMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.clubLengthOffsetM == this.clubLengthOffsetM &&
          other.allTimePeakMph == this.allTimePeakMph &&
          other.swingStartThreshold == this.swingStartThreshold &&
          other.swingEndThreshold == this.swingEndThreshold &&
          other.cooldownMs == this.cooldownMs);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<double> clubLengthOffsetM;
  final Value<double> allTimePeakMph;
  final Value<double> swingStartThreshold;
  final Value<double> swingEndThreshold;
  final Value<int> cooldownMs;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.clubLengthOffsetM = const Value.absent(),
    this.allTimePeakMph = const Value.absent(),
    this.swingStartThreshold = const Value.absent(),
    this.swingEndThreshold = const Value.absent(),
    this.cooldownMs = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.clubLengthOffsetM = const Value.absent(),
    this.allTimePeakMph = const Value.absent(),
    this.swingStartThreshold = const Value.absent(),
    this.swingEndThreshold = const Value.absent(),
    this.cooldownMs = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<double>? clubLengthOffsetM,
    Expression<double>? allTimePeakMph,
    Expression<double>? swingStartThreshold,
    Expression<double>? swingEndThreshold,
    Expression<int>? cooldownMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clubLengthOffsetM != null) 'club_length_offset_m': clubLengthOffsetM,
      if (allTimePeakMph != null) 'all_time_peak_mph': allTimePeakMph,
      if (swingStartThreshold != null)
        'swing_start_threshold': swingStartThreshold,
      if (swingEndThreshold != null) 'swing_end_threshold': swingEndThreshold,
      if (cooldownMs != null) 'cooldown_ms': cooldownMs,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<double>? clubLengthOffsetM,
    Value<double>? allTimePeakMph,
    Value<double>? swingStartThreshold,
    Value<double>? swingEndThreshold,
    Value<int>? cooldownMs,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      clubLengthOffsetM: clubLengthOffsetM ?? this.clubLengthOffsetM,
      allTimePeakMph: allTimePeakMph ?? this.allTimePeakMph,
      swingStartThreshold: swingStartThreshold ?? this.swingStartThreshold,
      swingEndThreshold: swingEndThreshold ?? this.swingEndThreshold,
      cooldownMs: cooldownMs ?? this.cooldownMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clubLengthOffsetM.present) {
      map['club_length_offset_m'] = Variable<double>(clubLengthOffsetM.value);
    }
    if (allTimePeakMph.present) {
      map['all_time_peak_mph'] = Variable<double>(allTimePeakMph.value);
    }
    if (swingStartThreshold.present) {
      map['swing_start_threshold'] = Variable<double>(
        swingStartThreshold.value,
      );
    }
    if (swingEndThreshold.present) {
      map['swing_end_threshold'] = Variable<double>(swingEndThreshold.value);
    }
    if (cooldownMs.present) {
      map['cooldown_ms'] = Variable<int>(cooldownMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('clubLengthOffsetM: $clubLengthOffsetM, ')
          ..write('allTimePeakMph: $allTimePeakMph, ')
          ..write('swingStartThreshold: $swingStartThreshold, ')
          ..write('swingEndThreshold: $swingEndThreshold, ')
          ..write('cooldownMs: $cooldownMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SwingsTable swings = $SwingsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    swings,
    settings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('swings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required int date,
      Value<String> status,
      Value<int> swingCount,
      Value<double> peakSpeedMph,
      Value<double> avgSpeedMph,
      Value<double?> consistencyScore,
      required double clubLengthOffsetM,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<int> date,
      Value<String> status,
      Value<int> swingCount,
      Value<double> peakSpeedMph,
      Value<double> avgSpeedMph,
      Value<double?> consistencyScore,
      Value<double> clubLengthOffsetM,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SwingsTable, List<Swing>> _swingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.swings,
    aliasName: $_aliasNameGenerator(db.sessions.id, db.swings.sessionId),
  );

  $$SwingsTableProcessedTableManager get swingsRefs {
    final manager = $$SwingsTableTableManager(
      $_db,
      $_db.swings,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_swingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get swingCount => $composableBuilder(
    column: $table.swingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get peakSpeedMph => $composableBuilder(
    column: $table.peakSpeedMph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSpeedMph => $composableBuilder(
    column: $table.avgSpeedMph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consistencyScore => $composableBuilder(
    column: $table.consistencyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get clubLengthOffsetM => $composableBuilder(
    column: $table.clubLengthOffsetM,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> swingsRefs(
    Expression<bool> Function($$SwingsTableFilterComposer f) f,
  ) {
    final $$SwingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swings,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingsTableFilterComposer(
            $db: $db,
            $table: $db.swings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get swingCount => $composableBuilder(
    column: $table.swingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get peakSpeedMph => $composableBuilder(
    column: $table.peakSpeedMph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSpeedMph => $composableBuilder(
    column: $table.avgSpeedMph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consistencyScore => $composableBuilder(
    column: $table.consistencyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get clubLengthOffsetM => $composableBuilder(
    column: $table.clubLengthOffsetM,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get swingCount => $composableBuilder(
    column: $table.swingCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get peakSpeedMph => $composableBuilder(
    column: $table.peakSpeedMph,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgSpeedMph => $composableBuilder(
    column: $table.avgSpeedMph,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consistencyScore => $composableBuilder(
    column: $table.consistencyScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get clubLengthOffsetM => $composableBuilder(
    column: $table.clubLengthOffsetM,
    builder: (column) => column,
  );

  Expression<T> swingsRefs<T extends Object>(
    Expression<T> Function($$SwingsTableAnnotationComposer a) f,
  ) {
    final $$SwingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swings,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingsTableAnnotationComposer(
            $db: $db,
            $table: $db.swings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({bool swingsRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> swingCount = const Value.absent(),
                Value<double> peakSpeedMph = const Value.absent(),
                Value<double> avgSpeedMph = const Value.absent(),
                Value<double?> consistencyScore = const Value.absent(),
                Value<double> clubLengthOffsetM = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                date: date,
                status: status,
                swingCount: swingCount,
                peakSpeedMph: peakSpeedMph,
                avgSpeedMph: avgSpeedMph,
                consistencyScore: consistencyScore,
                clubLengthOffsetM: clubLengthOffsetM,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int date,
                Value<String> status = const Value.absent(),
                Value<int> swingCount = const Value.absent(),
                Value<double> peakSpeedMph = const Value.absent(),
                Value<double> avgSpeedMph = const Value.absent(),
                Value<double?> consistencyScore = const Value.absent(),
                required double clubLengthOffsetM,
              }) => SessionsCompanion.insert(
                id: id,
                date: date,
                status: status,
                swingCount: swingCount,
                peakSpeedMph: peakSpeedMph,
                avgSpeedMph: avgSpeedMph,
                consistencyScore: consistencyScore,
                clubLengthOffsetM: clubLengthOffsetM,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({swingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (swingsRefs) db.swings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (swingsRefs)
                    await $_getPrefetchedData<Session, $SessionsTable, Swing>(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._swingsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableReferences(db, table, p0).swingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool swingsRefs})
    >;
typedef $$SwingsTableCreateCompanionBuilder =
    SwingsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int timestamp,
      required double peakSpeedMph,
      required int durationMs,
    });
typedef $$SwingsTableUpdateCompanionBuilder =
    SwingsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> timestamp,
      Value<double> peakSpeedMph,
      Value<int> durationMs,
    });

final class $$SwingsTableReferences
    extends BaseReferences<_$AppDatabase, $SwingsTable, Swing> {
  $$SwingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) => db.sessions
      .createAlias($_aliasNameGenerator(db.swings.sessionId, db.sessions.id));

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SwingsTableFilterComposer
    extends Composer<_$AppDatabase, $SwingsTable> {
  $$SwingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get peakSpeedMph => $composableBuilder(
    column: $table.peakSpeedMph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SwingsTable> {
  $$SwingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get peakSpeedMph => $composableBuilder(
    column: $table.peakSpeedMph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwingsTable> {
  $$SwingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get peakSpeedMph => $composableBuilder(
    column: $table.peakSpeedMph,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SwingsTable,
          Swing,
          $$SwingsTableFilterComposer,
          $$SwingsTableOrderingComposer,
          $$SwingsTableAnnotationComposer,
          $$SwingsTableCreateCompanionBuilder,
          $$SwingsTableUpdateCompanionBuilder,
          (Swing, $$SwingsTableReferences),
          Swing,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SwingsTableTableManager(_$AppDatabase db, $SwingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<double> peakSpeedMph = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
              }) => SwingsCompanion(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                peakSpeedMph: peakSpeedMph,
                durationMs: durationMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int timestamp,
                required double peakSpeedMph,
                required int durationMs,
              }) => SwingsCompanion.insert(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                peakSpeedMph: peakSpeedMph,
                durationMs: durationMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SwingsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                                referencedTable: $$SwingsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$SwingsTableReferences
                                    ._sessionIdTable(db)
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

typedef $$SwingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SwingsTable,
      Swing,
      $$SwingsTableFilterComposer,
      $$SwingsTableOrderingComposer,
      $$SwingsTableAnnotationComposer,
      $$SwingsTableCreateCompanionBuilder,
      $$SwingsTableUpdateCompanionBuilder,
      (Swing, $$SwingsTableReferences),
      Swing,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<double> clubLengthOffsetM,
      Value<double> allTimePeakMph,
      Value<double> swingStartThreshold,
      Value<double> swingEndThreshold,
      Value<int> cooldownMs,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<double> clubLengthOffsetM,
      Value<double> allTimePeakMph,
      Value<double> swingStartThreshold,
      Value<double> swingEndThreshold,
      Value<int> cooldownMs,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get clubLengthOffsetM => $composableBuilder(
    column: $table.clubLengthOffsetM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get allTimePeakMph => $composableBuilder(
    column: $table.allTimePeakMph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get swingStartThreshold => $composableBuilder(
    column: $table.swingStartThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get swingEndThreshold => $composableBuilder(
    column: $table.swingEndThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cooldownMs => $composableBuilder(
    column: $table.cooldownMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get clubLengthOffsetM => $composableBuilder(
    column: $table.clubLengthOffsetM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get allTimePeakMph => $composableBuilder(
    column: $table.allTimePeakMph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get swingStartThreshold => $composableBuilder(
    column: $table.swingStartThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get swingEndThreshold => $composableBuilder(
    column: $table.swingEndThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cooldownMs => $composableBuilder(
    column: $table.cooldownMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get clubLengthOffsetM => $composableBuilder(
    column: $table.clubLengthOffsetM,
    builder: (column) => column,
  );

  GeneratedColumn<double> get allTimePeakMph => $composableBuilder(
    column: $table.allTimePeakMph,
    builder: (column) => column,
  );

  GeneratedColumn<double> get swingStartThreshold => $composableBuilder(
    column: $table.swingStartThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<double> get swingEndThreshold => $composableBuilder(
    column: $table.swingEndThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cooldownMs => $composableBuilder(
    column: $table.cooldownMs,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> clubLengthOffsetM = const Value.absent(),
                Value<double> allTimePeakMph = const Value.absent(),
                Value<double> swingStartThreshold = const Value.absent(),
                Value<double> swingEndThreshold = const Value.absent(),
                Value<int> cooldownMs = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                clubLengthOffsetM: clubLengthOffsetM,
                allTimePeakMph: allTimePeakMph,
                swingStartThreshold: swingStartThreshold,
                swingEndThreshold: swingEndThreshold,
                cooldownMs: cooldownMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> clubLengthOffsetM = const Value.absent(),
                Value<double> allTimePeakMph = const Value.absent(),
                Value<double> swingStartThreshold = const Value.absent(),
                Value<double> swingEndThreshold = const Value.absent(),
                Value<int> cooldownMs = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                clubLengthOffsetM: clubLengthOffsetM,
                allTimePeakMph: allTimePeakMph,
                swingStartThreshold: swingStartThreshold,
                swingEndThreshold: swingEndThreshold,
                cooldownMs: cooldownMs,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SwingsTableTableManager get swings =>
      $$SwingsTableTableManager(_db, _db.swings);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
