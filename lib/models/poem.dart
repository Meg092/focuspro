class Poem {
  final int id;
  final String title;
  final String author;
  final int year;
  final List<String> lines;
  
  Poem({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.lines,
  });
  
  String get content => lines.join('\n');
  
  String get preview => lines.take(2).join('\n');
  
  List<String> get words {
    final allWords = <String>[];
    for (var line in lines) {
      final words = line.split(' ');
      allWords.addAll(words);
    }
    return allWords;
  }
  
}
