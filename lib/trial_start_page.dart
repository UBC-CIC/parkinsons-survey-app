import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:localstorage/localstorage.dart';
import 'package:parkinsons_app/patient_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>['No Notifications', 'Every 30 min', 'Every Hour', 'Every 2 Hours', 'Every 3 Hours'];

class TrialStartPage extends StatefulWidget {
  const TrialStartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TrialStartPage> createState() => _TrialStartPageState();
}

class _TrialStartPageState extends State<TrialStartPage> {

  String dropdownValue = list[2];

  final userIDController = TextEditingController();
  final trialIDController = TextEditingController();
  final deviceIDController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userIDController.dispose();
    trialIDController.dispose();
    deviceIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0.05 * height, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 80,
                      )),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
                    child: Text(
                      'Parkinson\'s Symptom\nSurvey Tool',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'DMSans-Medium', fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    width: 340,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0.01 * height, 0, 10),
                        child: const Text(
                          'Study Setup',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontFamily: 'DMSans-Bold', fontSize: 22),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      child: TextField(
                        controller: userIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'User ID',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      child: TextField(
                        controller: trialIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'Trial ID',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      child: TextField(
                        controller: deviceIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'Device ID',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 340,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          'Notification Frequency',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontFamily: 'DMSans-Medium', fontSize: 18),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      height: 65,
                      child: InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        child: DropdownButtonHideUnderline(
                          child: SizedBox(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              elevation: 16,
                              style: const TextStyle(color: Color(0xff6a6a6a), fontSize: 18, fontFamily: 'DMSans-Regular'),
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          if (context.mounted) {
                            screenLockCreate(
                              context: context,
                              onConfirmed: (value) async {
                                await prefs.setString('passcode', value);
                                Navigator.pop(context);
                              }, // store new passcode somewhere here
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff0D85C9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              //border radius equal to or more than 50% of width
                            )),
                        child: const Text(
                          'Reset Passcode',
                          style: TextStyle(fontSize: 20, fontFamily: 'DMSans-Regular'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('trial_in_progress', true);
                          await prefs.setString('userID', userIDController.value.text);
                          await prefs.setString('trialID', trialIDController.value.text);
                          await prefs.setString('deviceID', deviceIDController.value.text);
                          await prefs.setString('notificationFrequency', dropdownValue);



                          String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

                          AwesomeNotifications().cancelAll();

                          int repeatInterval = 0;

                          if (dropdownValue == 'Every 30 min') {
                            repeatInterval = 60;
                          } else if (dropdownValue == 'Every Hour') {
                            repeatInterval = 3600;
                          } else if (dropdownValue == 'Every 2 Hours') {
                            repeatInterval = 7200;
                          } else if (dropdownValue == 'Every 3 Hours') {
                            repeatInterval = 10800;
                          } else {
                            repeatInterval = 0;
                          }

                          if(repeatInterval != 0) {
                            await AwesomeNotifications().createNotification(
                                content: NotificationContent(
                                    id: 10,
                                    channelKey: 'reminder_channel',
                                    title: 'Survey Reminder',
                                    body:
                                    'Please record your symptoms in the Parkinson\'s Survey App',
                                    notificationLayout: NotificationLayout.Default),
                                schedule: NotificationInterval(interval: repeatInterval, timeZone: localTimeZone, repeats: true));
                          }

                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const PatientHomePage(),
                                transitionDuration: const Duration(milliseconds: 100),
                                transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff07B9D5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              //border radius equal to or more than 50% of width
                            )),
                        child: const Text(
                          'Start Study',
                          style: TextStyle(fontSize: 20, fontFamily: 'DMSans-Regular'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
