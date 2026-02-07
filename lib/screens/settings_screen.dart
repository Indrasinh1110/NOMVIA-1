import 'package:flutter/material.dart';
import '../app/app_router.dart';
import '../state/app_state.dart';
import '../enums/auth_state.dart';
import '../enums/privacy_mode.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy Mode'),
            subtitle: Text(
              appState.privacyMode == PrivacyMode.on ? 'On' : 'Off',
            ),
            trailing: Switch(
              value: appState.privacyMode == PrivacyMode.on,
              onChanged: (value) {
                appState.updatePrivacyMode(
                  value ? PrivacyMode.on : PrivacyMode.off,
                );
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(AppRouter.settings);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('KYC Status'),
            subtitle: Text(
              appState.isKycCompleted ? 'Completed' : 'Not Completed',
            ),
            trailing: appState.isKycCompleted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (!appState.isKycCompleted) {
                Navigator.of(context).pushNamed(AppRouter.kyc);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About NOMVIA'),
                  content: const Text('Version 1.0.0\nTravel with people you trust'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        appState.authState = AuthState.loggedOut;
                        appState.currentUser = null;
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacementNamed(AppRouter.login);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
