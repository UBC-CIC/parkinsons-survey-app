import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/patient_home_page.dart';
import 'package:parkinsons_app/start_study_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'reminder_channel',
            channelName: 'Survey Reminders',
            channelDescription: 'Notification channel for survey reminders',
            defaultColor: Color(0xFF427ac1),
            ledColor: Colors.white)
      ],
      debug: true);

  runApp(const ParkinsonsApp());
}

class ParkinsonsApp extends StatefulWidget {
  const ParkinsonsApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<ParkinsonsApp> createState() => _ParkinsonsAppState();
}

class _ParkinsonsAppState extends State<ParkinsonsApp> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ParkinsonsApp.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageRouter(),
    );
  }
}

class PageRouter extends StatefulWidget {
  const PageRouter({super.key});

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  @override
  void initState() {
    super.initState();
    checkTrialStatus();
  }

  Future<void> checkTrialStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? trialStarted = prefs.getBool('trial_in_progress');
    if (trialStarted == null || trialStarted == false) {
      if (context.mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const StudyStartPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );
      }
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const PatientHomePage(),
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [CircularProgressIndicator()],
        ),
      ),
    );
  }
}
