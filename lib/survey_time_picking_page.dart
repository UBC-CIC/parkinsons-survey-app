import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/survey.dart';

import 'medication_confirmation_page.dart';

class SurveyTimePicking extends StatefulWidget {
  const SurveyTimePicking({
    Key? key,
  }) : super(key: key);

  @override
  State<SurveyTimePicking> createState() => _SurveyTimePickingState();
}

class _SurveyTimePickingState extends State<SurveyTimePicking> {
  late DateTime _result;

  @override
  void initState() {
    super.initState();
    _result = DateTime.now();
  }

  String dateTimeToString(DateTime time) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final duration = time.timeZoneOffset, hours = duration.inHours, minutes = duration.inMinutes.remainder(60).abs().toInt();
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm");
    String outputTimeString = outputFormat.format(time);

    return '$outputTimeString${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}:${twoDigits(minutes)}';
  }

  String formatDateTime(DateTime dateTimeObj) {
    return DateFormat("MMM d, y h:mm a").format(dateTimeObj);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0.0 * height,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.05 * height, 0, 0.0 * height),
                child: const Text(
                  'Please enter the time\nyou were experiencing\nyour symptoms',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    color: Color(0xff2A2A2A),
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 0.6*height,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        _result = newTime;
                      });
                    },
                  ),
                ),
              ),

                // child: CupertinoDatePicker(
                //     mode: CupertinoDatePickerMode.time,
                //     onDateTimeChanged: (DateTime newTime) {
                //       setState(() {
                //         _result = newTime;
                //       });
                //     },
                //   ),
                // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 0.3 * width,
                      height: 0.1 * height,
                      child: ElevatedButton(
                        onPressed: () {
                          String timestamp = dateTimeToString(_result);
                          if (kDebugMode) {
                            print(timestamp);
                          }
                          String formattedDateTime = formatDateTime(_result);
                          Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const RecordMedicationConfirmation(justTaken: true, timeStamp: ));
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xffefefef),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.05 * height),
                              //border radius equal to or more than 50% of width
                            )),
                        child: SizedBox(
                          width: 0.12 * width,
                          height: 0.1 * height,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Back',
                              style: TextStyle(fontSize: 35, fontFamily: 'DMSans-Regular', color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 0.3 * width,
                      height: 0.1 * height,
                      child: ElevatedButton(
                        onPressed: () {
                          String timestamp = dateTimeToString(_result);
                          if (kDebugMode) {
                            print(timestamp);
                          }
                          String formattedDateTime = formatDateTime(_result);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Survey(
                                        timestamp: timestamp,
                                        isPreviousTime: true,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff4682b4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.05 * height),
                              //border radius equal to or more than 50% of width
                            )),
                        child: SizedBox(
                          width: 0.3 * width,
                          height: 0.1 * height,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Continue',
                              style: TextStyle(fontSize: 35, fontFamily: 'DMSans-Regular'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
