import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../tasks/history.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  bool isEditingName = false;

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? "User";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.purple.shade200,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildEditableNameCard(),
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.email,
                  label: "Email",
                  value: user?.email ?? "Email",
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.history,
                  label: "Task History",
                  onTap: () {
                    Navigator.pushNamed(context, '/history');
                  },
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.lock,
                  label: "Change Password",
                  onTap: _showChangePasswordDialog,
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.logout,
                  label: "Log Out",
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableNameCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.person, color: Colors.deepPurple.shade700),
          const SizedBox(width: 16),
          Expanded(
            child:
                isEditingName
                    ? TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Edit Name',
                        isDense: true,
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          nameController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
          ),
          IconButton(
            icon: Icon(
              isEditingName ? Icons.check : Icons.edit,
              color: Colors.deepPurple,
            ),
            onPressed: () async {
              if (isEditingName) {
                await user?.updateDisplayName(nameController.text.trim());
                await user?.reload();
                setState(() {});
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Name updated")));
              }
              setState(() => isEditingName = !isEditingName);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      tileColor: Colors.deepPurple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool showCurrent = false;
    bool showNew = false;
    bool showConfirm = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Change Password"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: currentPasswordController,
                      obscureText: !showCurrent,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            showCurrent
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(() => showCurrent = !showCurrent),
                        ),
                      ),
                    ),
                    TextField(
                      controller: newPasswordController,
                      obscureText: !showNew,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            showNew ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => showNew = !showNew),
                        ),
                      ),
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: !showConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(() => showConfirm = !showConfirm),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text("Change"),
                  onPressed: () async {
                    if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    try {
                      final cred = EmailAuthProvider.credential(
                        email: user!.email!,
                        password: currentPasswordController.text,
                      );
                      await user!.reauthenticateWithCredential(cred);
                      await user!.updatePassword(newPasswordController.text);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password changed")),
                      );
                    } catch (e) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
