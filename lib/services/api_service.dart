import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goal_model.dart';

class ApiService {
  // Using the /posts endpoint because it supports full CRUD mock operations
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // GET: Fetch Goals
  Future<List<GoalModel>> fetchGoals() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?_limit=10'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => GoalModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load goals from server.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST: Create Goal
  Future<GoalModel> createGoal(GoalModel goal) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(goal.toJson()),
      );

      if (response.statusCode == 201) {
        return GoalModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create goal.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT: Update Goal
  Future<GoalModel> updateGoal(GoalModel goal) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${goal.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(goal.toJson()),
      );

      if (response.statusCode == 200) {
        return GoalModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update goal.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE: Delete Goal
  Future<void> deleteGoal(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete goal.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
