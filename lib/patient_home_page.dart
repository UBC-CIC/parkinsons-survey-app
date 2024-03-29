import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinsons_app/admin_page.dart';
import 'package:parkinsons_app/medication_now_or_previous.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:parkinsons_app/survey_now_or_previous.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              onPressed: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                final String? passcode = prefs.getString('passcode');
                if (context.mounted) {
                  screenLock(
                    context: context,
                    correctString: passcode ?? '1234',
                    onUnlocked: () {
                      Navigator.pop(context);
                      AdminPage.show(context);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 0.6*width,
                height: 0.3*height,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SurveyNowPrevious()));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xff4682b4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.07*height),
                        //border radius equal to or more than 50% of width
                      )),
                  child: SizedBox(
                    width: 0.4*width,
                    height: 0.2*height,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Record\nSymptoms',
                        style: TextStyle(fontSize: 35, fontFamily: 'DMSans-Medium'),
                        textAlign: TextAlign.center,
                      ),),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 0.6*width,
                height: 0.3*height,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicationNowPrevious()));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xff4682b4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.07*height),
                        //border radius equal to or more than 50% of width
                      )),
                  child: SizedBox(
                    width: 0.4*width,
                    height: 0.2*height,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                    'Record\nMedication\nTime',
                    style: TextStyle(fontSize: 35, fontFamily: 'DMSans-Medium'),
                    textAlign: TextAlign.center,
                  ),),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
