import 'package:flutter/material.dart';
import 'package:parkinsons_app/trial_start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool idsChanged = false;

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
                        onChanged: updateSaveButton(),
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
                        onChanged: updateSaveButton(),
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
                        onChanged: updateSaveButton(),
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
                            updateSaveButton();
                          }
                        },
                        style: idsChanged
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
                          style: idsChanged
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
                      child: ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('trial_in_progress', false);
                          await prefs.setString('deviceID', '');
                          await prefs.setString('trialID', '');
                          await prefs.setString('userID', '');
                          await prefs.setString('notificationFrequency', '');

                          if (context.mounted) {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const TrialStartPage(), fullscreenDialog: true));
                          }
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

  updateSaveButton() {
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
}
