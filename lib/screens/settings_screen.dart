import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/calorie_provider.dart';
import '../providers/auth_provider.dart' as auth;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _calorieGoalController = TextEditingController();

  @override
  void dispose() {
    _calorieGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<CalorieProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Daily calorie goal section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Calorie Goal',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Current Goal: ${provider.dailyCalorieGoal} cal',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _showEditGoalDialog(provider),
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set your daily calorie target to track your progress',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Data retention section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Retention',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Keep data for: ${provider.dataRetentionDays} days',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: provider.dataRetentionDays.toDouble(),
                        min: 30,
                        max: 365,
                        divisions: 11,
                        label: '${provider.dataRetentionDays} days',
                        onChanged: (value) {
                          provider.setDataRetentionDays(value.toInt());
                        },
                      ),
                      Text(
                        'Data older than ${provider.dataRetentionDays} days will be automatically deleted',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quick goal presets
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Goal Presets',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildGoalPresetChip('Weight Loss (1500 cal)', 1500, provider),
                          _buildGoalPresetChip('Maintain (2000 cal)', 2000, provider),
                          _buildGoalPresetChip('Muscle Gain (2500 cal)', 2500, provider),
                          _buildGoalPresetChip('Athletic (3000 cal)', 3000, provider),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Account section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          final user = snapshot.data;
                          final email = user?.email;
                          final isAnonymous = user?.isAnonymous ?? true;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (email != null && !isAnonymous) ...[
                                Row(
                                  children: [
                                    const Icon(Icons.email, size: 20),
                                    const SizedBox(width: 8),
                                    Text(email),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final authProvider = context.read<auth.UserAuthProvider>();
                                    await authProvider.signOut();
                                  },
                                  icon: const Icon(Icons.logout),
                                  label: const Text('Sign Out'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // About section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Calorie Tracker v0.1.0',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track your daily calorie intake and reach your health goals',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Clear all data button
              OutlinedButton(
                onPressed: () => _showClearDataDialog(provider),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Clear All Data'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGoalPresetChip(String label, int calories, CalorieProvider provider) {
    final isSelected = provider.dailyCalorieGoal == calories;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          provider.setDailyCalorieGoal(calories);
        }
      },
    );
  }

  Future<void> _showEditGoalDialog(CalorieProvider provider) async {
    _calorieGoalController.text = provider.dailyCalorieGoal.toString();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Daily Goal'),
        content: TextField(
          controller: _calorieGoalController,
          decoration: const InputDecoration(
            labelText: 'Calories',
            suffixText: 'cal',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final goal = int.tryParse(_calorieGoalController.text);
              if (goal != null && goal > 0) {
                provider.setDailyCalorieGoal(goal);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDataDialog(CalorieProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your food entries. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Delete all entries
      for (final entry in provider.allEntries) {
        if (entry.id != null) {
          await provider.deleteFoodEntry(entry.id!);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
