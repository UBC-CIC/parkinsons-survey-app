import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:parkinsons_app/patient_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>['No Notifications', 'Every 30 min', 'Every Hour', 'Every 2 Hours', 'Every 3 Hours'];

class StudyStartPage extends StatefulWidget {
  const StudyStartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StudyStartPage> createState() => _StudyStartPageState();
}

class _StudyStartPageState extends State<StudyStartPage> {

  String dropdownValue = list[2];

  final patientIDController = TextEditingController();
  final trialIDController = TextEditingController();
  final deviceIDController = TextEditingController();

  bool patientIDValid = true;
  bool trialIDValid = true;
  bool deviceIDValid = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    patientIDController.dispose();
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
                  const SizedBox(
                    width: 340,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                      child: Text(
                        'Parkinson\'s Symptom\nSurvey Tool',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontFamily: 'DMSans-Bold', fontSize: 30, color: Color(0xff4682B4),),
                      ),
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
                        onChanged: (String s){
                          if(patientIDController.value.text.isNotEmpty){
                            setState(() {
                              patientIDValid = true;
                            });
                          } else {
                            setState(() {
                              patientIDValid = false;
                            });
                          }
                        },
                        controller: patientIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'Patient ID',
                          errorText: patientIDValid? null : 'Please enter a value',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      child: TextField(
                        onChanged: (String s){
                          if(trialIDController.value.text.isNotEmpty){
                            setState(() {
                              trialIDValid = true;
                            });
                          } else {
                            setState(() {
                              trialIDValid = false;
                            });
                          }
                        },
                        controller: trialIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'Trial ID',
                          errorText: trialIDValid? null : 'Please enter a value',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 340,
                      child: TextField(
                        onChanged: (String s){
                          if(deviceIDController.value.text.isNotEmpty){
                            setState(() {
                              deviceIDValid = true;
                            });
                          } else {
                            setState(() {
                              deviceIDValid = false;
                            });
                          }
                        },
                        controller: deviceIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'Wearable Device ID',
                          errorText: deviceIDValid? null : 'Please enter a value',
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
                          if(patientIDController.text.isEmpty || trialIDController.text.isEmpty || deviceIDController.text.isEmpty) {
                            if(patientIDController.text.isEmpty) {
                              setState(() {
                                patientIDValid = false;
                              });
                            }
                            if(trialIDController.text.isEmpty) {
                              setState(() {
                                trialIDValid = false;
                              });
                            }
                            if(deviceIDController.text.isEmpty) {
                              setState(() {
                                deviceIDValid = false;
                              });
                            }

                          } else {

                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('trial_in_progress', true);
                          await prefs.setString('userID', patientIDController.value.text);
                          await prefs.setString('trialID', trialIDController.value.text);
                          await prefs.setString('deviceID', deviceIDController.value.text);
                          await prefs.setString('notificationFrequency', dropdownValue);



                          String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

                          AwesomeNotifications().cancelAll();

                          int repeatInterval = 0;

                          if (dropdownValue == 'Every 30 min') {
                            repeatInterval = 1800;
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
                        }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff4682B4),
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
