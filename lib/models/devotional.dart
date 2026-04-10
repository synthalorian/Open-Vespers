class ScriptureReading {
  final String reference;
  final String text;
  final String? translation;

  const ScriptureReading({
    required this.reference,
    required this.text,
    this.translation = 'CSB',
  });

  Map<String, dynamic> toMap() => {
        'reference': reference,
        'text': text,
        'translation': translation,
      };

  factory ScriptureReading.fromMap(Map<dynamic, dynamic> map) {
    return ScriptureReading(
      reference: map['reference'] as String,
      text: map['text'] as String,
      translation: map['translation'] as String?,
    );
  }
}

class ReflectionPrompt {
  final String question;
  final String? hint;

  const ReflectionPrompt({required this.question, this.hint});

  Map<String, dynamic> toMap() => {'question': question, 'hint': hint};

  factory ReflectionPrompt.fromMap(Map<dynamic, dynamic> map) {
    return ReflectionPrompt(
      question: map['question'] as String,
      hint: map['hint'] as String?,
    );
  }
}

class DailyDevotional {
  final DateTime date;
  final String? title;
  final ScriptureReading reading;
  final List<ReflectionPrompt> prompts;
  final String? prayerFocus;

  const DailyDevotional({
    required this.date,
    this.title,
    required this.reading,
    this.prompts = const [],
    this.prayerFocus,
  });
}

class JournalEntry {
  final String id;
  final DateTime date;
  final String scriptureReference;
  String reflectionText;
  String prayerText;
  final List<String> tags;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.date,
    this.scriptureReference = '',
    this.reflectionText = '',
    this.prayerText = '',
    List<String>? tags,
    DateTime? createdAt,
  })  : tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'scriptureReference': scriptureReference,
        'reflectionText': reflectionText,
        'prayerText': prayerText,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
      };

  factory JournalEntry.fromMap(Map<dynamic, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      scriptureReference: map['scriptureReference'] as String? ?? '',
      reflectionText: map['reflectionText'] as String? ?? '',
      prayerText: map['prayerText'] as String? ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

class ReadingPlan {
  final String id;
  final String name;
  final String? description;
  final int totalDays;
  final List<ScriptureReading> readings;
  int currentDay;
  final DateTime startDate;

  ReadingPlan({
    required this.id,
    required this.name,
    this.description,
    required this.totalDays,
    required this.readings,
    this.currentDay = 0,
    DateTime? startDate,
  }) : startDate = startDate ?? DateTime.now();

  double get progress => totalDays > 0 ? currentDay / totalDays : 0;
  bool get isComplete => currentDay >= totalDays;
  ScriptureReading? get todayReading =>
      currentDay < readings.length ? readings[currentDay] : null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'totalDays': totalDays,
        'readings': readings.map((r) => r.toMap()).toList(),
        'currentDay': currentDay,
        'startDate': startDate.toIso8601String(),
      };

  factory ReadingPlan.fromMap(Map<dynamic, dynamic> map) {
    return ReadingPlan(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      totalDays: map['totalDays'] as int,
      readings: (map['readings'] as List)
          .map((r) => ScriptureReading.fromMap(r as Map<dynamic, dynamic>))
          .toList(),
      currentDay: map['currentDay'] as int? ?? 0,
      startDate: DateTime.parse(map['startDate'] as String),
    );
  }
}
