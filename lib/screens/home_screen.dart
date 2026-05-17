import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/goal_provider.dart';
import '../widgets/goal_card.dart';
import 'add_edit_goal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch goals on system initialization
    Future.delayed(Duration.zero, () {
      context.read<GoalProvider>().loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Goal Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GoalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.goals.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          if (provider.errorMessage.isNotEmpty && provider.goals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(provider.errorMessage, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.loadGoals(),
                      child: const Text('Retry Connection'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.goals.isEmpty) {
            return const Center(
              child: Text('No goals added for today yet. set some!'),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => provider.loadGoals(),
                child: ListView.builder(
                  itemCount: provider.goals.length,
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemBuilder: (context, index) {
                    return GoalCard(goal: provider.goals[index]);
                  },
                ),
              ),
              if (provider.isLoading)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(color: Colors.amber),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEditGoalScreen()));
        },
      ),
    );
  }
}
