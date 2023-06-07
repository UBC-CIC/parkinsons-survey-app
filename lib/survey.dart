import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:parkinsons_app/SurveyQuestion.dart';
import 'package:parkinsons_app/custom_navigable_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:uuid/uuid.dart';


class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  late Future<Task> task;

  final LocalStorage storage = new LocalStorage('parkinsons_app.json');

  var uuid = const Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    task = getJsonTask();
    // task = getSampleTaskMorePages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder<Task>(
            future: task,
            builder: (context, snapshot) {
              print(snapshot.error);
              print(snapshot.data);
              print(snapshot.connectionState);

              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                final task = snapshot.data!;
                return SurveyKit(
                  onResult: (SurveyResult result) {
                    saveSurvey(result.toJson());
                    // print(result.toJson().toString());
                    Navigator.pop(context);
                  },
                  task: task,
                  showProgress: true,
                  localizations: const {
                    'cancel': 'Cancel',
                    'next': 'Next',
                  },
                  themeData: Theme.of(context).copyWith(
                    primaryColor: Colors.cyan,
                    appBarTheme: const AppBarTheme(
                      color: Colors.white,
                      iconTheme: IconThemeData(
                        color: Colors.cyan,
                      ),
                      titleTextStyle: TextStyle(
                        color: Colors.cyan,
                      ),
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.cyan,
                    ),
                    textSelectionTheme: const TextSelectionThemeData(
                      cursorColor: Colors.cyan,
                      selectionColor: Colors.cyan,
                      selectionHandleColor: Colors.cyan,
                    ),
                    cupertinoOverrideTheme: const CupertinoThemeData(
                      primaryColor: Colors.cyan,
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(300.0, 150.0),
                        ),
                        side: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> state) {
                            if (state.contains(MaterialState.disabled)) {
                              return const BorderSide(
                                color: Colors.grey,
                              );
                            }
                            return const BorderSide(
                              color: Colors.cyan,
                            );
                          },
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> state) {
                            if (state.contains(MaterialState.disabled)) {
                              return Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 25,
                                  );
                            }
                            return Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.cyan,
                                  fontSize: 25,
                                );
                          },
                        ),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.cyan,
                              ),
                        ),
                      ),
                    ),
                    textTheme: const TextTheme(
                      displayMedium: TextStyle(
                        fontSize: 28.0,
                        fontFamily: 'DMSans-Medium',
                        color: Colors.black,
                      ),
                      headlineSmall: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                      bodyMedium: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      titleMedium: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    colorScheme: ColorScheme.fromSwatch(
                      primarySwatch: Colors.cyan,
                    )
                        .copyWith(
                          onPrimary: Colors.white,
                        )
                        .copyWith(background: Colors.white),
                  ),
                  surveyProgressbarConfiguration: SurveyProgressConfiguration(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              return const CircularProgressIndicator.adaptive();
            },
          ),
        ),
      ),
    );
  }


  Future<Task> getJsonTask() async {
    final taskJson = await rootBundle.loadString('assets/example_json.json');
    final taskMap = json.decode(taskJson);

    // return Task.fromJson(taskMap);
    return CustomNavigableTask.fromJson(taskMap);
  }

  Future<void> saveSurvey(Map<String,dynamic> inputJson) async {

    List<String> allSymptoms = ["tremor","speech-difficulty","anxiety","sweating","mood-changes","weakness","balance-problems","slowness-of-movement","reduced-dexterity","numbness","general-stiffness","experience-panic-attack","cloudy-mind","abdominal-discomfort","muscle-cramping","difficulty-getting-out-of-chair","experience-hot-cold","pain","aching"];

    final Map<String, dynamic> arrayMap = {};

    arrayMap['survey_id'] = uuid.v4();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userID = prefs.getString('userID');
    if (userID != null) {
      arrayMap['patient_id'] = userID;
    } else {
      arrayMap['patient_id'] = '';
    }
    final String? deviceID = prefs.getString('deviceID');
    if (deviceID != null) {
      arrayMap['device_id'] = deviceID;
    } else {
      arrayMap['device_id'] = '';
    }
    final String? trialID = prefs.getString('trialID');
    if (trialID != null) {
      arrayMap['trial_id'] = trialID;
    } else {
      arrayMap['trial_id'] = '';
    }
    arrayMap["time"] = DateTime.now().toString();

    List<SurveyQuestion> results = [];

    inputJson["results"].forEach((entry) {
      if(entry["id"]["id"]!="intro" && entry["id"]["id"]!="end") {
        results.add(SurveyQuestion.fromJson(entry));
      }
    });

    List<String> recordedSymptoms = [];

    for(SurveyQuestion surveyQuestion in results) {
      recordedSymptoms.addAll(surveyQuestion.symptoms);
    }
    recordedSymptoms.removeWhere((element) => element == 'none');
    for(String symptom in allSymptoms) {
      if(recordedSymptoms.contains(symptom)) {
        arrayMap[symptom] = true;
      } else {
        arrayMap[symptom] = false;
      }
    }
    String body = json.encode(arrayMap);

    print(body);

    return;
  }

}
