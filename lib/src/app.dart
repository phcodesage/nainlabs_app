import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings/settings_controller.dart';
import 'screens/sleep_tracking_screen.dart';
import 'screens/analytics_screen.dart';
import 'providers/sleep_provider.dart';
import 'services/sleep_tracking_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return ChangeNotifierProvider(
          create: (_) => SleepProvider(
            SleepTrackingService(snapshot.data!),
          ),
          child: AnimatedBuilder(
            animation: settingsController,
            builder: (BuildContext context, Widget? child) {
              return MaterialApp(
                theme: ThemeData(),
                darkTheme: ThemeData.dark(),
                themeMode: settingsController.themeMode,
                home: const HomePage(),
              );
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    SleepTrackingScreen(),
    AnalyticsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepProvider>().loadRecentSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bed),
            label: 'Sleep',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
