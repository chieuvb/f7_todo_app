class TaskItem {
  String id;
  String content;
  bool status;

  TaskItem({
    required this.id,
    required this.content,
    required this.status,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      content: json['content'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'status': status,
    };
  }
}
