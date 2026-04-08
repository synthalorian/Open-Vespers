import '../models/devotional.dart';

/// Generates daily devotional content from an embedded scripture library.
/// Rotates through passages based on the day of the year.
class DevotionalEngine {
  static DailyDevotional getForDate(DateTime date) {
    final dayOfYear = _dayOfYear(date);
    final index = dayOfYear % _devotionals.length;
    final entry = _devotionals[index];

    return DailyDevotional(
      date: date,
      title: entry.title,
      reading: entry.reading,
      prompts: entry.prompts,
      prayerFocus: entry.prayerFocus,
    );
  }

  static DailyDevotional getToday() => getForDate(DateTime.now());

  static int _dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays;
  }

  static ReadingPlan get psalmsPlan => ReadingPlan(
        id: 'psalms-30',
        name: 'Psalms in 30 Days',
        description: 'Journey through the Psalms — five psalms per day',
        totalDays: 30,
        readings: List.generate(30, (i) {
          final start = i * 5 + 1;
          final end = start + 4;
          return ScriptureReading(
            reference: 'Psalms $start–$end',
            text: 'Read Psalms $start through $end today.',
          );
        }),
      );

  static ReadingPlan get proverbs31Plan => ReadingPlan(
        id: 'proverbs-31',
        name: 'Proverbs in 31 Days',
        description: 'One chapter of Proverbs each day',
        totalDays: 31,
        readings: List.generate(31, (i) {
          return ScriptureReading(
            reference: 'Proverbs ${i + 1}',
            text: 'Read Proverbs chapter ${i + 1} today.',
          );
        }),
      );

  static ReadingPlan get gospelsPlan => ReadingPlan(
        id: 'gospels-28',
        name: 'Gospels in 28 Days',
        description: 'Walk with Jesus through the four Gospels',
        totalDays: 28,
        readings: [
          ..._gospelReadings('Matthew', 28, 7),
          ..._gospelReadings('Mark', 16, 7),
          ..._gospelReadings('Luke', 24, 7),
          ..._gospelReadings('John', 21, 7),
        ],
      );

  static List<ScriptureReading> _gospelReadings(
      String book, int chapters, int days) {
    final perDay = (chapters / days).ceil();
    return List.generate(days, (i) {
      final start = i * perDay + 1;
      final end = ((i + 1) * perDay).clamp(1, chapters);
      return ScriptureReading(
        reference: start == end ? '$book $start' : '$book $start–$end',
        text: 'Read $book chapters $start through $end.',
      );
    });
  }

  static List<ReadingPlan> get availablePlans =>
      [psalmsPlan, proverbs31Plan, gospelsPlan];
}

class _DevotionalEntry {
  final String? title;
  final ScriptureReading reading;
  final List<ReflectionPrompt> prompts;
  final String? prayerFocus;

  const _DevotionalEntry({
    this.title,
    required this.reading,
    this.prompts = const [],
    this.prayerFocus,
  });
}

