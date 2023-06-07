import 'package:survey_kit/survey_kit.dart';

class TextQuestionResult extends QuestionResult<String> {
  final String value; //Custom value

  TextQuestionResult({
    required Identifier id,
    required DateTime startDate,
    required DateTime endDate,
    required String valueIdentifier,
    required String result,
    required this.value,
  }) : super(
    id: id,
    startDate: startDate,
    endDate: endDate,
    valueIdentifier: valueIdentifier,
    result: result,
  );

  @override
  List<Object?> get props => [value];
}