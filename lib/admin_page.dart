import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'backend_configuration.dart';
import 'package:uuid/uuid.dart';


const List<String> list = <String>['No Notifications', 'Every 30 min', 'Every Hour', 'Every 2 Hours', 'Every 3 Hours'];

class AdminPage extends StatefulWidget {
  const AdminPage({
    Key? key,
  }) : super(key: key);

  static show(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminPage()));
  }

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final LocalStorage storage = LocalStorage('parkinsons_app.json');

  var uuid = const Uuid();

  bool idsChanged = false;
  bool notifiationsChanged = false;

  String storedUserID = '';
  String storedTrialID = '';
  String storedDeviceID = '';
  String storedNotificationFrequency = '';

  String dropdownValue = list[0];

  final userIDController = TextEditingController();
  final trialIDController = TextEditingController();
  final deviceIDController = TextEditingController();

  @override
  initState() {
    getStoredIds();
    super.initState();
  }

  getStoredIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userID = prefs.getString('userID');
    if (userID != null) {
      userIDController.text = userID;
      storedUserID = userID;
    } else {
      storedUserID = '';
    }
    final String? deviceID = prefs.getString('deviceID');
    if (deviceID != null) {
      deviceIDController.text = deviceID;
      storedDeviceID = deviceID;
    } else {
      storedDeviceID = '';
    }
    final String? trialID = prefs.getString('trialID');
    if (trialID != null) {
      trialIDController.text = trialID;
      storedTrialID = trialID;
    } else {
      storedTrialID = '';
    }
    final String? notificationFrequency = prefs.getString('notificationFrequency');
    if (notificationFrequency != null) {
      print(notificationFrequency);
      setState(() {
        print(getDropdownIndex(notificationFrequency));
        dropdownValue = list[getDropdownIndex(notificationFrequency!)];
      });
      print(dropdownValue);
      storedNotificationFrequency = list[getDropdownIndex(notificationFrequency!)];
    } else {
      storedNotificationFrequency = '';
    }
  }

  int getDropdownIndex(String value) {
    if (value == 'No Notifications') {
      return 0;
    } else if (value == 'Every 30 min') {
      return 1;
    } else if (value == 'Every Hour') {
      return 2;
    } else if (value == 'Every 2 Hours') {
      return 3;
    } else {
      return 4;
    }
  }

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
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 18, color: Color(0xff0D85C9)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back'),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0.02 * height, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text(
                        'Patient\nProfile',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'DMSans-Medium', fontSize: 30),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 320,
                      child: TextField(
                        onChanged: (String? s) {
                          print('changed');
                          updateSaveButtonForIDs();
                        },
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
                      width: 320,
                      child: TextField(
                        onChanged: (String? s) {
                          print('changed');
                          updateSaveButtonForIDs();
                        },
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
                      width: 320,
                      child: TextField(
                        onChanged: (String? s) {
                          print('changed');
                          updateSaveButtonForIDs();
                        },
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
                    width: 320,
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
                      width: 320,
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
                                updateSaveButtonForNotifications();
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
                      width: 320,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (idsChanged) {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('deviceID', deviceIDController.value.text);
                            storedDeviceID = deviceIDController.value.text;
                            await prefs.setString('trialID', trialIDController.value.text);
                            storedTrialID = trialIDController.value.text;
                            await prefs.setString('userID', userIDController.value.text);
                            storedUserID = userIDController.value.text;
                            await prefs.setString('notificationFrequency', dropdownValue);
                            storedNotificationFrequency = dropdownValue;
                            updateSaveButtonForIDs();
                          }
                          if (notifiationsChanged) {
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

                            if (repeatInterval != 0) {
                              await AwesomeNotifications().createNotification(
                                  content: NotificationContent(
                                      id: 10,
                                      channelKey: 'reminder_channel',
                                      title: 'Survey Reminder',
                                      body: 'Please record your symptoms in the Parkinson\'s Survey App',
                                      notificationLayout: NotificationLayout.Default),
                                  schedule: NotificationInterval(interval: repeatInterval, timeZone: localTimeZone, repeats: true));
                            }
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('notificationFrequency', dropdownValue);
                            storedNotificationFrequency = dropdownValue;
                            updateSaveButtonForNotifications();
                          }
                        },
                        style: (idsChanged || notifiationsChanged)
                            ? ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xff0D85C9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  //border radius equal to or more than 50% of width
                                ))
                            : ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xffe7e8e8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  //border radius equal to or more than 50% of width
                                )),
                        child: Text(
                          'Save',
                          style: (idsChanged || notifiationsChanged)
                              ? TextStyle(fontSize: 20, fontFamily: 'DMSans-Regular', color: Colors.white)
                              : TextStyle(fontSize: 20, fontFamily: 'DMSans-Regular', color: Color(0xffa6a8a9)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: SizedBox(
                        width: 180,
                        height: 65,
                        child: FutureBuilder(
                            future: storage.ready,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    Map<String,dynamic> data = storage.getItem('surveys') ?? <String,String>{};
                                    List<String> surveysUploaded = [];
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    final String? userID = prefs.getString('userID');
                                    final String? deviceID = prefs.getString('deviceID');
                                    final String? trialID = prefs.getString('trialID');
                                    for(String value in data.values) {
                                      Map<String,dynamic> survey = json.decode(value);
                                      survey['patient_id'] = userID ?? '';
                                      survey['device_id'] = deviceID ?? '';
                                      survey['trial_id'] = trialID ?? '';
                                      surveysUploaded.add(survey['survey_id']);
                                      print(survey.toString());
                                      final response = await uploadSurvey(json.encode(survey), survey['survey_id'], userID ?? '', trialID ?? '');
                                      print(response.body);
                                    }
                                    final summaryResponse = await uploadSummary(surveysUploaded, deviceID ?? '', userID ?? '', trialID ?? '');

                                    // final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    // await prefs.setBool('trial_in_progress', false);
                                    // await prefs.setString('deviceID', '');
                                    // await prefs.setString('trialID', '');
                                    // await prefs.setString('userID', '');
                                    // await prefs.setString('notificationFrequency', '');
                                    // AwesomeNotifications().cancelAll();
                                    // if (context.mounted) {
                                    //   Navigator.pushReplacement(
                                    //       context, MaterialPageRoute(builder: (context) => const TrialStartPage(), fullscreenDialog: true));
                                    // }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35),
                                        //border radius equal to or more than 50% of width
                                      )),
                                  child: const Text(
                                    'End Study',
                                    style: TextStyle(fontSize: 20, fontFamily: 'DMSans-Regular'),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<http.Response> uploadSurvey(String surveyJson, String surveyID, String userID, String trialID) async {
    final httpResponse = await getS3SurveyURL(surveyID, userID, trialID);
    final body = json.decode(httpResponse.body);
    final uploadURL = body["uploadURL"];
    return http.post(
      Uri.parse(uploadURL),
      headers: <String, String>{},
      body: surveyJson,
    );
  }

  Future<http.Response> getS3SurveyURL(String surveyID, String userID, String trialID) async {
    return http.post(
      Uri.parse(APIUrl),
      headers: <String, String>{},
      body: jsonEncode(<String, String>{
        'APIKey': S3ApiKey,
        'S3Key': 'trials/trial_id=$trialID/patient_id=$userID/surveys/$surveyID.json',
      }),
    );
  }


  Future<http.Response> uploadSummary(List<String> surveysUploaded, String deviceID, String userID, String trialID) async {
    List<String> medicationTimes = storage.getItem('medicationTimes') ?? <String>[];
    Map<String,dynamic> jsonMap = {};
    String summaryID = uuid.v4();
    jsonMap['summary_id'] = summaryID;
    jsonMap['trial_id'] = trialID;
    jsonMap['patient_id'] = userID;
    jsonMap['device_id'] = deviceID;
    jsonMap['medication_times'] = medicationTimes;
    jsonMap['surveys_uploaded'] = surveysUploaded;

    final summaryJson = json.encode(jsonMap);

    final httpResponse = await getSummaryURL(summaryID, userID, trialID);
    final body = json.decode(httpResponse.body);
    final uploadURL = body["uploadURL"];
    return http.post(
      Uri.parse(uploadURL),
      headers: <String, String>{},
      body: summaryJson,
    );
  }

  Future<http.Response> getSummaryURL(String summaryID, String userID, String trialID) async {
    return http.post(
      Uri.parse(APIUrl),
      headers: <String, String>{},
      body: jsonEncode(<String, String>{
        'APIKey': S3ApiKey,
        'S3Key': 'trials/trial_id=$trialID/patient_id=$userID/summaries/$summaryID.json',
      }),
    );
  }



  updateSaveButtonForIDs() {
    if (storedTrialID != trialIDController.value.text ||
        storedDeviceID != deviceIDController.value.text ||
        storedUserID != userIDController.value.text ||
        storedNotificationFrequency != dropdownValue) {
      setState(() {
        idsChanged = true;
      });
    } else {
      setState(() {
        idsChanged = false;
      });
    }
  }

  updateSaveButtonForNotifications() {
    if (storedNotificationFrequency != dropdownValue) {
      setState(() {
        notifiationsChanged = true;
      });
    } else {
      setState(() {
        notifiationsChanged = false;
      });
    }
  }
}
