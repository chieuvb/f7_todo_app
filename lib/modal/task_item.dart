class TaskItem {
  String id;
  String content;
  bool complete;

  TaskItem({
    required this.id,
    required this.content,
    required this.complete,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      content: json['content'],
      complete: json['complete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'complete': complete,
    };
  }
}
