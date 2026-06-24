import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _locationServices = true;
  String _language = 'English';

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.6),
      ),
    );
  }

  Widget _switchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
          Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
        ],
      ),
    );
  }

  Widget _navigationRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
              Text(value, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  void _pickLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final options = ['English', 'Bahasa Malaysia', 'Mandarin', 'Tamil'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((lang) => ListTile(
                      title: Text(lang),
                      trailing: lang == _language ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () => Navigator.pop(context, lang),
                    ))
                .toList(),
          ),
        );
      },
    );
    if (selected != null) setState(() => _language = selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _sectionLabel('Notifications'),
          _switchRow(
            icon: Icons.notifications_outlined,
            label: 'Push notifications',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          _sectionLabel('Appearance'),
          _switchRow(
            icon: Icons.dark_mode_outlined,
            label: 'Dark mode',
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          _sectionLabel('Privacy & location'),
          _switchRow(
            icon: Icons.location_on_outlined,
            label: 'Location services',
            value: _locationServices,
            onChanged: (val) => setState(() => _locationServices = val),
          ),
          const SizedBox(height: 4),
          _navigationRow(icon: Icons.lock_outline, label: 'Privacy policy', value: '', onTap: () {}),
          _sectionLabel('General'),
          _navigationRow(icon: Icons.language, label: 'Language', value: _language, onTap: _pickLanguage),
        ],
      ),
    );
  }
}