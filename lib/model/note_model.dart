class Note {
  final int? id;
  final String? title;
  final String? body;
  DateTime? created = DateTime.now();
  DateTime? edited = DateTime.now();

  Note({
    this.id,
    this.title,
    this.body,
    this.created,
    this.edited,
  });

  static Note fromMap(Map<String, dynamic> map) => Note(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        created: DateTime.parse(map['created']),
        edited: DateTime.parse(map['edited']),
      );

  Map<String, dynamic> asMap() => {
        'id': id,
        'title': title,
        'body': body,
        'created': created.toString(),
        'edited': edited.toString()
      };
}
