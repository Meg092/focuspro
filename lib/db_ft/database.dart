import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_ft_entity.dart';

class FtDatabase {
  static final FtDatabase instance = FtDatabase._internal();
  static Database? _database;

  FtDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'focus_train.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE game_records ADD COLUMN errorCount INTEGER DEFAULT 0');
      await db.execute(
          'ALTER TABLE game_records ADD COLUMN reactionTime REAL');
      await db.execute(
          'ALTER TABLE game_records ADD COLUMN clickSpeed REAL');
    }
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameMode TEXT NOT NULL,
        timeTaken REAL NOT NULL,
        score INTEGER NOT NULL,
        playTime TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        errorCount INTEGER DEFAULT 0,
        reactionTime REAL,
        clickSpeed REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE level_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        levelId TEXT NOT NULL UNIQUE,
        isUnlocked INTEGER NOT NULL,
        bestTime REAL,
        lastPlayed TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL UNIQUE,
        value TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE listening_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trainingType TEXT NOT NULL,
        totalQuestions INTEGER NOT NULL,
        correctCount INTEGER NOT NULL,
        avgTime REAL NOT NULL,
        score INTEGER NOT NULL,
        playTime TEXT NOT NULL
      )
    ''');

    await _initializeDefaultLevels(db);

    await _initializeDefaultPreferences(db);
  }

  Future<void> _initializeDefaultLevels(Database db) async {
    await db.insert('level_progress', {
      'levelId': '3×3',
      'isUnlocked': 1,
      'bestTime': null,
      'lastPlayed': null,
    });

    final kidsLevels = ['4×4', '5×5', '6×6', '7×7', '8×8', '9×9', 'A-Z', 'a-z'];
    for (var level in kidsLevels) {
      await db.insert('level_progress', {
        'levelId': level,
        'isUnlocked': 0,
        'bestTime': null,
        'lastPlayed': null,
      });
    }

    await db.insert('level_progress', {
      'levelId': 'poetry_1',
      'isUnlocked': 1,
      'bestTime': null,
      'lastPlayed': null,
    });

    for (int i = 2; i <= 20; i++) {
      await db.insert('level_progress', {
        'levelId': 'poetry_$i',
        'isUnlocked': 0,
        'bestTime': null,
        'lastPlayed': null,
      });
    }
  }

  Future<void> _initializeDefaultPreferences(Database db) async {
    await db.insert('user_preferences', {
      'key': 'sound_enabled',
      'value': 'true',
    });

    await db.insert('user_preferences', {
      'key': 'score_broadcast',
      'value': 'true',
    });

    await db.insert('user_preferences', {
      'key': 'action_hints',
      'value': 'true',
    });
  }
  Future<int> insertGameRecord(GameRecord record) async {
    final db = await database;
    return await db.insert('game_records', record.toMap());
  }

  Future<List<GameRecord>> getGameRecords({
    String? gameMode,
    int? limit,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    if (gameMode != null) {
      maps = await db.query(
        'game_records',
        where: 'gameMode = ?',
        whereArgs: [gameMode],
        orderBy: 'playTime DESC',
        limit: limit,
      );
    } else {
      maps = await db.query(
        'game_records',
        orderBy: 'playTime DESC',
        limit: limit,
      );
    }

    return maps.map((map) => GameRecord.fromMap(map)).toList();
  }

  Future<int> insertOrUpdateLevelProgress(LevelProgress progress) async {
    final db = await database;
    return await db.insert(
      'level_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LevelProgress?> getLevelProgress(String levelId) async {
    final db = await database;
    final maps = await db.query(
      'level_progress',
      where: 'levelId = ?',
      whereArgs: [levelId],
    );

    if (maps.isEmpty) return null;
    return LevelProgress.fromMap(maps.first);
  }

  Future<List<LevelProgress>> getAllLevelProgress() async {
    final db = await database;
    final maps = await db.query('level_progress');
    return maps.map((map) => LevelProgress.fromMap(map)).toList();
  }

  Future<int> updateLevelProgress(LevelProgress progress) async {
    final db = await database;
    return await db.update(
      'level_progress',
      progress.toMap(),
      where: 'levelId = ?',
      whereArgs: [progress.levelId],
    );
  }
  Future<int> setPreference(String key, String value) async {
    final db = await database;
    return await db.insert('user_preferences', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    final maps = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<bool> getBoolPreference(
    String key, {
    bool defaultValue = false,
  }) async {
    final value = await getPreference(key);
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }
  Future<int> insertListeningRecord(ListeningRecord record) async {
    final db = await database;
    return await db.insert('listening_records', record.toMap());
  }

  Future<List<ListeningRecord>> getListeningRecords({
    String? trainingType,
    int? limit,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    if (trainingType != null) {
      maps = await db.query(
        'listening_records',
        where: 'trainingType = ?',
        whereArgs: [trainingType],
        orderBy: 'playTime DESC',
        limit: limit,
      );
    } else {
      maps = await db.query(
        'listening_records',
        orderBy: 'playTime DESC',
        limit: limit,
      );
    }

    return maps.map((map) => ListeningRecord.fromMap(map)).toList();
  }
  Future<void> clearGameRecords() async {
    final db = await database;
    await db.delete('game_records');
  }

  Future<void> clearListeningRecords() async {
    final db = await database;
    await db.delete('listening_records');
  }


  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
