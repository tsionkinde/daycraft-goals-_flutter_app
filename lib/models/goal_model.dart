class GoalModel {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  GoalModel({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  // Convert JSON from API to GoalModel
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as int?,
      // Using 'title' and 'body' to align seamlessly with JSONPlaceholder's structure
      title: json['title'] ?? '',
      description: json['body'] ?? '',
      isCompleted: json['completed'] ?? false,
    );
  }

  // Convert GoalModel to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': description,
      'userId': 1, // Required by JSONPlaceholder
    };
  }

  // Helper method to clone/update an existing goal object
  GoalModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return GoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
