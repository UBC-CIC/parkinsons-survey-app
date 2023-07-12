import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:parkinsons_app/SurveyQuestion.dart';
import 'package:parkinsons_app/custom_navigable_task.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:uuid/uuid.dart';



class Survey extends StatefulWidget {
  const Survey({super.key, required this.timestamp, required this.isPreviousTime});

  final String timestamp;
  final bool isPreviousTime;

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  late Future<Task> task;

  final LocalStorage storage = LocalStorage('parkinsons_app.json');

  Map<int, Color> color =
  {
    50:const Color.fromRGBO(70,130,180, .1),
    100:const Color.fromRGBO(70,130,180, .2),
    200:const Color.fromRGBO(70,130,180, .3),
    300:const Color.fromRGBO(70,130,180, .4),
    400:const Color.fromRGBO(70,130,180, .5),
    500:const Color.fromRGBO(70,130,180, .6),
    600:const Color.fromRGBO(70,130,180, .7),
    700:const Color.fromRGBO(70,130,180, .8),
    800:const Color.fromRGBO(70,130,180, .9),
    900:const Color.fromRGBO(70,130,180, 1),
  };

  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    task = getJsonTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder(
            future: Future.wait([
              task,
              storage.ready,
            ]),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                final Task task = snapshot.data![0] as Task;
                return SurveyKit(
                  onResult: (SurveyResult result) {
                    if(result.finishReason.name == 'COMPLETED') {
                     saveSurvey(result.toJson());
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if(widget.isPreviousTime) {
                     Navigator.pop(context);
                    }
                  },
                  task: task,
                  showProgress: true,
                  localizations: const {
                    'cancel': 'Cancel',
                    'next': 'Next',
                  },
                  themeData: Theme.of(context).copyWith(
                    primaryColor: const Color(0xff4682b4),
                    appBarTheme: const AppBarTheme(
                      color: Colors.white,
                      iconTheme: IconThemeData(
                        color: const Color(0xff4682b4),
                      ),
                      titleTextStyle: TextStyle(
                        color: const Color(0xff4682b4),
                      ),
                    ),
                    iconTheme: const IconThemeData(
                      color: const Color(0xff4682b4),
                    ),
                    textSelectionTheme: const TextSelectionThemeData(
                      cursorColor: const Color(0xff4682b4),
                      selectionColor: const Color(0xff4682b4),
                      selectionHandleColor: const Color(0xff4682b4),
                    ),
                    cupertinoOverrideTheme: const CupertinoThemeData(
                      primaryColor: const Color(0xff4682b4),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(250.0, 150.0),
                        ),
                        side: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> state) {
                            if (state.contains(MaterialState.disabled)) {
                              return const BorderSide(
                                color: Colors.grey,
                              );
                            }
                            return const BorderSide(
                              color: Color(0xff4682b4),
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
                                  color: const Color(0xff4682b4),
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
                                color: const Color(0xff4682b4),
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
                      primarySwatch: MaterialColor(0xff4682b4, color),
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
    final taskJson = await rootBundle.loadString('assets/survey_json.json');
    final taskMap = json.decode(taskJson);

    // return Task.fromJson(taskMap);
    return CustomNavigableTask.fromJson(taskMap);
  }

  Future<List<String>> getAllSymptoms() async {
    final taskJson = await rootBundle.loadString('assets/survey_json.json');
    Map<String, dynamic> surveyMap = json.decode(taskJson);
    List<String> symptomsList = [];
    List<dynamic> stepList = [];
    if(surveyMap["steps"]!=null) {
      stepList = surveyMap["steps"];
    }
    for(Map<String,dynamic> step in stepList) {
      if(step["type"]=="customQuestion") {
        for(Map<String,dynamic> symptomChoice in step["answerFormat"]["textChoices"]){
          symptomsList.add(symptomChoice["value"]!);
        }
      }
    }
    return symptomsList;
  }

  Future<void> saveSurvey(Map<String,dynamic> inputJson) async {

    List<String> allSymptoms = await getAllSymptoms();

    final Map<String, dynamic> arrayMap = {};

    arrayMap['survey_id'] = uuid.v4();

    arrayMap["time"] = widget.timestamp;

    arrayMap["is_symptoms_from_earlier_time"] = widget.isPreviousTime;

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
    Map<String,dynamic> data = storage.getItem('surveys') ?? <String,String>{};
    data[arrayMap['survey_id']] = body;
    await storage.setItem('surveys', data);
    return;
  }

}
