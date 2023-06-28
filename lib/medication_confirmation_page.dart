import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

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
    final LocalStorage storage = LocalStorage('parkinsons_app.json');

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
                  padding: EdgeInsets.fromLTRB(10, 0.25 * height, 10, 0.1 * height),
                  child: SizedBox(
                    width: 0.7*width,
                    height: 0.15*height,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.justTaken? 'Confirm you have\njust taken your Parkinson\'s medication':'Confirm you have taken\nParkinson\'s medication at\n${widget.formattedTimeStamp}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'DMSans-Regular',
                          color: Color(0xff545456),
                          fontSize: 40,
                        ),
                      ),
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
                              elevation: 0,
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
                            onPressed: (){
                              List<dynamic> currentJsonTimestamps = json.decode(storage.getItem('medicationTimes') ?? '[]');
                              List<String> currentTimestamps = currentJsonTimestamps.map((e) => e.toString()).toList();
                              currentTimestamps.add(widget.timeStamp);
                              storage.setItem('medicationTimes', json.encode(currentTimestamps));
                              if(!widget.justTaken) {
                                Navigator.pop(context);
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);

                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                                backgroundColor: const Color(0xff4682B4),
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
        } else {
          return CircularProgressIndicator();
        }
      },

    );
  }
}