import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkinsons_app/medication_confirmation_page.dart';
import 'package:parkinsons_app/medication_time_picking_page.dart';

class MedicationNowPrevious extends StatefulWidget {
  const MedicationNowPrevious({
    Key? key,
  }) : super(key: key);


  @override
  State<MedicationNowPrevious> createState() => _MedicationNowPreviousState();
}

class _MedicationNowPreviousState extends State<MedicationNowPrevious> {

  @override
  void initState() {
    super.initState();
  }


  //Formats time zone offset to be in +/-xx:xx format
  String dateTimeToString(DateTime time) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }
    final duration = time.timeZoneOffset, hours = duration.inHours, minutes = duration.inMinutes.remainder(60).abs().toInt();
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String outputTimeString = outputFormat.format(time);

    return '$outputTimeString${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}:${twoDigits(minutes)}';
  }

  @override
  Widget build(BuildContext context) {


    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.0 * height, 0, 0.0 * height),
                child: const Text(
                  'When did you last take\n your Parkinson\'s medication?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    color: Color(0xff2A2A2A),
                    fontSize: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,20),
                child: SizedBox(
                  width: 0.5*width,
                  height: 0.15*height,
                  child: ElevatedButton(
                    onPressed: () {
                      String timestamp = dateTimeToString(DateTime.now());
                      if (kDebugMode) {
                        print(timestamp);
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RecordMedicationConfirmation(justTaken: true, timeStamp: timestamp, formattedTimeStamp: '',)));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const RecordMedicationConfirmation(justTaken: true, timeStamp: ));
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xff4682b4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.05*height),
                          //border radius equal to or more than 50% of width
                        )),
                    child: SizedBox(
                      width: 0.3*width,
                      height: 0.15*height,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Just Now',
                          style: TextStyle(fontSize: 40, fontFamily: 'DMSans-Regular'),
                          textAlign: TextAlign.center,
                        ),),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,20),
                child: SizedBox(
                  width: 0.5*width,
                  height: 0.15*height,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationTimePicking()));
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xff4682b4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.05*height),
                          //border radius equal to or more than 50% of width
                        )),
                    child: SizedBox(
                      width: 0.4*width,
                      height: 0.1*height,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'At a\nPrevious Time',
                          style: TextStyle(fontSize: 40, fontFamily: 'DMSans-Regular'),
                          textAlign: TextAlign.center,
                        ),),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,40),
                child: SizedBox(
                  width: 0.35*width,
                  height: 0.08*height,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffefefef),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.05*height),
                        )),
                    child: SizedBox(
                      width: 0.18*width,
                      height: 0.07*height,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 30, fontFamily: 'DMSans-Regular', color: Colors.black),
                          textAlign: TextAlign.center,
                        ),),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




