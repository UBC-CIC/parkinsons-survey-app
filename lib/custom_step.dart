import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/steps/predefined_steps/completion_step.dart';
import 'package:survey_kit/src/steps/predefined_steps/instruction_step.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/steps/step_not_defined_exception.dart';
import 'package:survey_kit/survey_kit.dart';

import 'custom_question.dart';

abstract class CustomStep extends Step {
  final StepIdentifier stepIdentifier;
  @JsonKey(defaultValue: false)
  final bool isOptional;
  @JsonKey(defaultValue: 'Next')
  final String? buttonText;
  final bool canGoBack;
  final bool showProgress;
  final bool showAppBar;

  CustomStep({
    StepIdentifier? stepIdentifier,
    this.isOptional = false,
    this.buttonText = 'Next',
    this.canGoBack = true,
    this.showProgress = true,
    this.showAppBar = true,
  }) : stepIdentifier = stepIdentifier ?? StepIdentifier();

  Widget createView({required QuestionResult? questionResult});

  factory CustomStep.fromJson(Map<String, dynamic> json) {
    return CustomQuestionStep.fromJson(json) as CustomStep;
  }

  Map<String, dynamic> toJson();

  bool operator ==(o) => o is CustomStep && o.stepIdentifier == stepIdentifier && o.isOptional == isOptional && o.buttonText == buttonText;

  int get hashCode => stepIdentifier.hashCode ^ isOptional.hashCode ^ buttonText.hashCode;
}
