class SurveyQuestion {

  final List<String> symptoms;

  const SurveyQuestion({
    required this.symptoms,
  });

  static SurveyQuestion fromJson(json) {
    List<String> symptoms = [];
    for(Map<String,dynamic> page in json["results"]) {
      if(page["id"]!="intro" && page["id"]!="end") {
        for(Map<String,dynamic> results in page["result"]) {
          symptoms.add(results["value"] ?? "");
        }
      }
    }

    return SurveyQuestion(symptoms: symptoms);
  }
}