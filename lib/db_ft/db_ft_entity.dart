
class GameRecord {
  int? id;
  String gameMode;
  double timeTaken;
  int score;
  DateTime playTime;
  bool isCompleted;
  int errorCount;
  double? reactionTime;
  double? clickSpeed;

  GameRecord({
    this.id,
    required this.gameMode,
    required this.timeTaken,
    required this.score,
    required this.playTime,
    required this.isCompleted,
    this.errorCount = 0,
    this.reactionTime,
    this.clickSpeed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameMode': gameMode,
      'timeTaken': timeTaken,
      'score': score,
      'playTime': playTime.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'errorCount': errorCount,
      'reactionTime': reactionTime,
      'clickSpeed': clickSpeed,
    };
  }

  factory GameRecord.fromMap(Map<String, dynamic> map) {
    return GameRecord(
      id: map['id'] as int?,
      gameMode: map['gameMode'] as String,
      timeTaken: map['timeTaken'] as double,
      score: map['score'] as int,
      playTime: DateTime.parse(map['playTime'] as String),
      isCompleted: (map['isCompleted'] as int) == 1,
      errorCount: map['errorCount'] as int? ?? 0,
      reactionTime: map['reactionTime'] as double?,
      clickSpeed: map['clickSpeed'] as double?,
    );
  }
}

class LevelProgress {
  int? id;
  String levelId;
  bool isUnlocked;
  double? bestTime;
  DateTime? lastPlayed;

  LevelProgress({
    this.id,
    required this.levelId,
    required this.isUnlocked,
    this.bestTime,
    this.lastPlayed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'levelId': levelId,
      'isUnlocked': isUnlocked ? 1 : 0,
      'bestTime': bestTime,
      'lastPlayed': lastPlayed?.toIso8601String(),
    };
  }

  factory LevelProgress.fromMap(Map<String, dynamic> map) {
    return LevelProgress(
      id: map['id'] as int?,
      levelId: map['levelId'] as String,
      isUnlocked: (map['isUnlocked'] as int) == 1,
      bestTime: map['bestTime'] as double?,
      lastPlayed: map['lastPlayed'] != null
          ? DateTime.parse(map['lastPlayed'] as String)
          : null,
    );
  }
}

class UserPreference {
  int? id;
  String key;
  String value;

  UserPreference({
    this.id,
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'value': value,
    };
  }

  factory UserPreference.fromMap(Map<String, dynamic> map) {
    return UserPreference(
      id: map['id'] as int?,
      key: map['key'] as String,
      value: map['value'] as String,
    );
  }
}

class ListeningRecord {
  int? id;
  String trainingType;
  int totalQuestions;
  int correctCount;
  double avgTime;
  int score;
  DateTime playTime;

  ListeningRecord({
    this.id,
    required this.trainingType,
    required this.totalQuestions,
    required this.correctCount,
    required this.avgTime,
    required this.score,
    required this.playTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trainingType': trainingType,
      'totalQuestions': totalQuestions,
      'correctCount': correctCount,
      'avgTime': avgTime,
      'score': score,
      'playTime': playTime.toIso8601String(),
    };
  }

  factory ListeningRecord.fromMap(Map<String, dynamic> map) {
    return ListeningRecord(
      id: map['id'] as int?,
      trainingType: map['trainingType'] as String,
      totalQuestions: map['totalQuestions'] as int,
      correctCount: map['correctCount'] as int,
      avgTime: map['avgTime'] as double,
      score: map['score'] as int,
      playTime: DateTime.parse(map['playTime'] as String),
    );
  }
}
