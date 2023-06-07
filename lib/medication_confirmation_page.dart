import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

class RecordMedicationConfirmation extends StatefulWidget {
  const RecordMedicationConfirmation({
    Key? key, required this.justTaken, required this.timeStamp, required this.formattedTimeStamp,
  }) : super(key: key);

  final bool justTaken;
  final String timeStamp;
  final String formattedTimeStamp;

  @override
  State<RecordMedicationConfirmation> createState() => _RecordMedicationConfirmationState();
}

class _RecordMedicationConfirmationState extends State<RecordMedicationConfirmation> {

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {


    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0.1 * height,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0.25 * height, 0, 0.1 * height),
              child: Text(
                widget.justTaken? 'Please confirm that you have\njust taken your Parkinson\'s medication':'Please confirm that your most recent\nParkinson\'s medication intake was at\n${widget.formattedTimeStamp}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'DMSans-Regular',
                    color: Color(0xff2A2A2A),
                    fontSize: 28,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0.05 * height, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      height: 0.25*width,
                      width: 0.25*width,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffECEDF0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.15*width),
                              //border radius equal to or more than 50% of width
                            )),
                        child: SizedBox(
                          height: 0.12*width,
                          width: 0.12*width,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'No ',
                              style: TextStyle(fontSize: 45, fontFamily: 'DMSans-Regular', color: Colors.black),
                              textAlign: TextAlign.center,
                            ),),),
                      )),
                    SizedBox(
                        height: 0.25*width,
                        width: 0.25*width,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0D85C9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.15*width),
                                //border radius equal to or more than 50% of width
                              )),
                          child: SizedBox(
                            height: 0.12*width,
                            width: 0.12*width,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Yes',
                                style: TextStyle(fontSize: 45, fontFamily: 'DMSans-Regular', color: Colors.white),
                                textAlign: TextAlign.center,
                              ),),),
                        )),
                ],
              ),
            ),
          ],
        ),      ),
    );
  }
}