const _devotionals = [
  _DevotionalEntry(
    title: 'The Light Within',
    reading: ScriptureReading(
      reference: 'Psalm 119:105',
      text: 'Your word is a lamp for my feet\n    and a light on my path.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'Where do you need God\'s guidance today?',
        hint: 'Think about a decision or situation you\'re facing.',
      ),
      ReflectionPrompt(
        question: 'How has Scripture illuminated your path in the past?',
      ),
    ],
    prayerFocus: 'Wisdom and direction',
  ),
  _DevotionalEntry(
    title: 'Strength in Weakness',
    reading: ScriptureReading(
      reference: '2 Corinthians 12:9–10',
      text:
          'But he said to me, "My grace is sufficient for you, for my power is perfected in weakness." Therefore, I will most gladly boast all the more about my weaknesses, so that Christ\'s power may reside in me.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'Where are you feeling weak or insufficient right now?',
      ),
      ReflectionPrompt(
        question: 'How might God be using that weakness for His purposes?',
        hint: 'Consider times when struggle led to growth.',
      ),
    ],
    prayerFocus: 'Surrendering weakness to God\'s strength',
  ),
  _DevotionalEntry(
    title: 'Be Still',
    reading: ScriptureReading(
      reference: 'Psalm 46:10',
      text: 'Stop fighting, and know that I am God,\n    exalted among the nations, exalted on the earth.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What are you trying to control that you need to release?',
      ),
      ReflectionPrompt(
        question: 'What does stillness before God look like in your life today?',
      ),
    ],
    prayerFocus: 'Rest and trust',
  ),
  _DevotionalEntry(
    title: 'New Every Morning',
    reading: ScriptureReading(
      reference: 'Lamentations 3:22–23',
      text:
          'Because of the LORD\'s faithful love\n    we do not perish,\nfor his mercies never end.\nThey are new every morning;\n    great is your faithfulness!',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What mercy do you need to receive from God today?',
      ),
      ReflectionPrompt(
        question: 'Where have you seen God\'s faithfulness recently?',
        hint: 'Even small blessings count.',
      ),
    ],
    prayerFocus: 'Gratitude for God\'s faithfulness',
  ),
  _DevotionalEntry(
    title: 'The Good Shepherd',
    reading: ScriptureReading(
      reference: 'Psalm 23:1–4',
      text:
          'The LORD is my shepherd;\n    I have what I need.\nHe lets me lie down in green pastures;\n    he leads me beside quiet waters.\nHe renews my life;\n    he leads me along the right paths\n    for his name\'s sake.\nEven when I go through the darkest valley,\n    I fear no danger,\n    for you are with me.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'In what areas of life do you need to trust the Shepherd\'s leading?',
      ),
      ReflectionPrompt(
        question: 'What "dark valley" are you walking through, and how is God present in it?',
      ),
    ],
    prayerFocus: 'Trust in God\'s provision and presence',
  ),
  _DevotionalEntry(
    title: 'Love One Another',
    reading: ScriptureReading(
      reference: 'John 13:34–35',
      text:
          '"I give you a new command: Love one another. Just as I have loved you, you are also to love one another. By this everyone will know that you are my disciples, if you love one another."',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'Who in your life needs to see the love of Christ through you today?',
      ),
      ReflectionPrompt(
        question: 'What does sacrificial love look like in practical terms this week?',
      ),
    ],
    prayerFocus: 'Loving others as Christ loves us',
  ),
  _DevotionalEntry(
    title: 'Do Not Be Anxious',
    reading: ScriptureReading(
      reference: 'Philippians 4:6–7',
      text:
          'Don\'t worry about anything, but in everything, through prayer and petition with thanksgiving, present your requests to God. And the peace of God, which surpasses all understanding, will guard your hearts and minds in Christ Jesus.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What anxiety are you carrying that you need to bring to God in prayer?',
      ),
      ReflectionPrompt(
        question: 'How can thanksgiving shift your perspective on what worries you?',
        hint: 'Try listing three things you\'re grateful for right now.',
      ),
    ],
    prayerFocus: 'Peace that surpasses understanding',
  ),
  _DevotionalEntry(
    title: 'Walking by Faith',
    reading: ScriptureReading(
      reference: 'Hebrews 11:1',
      text: 'Now faith is the reality of what is hoped for, the proof of what is not seen.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What are you hoping for that requires faith right now?',
      ),
      ReflectionPrompt(
        question: 'When has God proven faithful in ways you couldn\'t see at the time?',
      ),
    ],
    prayerFocus: 'Deepening faith and trust',
  ),
  _DevotionalEntry(
    title: 'Created for Good Works',
    reading: ScriptureReading(
      reference: 'Ephesians 2:10',
      text:
          'For we are his workmanship, created in Christ Jesus for good works, which God prepared ahead of time for us to do.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What good work might God be preparing you for right now?',
      ),
      ReflectionPrompt(
        question: 'How does knowing you are God\'s "workmanship" change how you see yourself?',
      ),
    ],
    prayerFocus: 'Purpose and calling',
  ),
  _DevotionalEntry(
    title: 'The Armor of God',
    reading: ScriptureReading(
      reference: 'Ephesians 6:10–11',
      text:
          'Finally, be strengthened by the Lord and by his vast strength. Put on the full armor of God so that you can stand against the schemes of the devil.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'Where are you facing spiritual opposition in your life?',
      ),
      ReflectionPrompt(
        question: 'Which piece of the armor of God do you need most today?',
        hint: 'Belt of truth, breastplate of righteousness, gospel of peace, shield of faith, helmet of salvation, sword of the Spirit.',
      ),
    ],
    prayerFocus: 'Spiritual strength and protection',
  ),
  _DevotionalEntry(
    title: 'Abide in the Vine',
    reading: ScriptureReading(
      reference: 'John 15:4–5',
      text:
          '"Remain in me, and I in you. Just as a branch is unable to produce fruit by itself unless it remains on the vine, neither can you unless you remain in me. I am the vine; you are the branches. The one who remains in me and I in him produces much fruit, because you can do nothing without me."',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What does "remaining" in Christ look like in your daily routine?',
      ),
      ReflectionPrompt(
        question: 'What fruit has grown from your connection with Jesus?',
      ),
    ],
    prayerFocus: 'Abiding in Christ\'s presence',
  ),
  _DevotionalEntry(
    title: 'Compassion and Forgiveness',
    reading: ScriptureReading(
      reference: 'Colossians 3:12–13',
      text:
          'Therefore, as God\'s chosen ones, holy and dearly loved, put on compassion, kindness, humility, gentleness, and patience, bearing with one another and forgiving one another if anyone has a grievance against another. Just as the Lord has forgiven you, so you are also to forgive.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'Is there someone you need to forgive, or ask forgiveness from?',
      ),
      ReflectionPrompt(
        question: 'Which of these qualities — compassion, kindness, humility, gentleness, patience — is hardest for you right now?',
      ),
    ],
    prayerFocus: 'A forgiving and compassionate heart',
  ),
  _DevotionalEntry(
    title: 'Seek First',
    reading: ScriptureReading(
      reference: 'Matthew 6:33',
      text:
          '"But seek first the kingdom of God and his righteousness, and all these things will be provided for you."',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What are you prioritizing over God\'s kingdom in your life?',
      ),
      ReflectionPrompt(
        question: 'What would change if you truly sought God first today?',
      ),
    ],
    prayerFocus: 'Right priorities and surrender',
  ),
  _DevotionalEntry(
    title: 'The Lord Fights for You',
    reading: ScriptureReading(
      reference: 'Exodus 14:14',
      text: 'The LORD will fight for you, and you must be quiet.',
    ),
    prompts: [
      ReflectionPrompt(
        question: 'What battle are you fighting in your own strength?',
      ),
      ReflectionPrompt(
        question: 'What would it look like to be "quiet" and let God work?',
      ),
    ],
    prayerFocus: 'Letting go and letting God fight',
  ),
];
