import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:business_management_app/screens/login.dart';
import 'package:business_management_app/screens/boss_dashboard.dart';
import 'package:business_management_app/screens/ceo_dashboard.dart';
import 'package:business_management_app/screens/signup.dart';
import 'package:business_management_app/screens/profile_screen.dart';
import 'package:business_management_app/screens/company_details_screen.dart';
import 'package:business_management_app/screens/add_project_screen.dart';
import 'package:business_management_app/screens/initial_screen.dart';
import 'package:business_management_app/screens/ai_chat_screen.dart';
import 'package:business_management_app/screens/settings_screen.dart';
import 'package:business_management_app/screens/notifications_screen.dart';
import 'package:business_management_app/screens/admin_screen.dart';
import 'package:business_management_app/screens/project_feedback_screen.dart';
import 'package:business_management_app/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Management App',
      theme: appTheme(_isDarkTheme),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => InitialScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (context) => SignUpScreen());
          case '/boss_dashboard':
            return MaterialPageRoute(builder: (context) => BossDashboard(isDarkTheme: _isDarkTheme));
          case '/ceo_dashboard':
            return MaterialPageRoute(builder: (context) => CEODashboard(isDarkTheme: _isDarkTheme));
          case '/profile':
            return MaterialPageRoute(builder: (context) => ProfileScreen());
          case '/company_details':
            final companyId = settings.arguments as String?;
            if (companyId != null) {
              return MaterialPageRoute(
                builder: (context) => CompanyDetailsScreen(companyId: companyId),
              );
            }
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('Company ID not provided'),
                ),
              ),
            );
          case '/add_project':
            final arguments = settings.arguments as Map<String, dynamic>?;
            final companyId = arguments?['companyId'] as String?;
            final companyName = arguments?['companyName'] as String?;
            if (companyId != null && companyName != null) {
              return MaterialPageRoute(
                builder: (context) => AddProjectScreen(
                  companyId: companyId,
                  companyName: companyName,
                ),
              );
            }
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('Company ID or name not provided'),
                ),
              ),
            );
          case '/ai_chat':
            return MaterialPageRoute(builder: (context) => AIChatScreen(isDarkTheme: _isDarkTheme));
          case '/settings':
            return MaterialPageRoute(
              builder: (context) => SettingsScreen(onThemeChanged: _toggleTheme, isDarkTheme: _isDarkTheme),
            );
          case '/admin':
            return MaterialPageRoute(builder: (context) => AdminScreen());
          case '/project_feedbacks':
            final ceoId = settings.arguments as String?;
            if (ceoId != null) {
              return MaterialPageRoute(
                builder: (context) => ProjectFeedbackScreen(
                  ceoId: ceoId,
                  isDarkTheme: _isDarkTheme,
                ),
              );
            }
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('CEO ID not provided'),
                ),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}