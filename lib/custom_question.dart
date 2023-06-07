import 'package:flutter/material.dart' hide Step;
import 'package:flutter/widgets.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'custom_multiple_choice_answer_view.dart';
import 'custom_answer_format.dart';

// Run flutter pub run build_runner build --delete-conflicting-outputs
part 'custom_question.g.dart';

@JsonSerializable()
class CustomQuestionStep extends QuestionStep {
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String text;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Widget content;
  final AnswerFormat answerFormat;

  CustomQuestionStep({
    bool isOptional = false,
    String buttonText = 'Next',
    StepIdentifier? stepIdentifier,
    bool showAppBar = true,
    this.title = '',
    this.text = '',
    this.content = const SizedBox.shrink(),
    required this.answerFormat,
  }) : super(
    answerFormat: answerFormat,
    stepIdentifier: stepIdentifier,
    isOptional: isOptional,
    buttonText: buttonText,
    showAppBar: showAppBar,
  );

  @override
  Widget createView({required QuestionResult? questionResult}) {
    final key = ObjectKey(this.stepIdentifier.id);

    if (answerFormat.runtimeType == MultipleChoiceAnswerFormat) {
      return MultipleChoiceAnswerWithClearAllView(
        isOptional: this.isOptional,
        key: key,
        questionStep: this,
        result: questionResult as MultipleChoiceQuestionResult?,
      );
    }

    return super.createView(questionResult: questionResult);
    //
    // switch (answerFormat.runtimeType) {
    //   case IntegerAnswerFormat:
    //     return IntegerAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as IntegerQuestionResult?,
    //     );
    //   case DoubleAnswerFormat:
    //     return DoubleAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as DoubleQuestionResult?,
    //     );
    //   case TextAnswerFormat:
    //     return TextAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as TextQuestionResult?,
    //     );
    //   case SingleChoiceAnswerFormat:
    //     FocusManager.instance.primaryFocus?.unfocus();
    //     return SingleChoiceAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as SingleChoiceQuestionResult?,
    //     );
    //   case MultipleChoiceAnswerFormat:
    //     return MultipleChoiceAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as MultipleChoiceQuestionResult?,
    //     );
    //   case MultipleChoiceAnswerWithClearAllFormat:
    //     return MultipleChoiceAnswerWithClearAllView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as MultipleChoiceQuestionResult?,
    //     );
    //   case ScaleAnswerFormat:
    //     return ScaleAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as ScaleQuestionResult?,
    //     );
    //   case BooleanAnswerFormat:
    //     return BooleanAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as BooleanQuestionResult?,
    //     );
    //   case DateAnswerFormat:
    //     return DateAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as DateQuestionResult?,
    //     );
    //   case TimeAnswerFormat:
    //     return TimeAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as TimeQuestionResult?,
    //     );
    //   case ImageAnswerFormat:
    //     return ImageAnswerView(
    //       key: key,
    //       questionStep: this,
    //       result: questionResult as ImageQuestionResult?,
    //     );
    //   default:
    //     throw AnswerFormatNotDefinedException();
    // }



    // return StepView(
    //   step: this,
    //   resultFunction: () => TextQuestionResult(
    //     id: id,
    //     startDate: DateTime.now(),
    //     endDate: DateTime.now(),
    //     valueIdentifier: 'custom',
    //     //Identification for NavigableTask,
    //     result: 'custom_result',
    //     value: '',
    //   ),
    //   title: Text('Title'),
    //   child: Center(
    //       child:
    //           Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 SizedBox(
    //                   width: 200,
    //                   height: 80,
    //                   child: CheckboxListTile(
    //                     title: Text('asdf'),
    //                     value: _checked,
    //                     onChanged: (bool? value) {
    //                       setState((){
    //                         _checked = value;
    //                       });
    //                     },
    //                     checkColor: Colors.black,
    //                   ),
    //                 )
    //
    //               ],
    //           )
    //   ), //Add your view here
    // );
  }

  // @override
  // Map<String, dynamic> toJson() {
  //   // TODO: implement toJson
  //   throw UnimplementedError();
  // }

  // static CustomQuestionStep fromJson(json) => CustomQuestionStep(id: id);


  factory CustomQuestionStep.fromJson(Map<String, dynamic> json) {

    return _$CustomQuestionStepFromJson(json);
  }
  Map<String, dynamic> toJson() => _$CustomQuestionStepToJson(this);

}

class CheckboxData {
  String displayText;
  String value;

  CheckboxData({required this.displayText, required this.value});
}
