class Lesson {
  final int id;
  final String title;
  final String link;
  final List<Caphter> capthers;

  Lesson({
    required this.id,
    required this.title,
    required this.link,
    required this.capthers,
  });

  factory Lesson.fromJSON(Map<String, dynamic> jsonMap) {
    Map<String, dynamic>? content = jsonMap['content'];

    List<Caphter> capthers = [];
    if (content != null) {
      capthers = content.keys.map((key) {
        return Caphter(
          id: int.parse(key.substring(key.lastIndexOf('_') + 1)),
          title: content[key]['title'],
          paragraph: content[key]['paragraph'],
        );
      }).toList();
    }

    return Lesson(
      id: jsonMap['_id'],
      title: jsonMap['title'],
      link: jsonMap['link'] ?? '',
      capthers: capthers,
    );
  }

  Map<String, dynamic> toJSON() => {
        'id': id,
        'title': title,
        'link': link,
        'capthers': capthers.map((c) => c.toJSON()).toList(),
      };
}

class Caphter {
  final int id;
  final String title;
  final String paragraph;

  Caphter({
    required this.id,
    required this.title,
    required this.paragraph,
  });

  factory Caphter.fromJSON(Map<String, dynamic> jsonMap) {
    return Caphter(
      id: jsonMap['id'],
      title: jsonMap['title'],
      paragraph: jsonMap['paragraph'] ?? '',
    );
  }

  Map<String, dynamic> toJSON() => {
        'id': id,
        'title': title,
        'paragraph': paragraph,
      };
}
