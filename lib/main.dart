import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/patient_home_page.dart';
import 'package:parkinsons_app/trial_start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [NotificationChannelGroup(channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')],
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
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Allow \"Parkinson\'s Sruvey App\" to send survey reminder notifications?'),
            content: const Text('Notifications will be sent periodically to notify users to complete surveys.'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                /// This parameter indicates the action would perform
                /// a destructive action such as deletion, and turns
                /// the action's text color to red.
                isDestructiveAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text('Deny'),
              ),
              CupertinoDialogAction(
                /// This parameter indicates this action is the default,
                /// and turns the action's text to bold text.
                isDefaultAction: true,
                onPressed: () async {
                  AwesomeNotifications().requestPermissionToSendNotifications();
                },
                child: const Text('Allow'),
              ),
            ],
          ),
        );
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
            pageBuilder: (_, __, ___) => const TrialStartPage(),
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
