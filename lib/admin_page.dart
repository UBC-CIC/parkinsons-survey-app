import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:localstorage/localstorage.dart';
import 'package:parkinsons_app/start_study_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'backend_configuration.dart';
import 'package:uuid/uuid.dart';

import 'loading_page.dart';

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

  // Value notifier to update animated status icons when uploading results
  final uploadResult = ValueNotifier<String>('none');

  var uuid = const Uuid();

  bool idsChanged = false;
  bool notifiationsChanged = false;

  String storedUserID = '';
  String storedTrialID = '';
  String storedDeviceID = '';
  String storedNotificationFrequency = '';

  String dropdownValue = list[0];

  final patientIDController = TextEditingController();
  final trialIDController = TextEditingController();
  final deviceIDController = TextEditingController();

  bool patientIDValid = true;
  bool trialIDValid = true;
  bool deviceIDValid = true;

  getStoredIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userID = prefs.getString('userID');
    if (userID != null) {
      patientIDController.text = userID;
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
      setState(() {
        dropdownValue = list[getDropdownIndex(notificationFrequency!)];
      });
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
  initState() {
    getStoredIds();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    patientIDController.dispose();
    trialIDController.dispose();
    deviceIDController.dispose();
    super.dispose();
  }

  // Regex for validating trial id and patient id
  final validCharacters = RegExp(r'^[a-zA-Z0-9_\-]+$');


  // UI

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
                          if (patientIDController.value.text.isNotEmpty && validCharacters.hasMatch(patientIDController.value.text)) {
                            setState(() {
                              patientIDValid = true;
                            });
                          } else {
                            setState(() {
                              patientIDValid = false;
                            });
                          }
                          updateSaveButtonForIDs();
                        },
                        controller: patientIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          labelText: 'Patient ID',
                          errorText: patientIDValid? null : 'The patient ID must be:\nAt least 1 character long\nContain only alphanumeric characters,\nhyphens, or underscores',
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
                          if (trialIDController.value.text.isNotEmpty && validCharacters.hasMatch(trialIDController.value.text)) {
                            setState(() {
                              trialIDValid = true;
                            });
                          } else {
                            setState(() {
                              trialIDValid = false;
                            });
                          }
                          updateSaveButtonForIDs();
                        },
                        controller: trialIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          labelText: 'Trial ID',
                          errorText: trialIDValid? null : 'The trial ID must be:\nAt least 1 character long\nContain only alphanumeric characters,\nhyphens, or underscores',
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
                          if (deviceIDController.value.text.isNotEmpty) {
                            setState(() {
                              deviceIDValid = true;
                            });
                          } else {
                            setState(() {
                              deviceIDValid = false;
                            });
                          }
                          updateSaveButtonForIDs();
                        },
                        controller: deviceIDController,
                        style: const TextStyle(fontSize: 18, fontFamily: 'DMSans-Regular'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          labelText: 'Wearable Device ID',
                          errorText: deviceIDValid? null : 'Please enter a value',
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
                          borderRadius: BorderRadius.circular(14.0),
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
                          if (patientIDController.text.isEmpty || trialIDController.text.isEmpty || deviceIDController.text.isEmpty) {
                            if (patientIDController.text.isEmpty) {
                              setState(() {
                                patientIDValid = false;
                              });
                            }
                            if (trialIDController.text.isEmpty) {
                              setState(() {
                                trialIDValid = false;
                              });
                            }
                            if (deviceIDController.text.isEmpty) {
                              setState(() {
                                deviceIDValid = false;
                              });
                            }
                          } else {
                            if (idsChanged) {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('deviceID', deviceIDController.value.text);
                              storedDeviceID = deviceIDController.value.text;
                              await prefs.setString('trialID', trialIDController.value.text);
                              storedTrialID = trialIDController.value.text;
                              await prefs.setString('userID', patientIDController.value.text);
                              storedUserID = patientIDController.value.text;
                              await prefs.setString('notificationFrequency', dropdownValue);
                              storedNotificationFrequency = dropdownValue;
                              updateSaveButtonForIDs();
                            }
                            if (notifiationsChanged) {
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
                          }
                        },
                        style: (idsChanged || notifiationsChanged)
                            ? ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xff0D85C9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  //border radius equal to or more than 50% of width
                                ))
                            : ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xffe7e8e8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
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
                                  onPressed: () {
                                    _showAlertDialog(context);
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
                                    style: TextStyle(fontSize: 20, fontFamily: 'DMSans-Medium'),
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

  _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('End current study and upload results?'),
        content: const Text('This action cannot be undone.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              handleUpload();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  handleUpload() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userID = prefs.getString('userID');
    final String? deviceID = prefs.getString('deviceID');
    final String? trialID = prefs.getString('trialID');

    uploadData(deviceID ?? '', userID ?? '', trialID ?? '').then((value) {
      if (value == true) {
        Gaimon.success();
        uploadResult.value = 'success';
        Future.delayed(const Duration(seconds: 2), () async {
          await prefs.setBool('trial_in_progress', false);
          await prefs.setString('deviceID', '');
          await prefs.setString('trialID', '');
          await prefs.setString('userID', '');
          await prefs.setString('notificationFrequency', '');
          await AwesomeNotifications().cancelAll();
          await storage.clear();
          if (context.mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StudyStartPage(), fullscreenDialog: true));
          }
        });
      } else {
        Gaimon.error();
        uploadResult.value = 'failed';
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            uploadResult.value = 'none';
            Navigator.pop(context);
          });
        });
      }
    });
  }

  Future<bool> uploadData(String deviceID, String userID, String trialID) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Loading(uploadStatus: uploadResult);
      },
    );

    Map<String, dynamic> storageSurveyMap = storage.getItem('surveys') ?? <String, dynamic>{};
    Map<String, dynamic> surveyMap = <String, dynamic>{};
    List<String> studySurveys = [];
    String studyID = uuid.v4();

    storageSurveyMap.forEach((key, value) {
      Map<String, dynamic> survey = json.decode(value);
      survey['patient_id'] = userID ?? '';
      survey['device_id'] = deviceID ?? '';
      survey['trial_id'] = trialID ?? '';
      survey['study_id'] = studyID;
      studySurveys.add(survey['survey_id']);
      surveyMap[key] = survey;
    });

    Map<String, Map<String, dynamic>> uploadMap = {};
    uploadMap['surveys'] = surveyMap;
    List<dynamic> jsonMedicationTimes = json.decode(storage.getItem('medicationTimes') ?? '[]');
    List<String> medicationTimes = jsonMedicationTimes.map((e) => e.toString()).toList();

    Map<String, dynamic> summaryMap = {};
    summaryMap['study_id'] = studyID;
    summaryMap['trial_id'] = trialID;
    summaryMap['patient_id'] = userID;
    summaryMap['device_id'] = deviceID;
    summaryMap['medication_times'] = medicationTimes;
    summaryMap['study_surveys'] = studySurveys;

    uploadMap['study_summary'] = summaryMap;

    final httpResponse = await getUploadURL(studyID, userID, trialID);
    if (httpResponse.statusCode == 200) {
      final body = json.decode(httpResponse.body);
      if (body == null || body["uploadURL"] == null) {
        return false;
      }
      final uploadURL = body["uploadURL"];
      final uploadResponse = await http.put(
        Uri.parse(uploadURL),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(uploadMap).codeUnits,
      );

      if (uploadResponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<http.Response> getUploadURL(String studyID, String userID, String trialID) async {
    return http.post(
      Uri.parse(APIUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'APIKey': S3ApiKey,
        'S3Key': 'trials/trial_id=$trialID/patient_id=$userID/studies/$studyID.json',
      }),
    );
  }

  updateSaveButtonForIDs() {
    if (storedTrialID != trialIDController.value.text ||
        storedDeviceID != deviceIDController.value.text ||
        storedUserID != patientIDController.value.text ||
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
