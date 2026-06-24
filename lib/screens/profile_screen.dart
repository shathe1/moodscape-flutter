import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import '../services/firestore_service.dart';
import '../services/user_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _nameController = TextEditingController();
  final _handleController = TextEditingController();
  int _moodsLogged = 0;
  int _savedPlaces = 0;
  int _moodStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = UserSession.userId;
    if (userId == null) return;
    final data = await FirestoreService.getUser(userId);
    if (data == null || !mounted) return;
    setState(() {
      _nameController.text = data['name'] ?? '';
      _handleController.text = data['handle'] ?? '';
      _moodsLogged = data['moodsLogged'] ?? 0;
      _savedPlaces = data['savedPlaces'] ?? 0;
      _moodStreak = data['moodStreak'] ?? 0;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    super.dispose();
  }

  Widget _settingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent, Color(0xFF5FD6B4)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.35),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.7),
                        width: 3,
                      ),
                    ),
                    child: const Text(
                      'S',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A7A56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isEditing
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        )
                      : Text(
                          _nameController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                  const SizedBox(height: 2),
                  Text(
                    _handleController.text,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ProfileStat(
                        value: '$_moodsLogged',
                        label: 'Moods logged',
                      ),
                      SizedBox(width: 24),
                      _ProfileStat(
                        value: '$_savedPlaces',
                        label: 'Saved places',
                      ),
                      SizedBox(width: 24),
                      _ProfileStat(value: '$_moodStreak', label: 'Mood streak'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (_isEditing) {
                      final userId = UserSession.userId;
                      if (userId != null) {
                        await FirestoreService.updateUser(
                          userId,
                          _nameController.text.trim(),
                          _handleController.text.trim(),
                        );
                        UserSession.userName = _nameController.text.trim();
                      }
                    }
                    setState(() => _isEditing = !_isEditing);
                  },
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit_outlined,
                    size: 16,
                  ),
                  label: Text(_isEditing ? 'Save changes' : 'Edit profile'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                    side: const BorderSide(color: AppColors.borderMedium),
                    foregroundColor: AppColors.textDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  _settingsRow(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                  _settingsRow(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpScreen()),
                    ),
                  ),
                  _settingsRow(
                    icon: Icons.logout,
                    label: 'Log out',
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ],
    );
  }
}
