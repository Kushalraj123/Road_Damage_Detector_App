import 'package:flutter/material.dart';
import 'package:routefixer/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _locationServices = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader("Notifications"),
          SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: const Text("Receive alerts about road hazards and report updates"),
            value: _pushNotifications,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _pushNotifications = val);
            },
          ),
          const Divider(),
          _buildSectionHeader("Preferences"),
          SwitchListTile(
            title: const Text("Dark Theme"),
            subtitle: const Text("Switch to a darker interface color palette"),
            value: _darkMode,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _darkMode = val);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Dark mode toggled! (Visual demo only)"),
                  duration: Duration(milliseconds: 1500),
                ),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader("Permissions"),
          SwitchListTile(
            title: const Text("Location Services"),
            subtitle: const Text("Enable GPS tracking to report exact damage coordinates"),
            value: _locationServices,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _locationServices = val);
            },
          ),
          const Divider(),
          _buildSectionHeader("App Info"),
          ListTile(
            title: const Text("Version"),
            trailing: Text("1.0.0 (Build 1)", style: TextStyle(color: Colors.grey.shade600)),
          ),
          ListTile(
            title: const Text("Terms & Conditions"),
            onTap: () {
              _showInfoDialog("Terms & Conditions", "By using RouteFixer, you agree to report accurate road hazards and share your GPS location for mapping verification. Do not operate the app while operating a vehicle.");
            },
          ),
          ListTile(
            title: const Text("Privacy Policy"),
            onTap: () {
              _showInfoDialog("Privacy Policy", "We collect your email, name, and GPS coordinates solely to verify road damage reports. We do not sell or share personal information with third-party advertisers.");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
