import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            tooltip: 'Books',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'My Books',
            onPressed: () => Navigator.pushReplacementNamed(context, '/user'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/settings'),
          ),
        ],
      ),
      body: Center(child: Text('Settings Content')),
    );
  }
}
