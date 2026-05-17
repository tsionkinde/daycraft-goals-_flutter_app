import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../services/api_service.dart';

class GoalProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<GoalModel> _goals = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // READ Operation
  Future<void> loadGoals() async {
    _setLoading(true);
    _clearError();
    try {
      _goals = await _apiService.fetchGoals();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  // CREATE Operation
  Future<bool> addGoal(String title, String description) async {
    _setLoading(true);
    try {
      final newGoal = GoalModel(title: title, description: description);
      final createdGoal = await _apiService.createGoal(newGoal);

      // JSONPlaceholder always returns id: 101 for creations.
      // We generate a local timestamp ID to prevent UI collisions.
      final uniqueGoal = createdGoal.copyWith(
        id: DateTime.now().millisecondsSinceEpoch,
      );

      _goals.insert(0, uniqueGoal);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // UPDATE Operation
  Future<bool> updateGoal(GoalModel updatedGoal) async {
    _setLoading(true);
    try {
      // Mock API sync
      await _apiService.updateGoal(updatedGoal);

      int index = _goals.indexWhere((g) => g.id == updatedGoal.id);
      if (index != -1) {
        _goals[index] = updatedGoal;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // TOGGLE STATUS Operation (Shortcut Update)
  Future<void> toggleGoalStatus(GoalModel goal) async {
    final updatedGoal = goal.copyWith(isCompleted: !goal.isCompleted);
    // Optimistic UI updates
    int index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = updatedGoal;
      notifyListeners();
    }

    try {
      await _apiService.updateGoal(updatedGoal);
    } catch (e) {
      // Revert if network fails completely
      int index = _goals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _goals[index] = goal;
        notifyListeners();
      }
    }
  }

  // DELETE Operation
  Future<bool> removeGoal(int id) async {
    _setLoading(true);
    try {
      await _apiService.deleteGoal(id);
      _goals.removeWhere((g) => g.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }
}
