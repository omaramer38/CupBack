import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/state/app_state.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/cafe_portal/cafe_dashboard_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CupBackRoot());
}

class CupBackRoot extends StatefulWidget {
  const CupBackRoot({super.key});

  @override
  State<CupBackRoot> createState() => _CupBackRootState();
}

class _CupBackRootState extends State<CupBackRoot> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: const CupBackApp(),
    );
  }
}

class CupBackApp extends StatelessWidget {
  const CupBackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return MaterialApp(
      title: 'CupBack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: appState.locale,
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _resolveHomeScreen(appState),
    );
  }

  Widget _resolveHomeScreen(AppState appState) {
    if (!appState.isLoggedIn) {
      return const OnboardingScreen();
    }

    if (appState.isBusiness) {
      return const CafeDashboardScreen();
    }

    // Default active customer flow
    return const MainNavigationScreen();
  }
}
