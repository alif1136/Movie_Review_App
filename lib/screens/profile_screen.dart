import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: Colors.white, size: 52),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Movie Lover',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'cinephiler@movies.com',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.bookmark_rounded,
                      label: 'Watchlist',
                      value: provider.watchlist.length.toString(),
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      icon: Icons.check_circle_rounded,
                      label: 'Watched',
                      value: provider.watched.length.toString(),
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      icon: Icons.star_rounded,
                      label: 'Reviews',
                      value: '0',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingItem(Icons.notifications_outlined, 'Notifications'),
                _buildSettingItem(Icons.language_outlined, 'Language'),
                _buildSettingItem(Icons.dark_mode_outlined, 'Appearance'),
                _buildSettingItem(Icons.info_outline_rounded, 'About'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary, size: 26),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.textSecondary),
        title: Text(label,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            color: AppTheme.textSecondary, size: 16),
        onTap: () {},
      ),
    );
  }
}
