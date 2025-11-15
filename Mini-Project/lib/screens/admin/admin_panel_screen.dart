import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/admin_service.dart';
import '../../providers/app_state.dart';
import 'package:provider/provider.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _searchController = TextEditingController();
  Map<String, dynamic>? _searchedUser;
  bool _searching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUser() async {
    final email = _searchController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _searching = true;
      _searchedUser = null;
    });

    final user = await AdminService.searchUserByEmail(email);
    setState(() {
      _searchedUser = user;
      _searching = false;
    });

    if (user == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found")),
      );
    }
  }

  Future<void> _togglePremium(String uid, bool currentPremium) async {
    final success = await AdminService.toggleUserPremium(uid, !currentPremium);
    if (success && mounted) {
      setState(() {
        if (_searchedUser != null) {
          _searchedUser!['premium'] = !currentPremium;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Premium status updated to ${!currentPremium}",
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update premium status")),
      );
    }
  }

  Future<void> _toggleFeatureFlag(String flag, bool currentValue) async {
    final success = await AdminService.updateFeatureFlag(flag, !currentValue);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Feature flag $flag updated to ${!currentValue}"),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update feature flag"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await app.logout();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            tooltip: "Logout",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search User Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Search User by Email",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Enter user email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onSubmitted: (_) => _searchUser(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _searching ? null : _searchUser,
                          child: _searching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Search"),
                        ),
                      ],
                    ),
                    if (_searchedUser != null) ...[
                      const SizedBox(height: 16),
                      Divider(color: colors.outline),
                      const SizedBox(height: 16),
                      _buildUserInfo(_searchedUser!, colors),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Feature Flags Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: colors.primary),
                        const SizedBox(width: 8),
                        Text(
                          "Feature Flags",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<Map<String, dynamic>>(
                      stream: AdminService.getFeatureFlagsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading feature flags: ${snapshot.error}',
                              style: TextStyle(color: colors.error),
                            ),
                          );
                        }

                        final featureFlags = snapshot.data ?? {'newUI': false};

                        if (featureFlags.isEmpty) {
                          return const Center(
                            child: Text("No feature flags configured"),
                          );
                        }

                        return Column(
                          children: featureFlags.entries.map((entry) {
                            final flagName = entry.key;
                            final flagValue = entry.value as bool? ?? false;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: SwitchListTile(
                                title: Text(
                                  flagName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  flagValue ? "Enabled" : "Disabled",
                                  style: TextStyle(
                                    color: flagValue ? Colors.green : colors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: flagValue,
                                onChanged: (value) {
                                  _toggleFeatureFlag(flagName, flagValue);
                                },
                                secondary: Icon(
                                  flagValue ? Icons.check_circle : Icons.cancel,
                                  color: flagValue ? Colors.green : colors.onSurfaceVariant,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Audit Log Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Audit Logs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 400,
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: AdminService.getAuditLogs(limit: 50),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, 
                                      color: colors.error, size: 48),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Error loading audit logs',
                                    style: TextStyle(color: colors.error),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${snapshot.error}',
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Note: You may need to create an index in Firestore\nfor the audit_logs collection on the "timestamp" field',
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history, 
                                      color: colors.onSurfaceVariant, size: 48),
                                  const SizedBox(height: 8),
                                  Text(
                                    "No audit logs yet",
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final logs = snapshot.data!;
                          return ListView.builder(
                            itemCount: logs.length,
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              final timestamp = log['timestamp'] as Timestamp?;
                              final actorUid = log['actorUid'] ?? 'Unknown';
                              final target = log['target'] ?? '';
                              final action = log['action'] ?? 'Unknown';
                              
                              // Get action icon
                              IconData actionIcon = Icons.history;
                              Color actionColor = colors.primary;
                              if (action.contains('premium')) {
                                actionIcon = Icons.workspace_premium;
                                actionColor = Colors.amber;
                              } else if (action.contains('feature')) {
                                actionIcon = Icons.flag;
                                actionColor = Colors.blue;
                              } else if (action.contains('login')) {
                                actionIcon = Icons.login;
                                actionColor = Colors.green;
                              }
                              
                              return Card(
                                margin: const EdgeInsets.only(bottom: 4),
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(actionIcon, color: actionColor),
                                  title: Text(
                                    action,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (target.isNotEmpty) ...[
                                        Text(
                                          'Target: $target',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                      ],
                                      Text(
                                        'Actor: ${actorUid.substring(0, 8)}...',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                      if (timestamp != null)
                                        Text(
                                          _formatTimestamp(timestamp),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: colors.onSurfaceVariant,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> user, ColorScheme colors) {
    final premium = user['premium'] ?? false;
    final email = user['email'] ?? 'N/A';
    final name = user['name'] ?? 'N/A';
    final uid = user['uid'] ?? '';
    final targetLanguage = user['targetLanguageCode'] ?? user['targetLanguage'] ?? 'Not set';
    final streak = user['streak'] ?? 0;
    final totalQuestions = user['totalQuestions'] ?? 0;
    final totalChallenges = user['totalChallenges'] ?? 0;

    // Language code to name mapping
    String getLanguageName(String code) {
      const languageMap = {
        'es': 'Spanish',
        'fr': 'French',
        'de': 'German',
        'it': 'Italian',
        'pt': 'Portuguese',
        'ru': 'Russian',
        'ja': 'Japanese',
        'ko': 'Korean',
        'zh': 'Chinese',
        'ar': 'Arabic',
        'hi': 'Hindi',
        'nl': 'Dutch',
        'sv': 'Swedish',
        'pl': 'Polish',
        'tr': 'Turkish',
      };
      return languageMap[code.toLowerCase()] ?? code.toUpperCase();
    }

    return Card(
      color: colors.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: colors.primary, size: 28),
                const SizedBox(width: 8),
                Text(
                  "User Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Name
            _buildInfoRow(
              icon: Icons.badge,
              label: "Name",
              value: name,
              colors: colors,
            ),
            const SizedBox(height: 12),
            
            // Email
            _buildInfoRow(
              icon: Icons.email,
              label: "Email",
              value: email,
              colors: colors,
            ),
            const SizedBox(height: 12),
            
            // Target Language
            _buildInfoRow(
              icon: Icons.translate,
              label: "Learning Language",
              value: targetLanguage != 'Not set' 
                  ? getLanguageName(targetLanguage) 
                  : 'Not set',
              colors: colors,
            ),
            const SizedBox(height: 12),
            
            // Premium Status
            Row(
              children: [
                Icon(Icons.workspace_premium, 
                    color: premium ? Colors.amber : colors.onSurfaceVariant, 
                    size: 20),
                const SizedBox(width: 8),
                Text(
                  "Premium Status: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: premium ? Colors.amber.withOpacity(0.2) : colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    premium ? "Premium User" : "Free User",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: premium ? Colors.amber.shade900 : colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Streak
            _buildInfoRow(
              icon: Icons.local_fire_department,
              label: "Current Streak",
              value: "$streak days",
              colors: colors,
              valueColor: streak > 0 ? Colors.orange : null,
            ),
            const SizedBox(height: 12),
            
            // Additional Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.quiz,
                    label: "Questions",
                    value: totalQuestions.toString(),
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.emoji_events,
                    label: "Challenges",
                    value: totalChallenges.toString(),
                    colors: colors,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            Divider(color: colors.outline),
            const SizedBox(height: 12),
            
            // Premium Toggle Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _togglePremium(uid, premium),
                icon: Icon(premium ? Icons.remove_circle : Icons.add_circle),
                label: Text(premium ? "Remove Premium" : "Grant Premium"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: premium ? colors.error : colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colors,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.primary, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}

