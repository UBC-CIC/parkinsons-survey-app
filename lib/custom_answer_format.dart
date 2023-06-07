// Edited by Antonio Bruno, Giacomo Ignesti and Massimo Martinelli  2022

import 'package:survey_kit/src/answer_format/boolean_answer_format.dart';
import 'package:survey_kit/src/answer_format/date_answer_format.dart';
import 'package:survey_kit/src/answer_format/double_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_auto_complete_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_double_answer_format.dart';
import 'package:survey_kit/src/answer_format/image_answer_format.dart';
import 'package:survey_kit/src/answer_format/integer_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/scale_answer_format.dart';
import 'package:survey_kit/src/answer_format/single_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/text_answer_format.dart';
import 'package:survey_kit/src/answer_format/time_answer_formart.dart';
import 'package:survey_kit/src/steps/predefined_steps/answer_format_not_defined_exception.dart';
import 'package:survey_kit/survey_kit.dart';

abstract class CustomAnswerFormat extends AnswerFormat {
  const CustomAnswerFormat();

  factory CustomAnswerFormat.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'bool':
        return BooleanAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'integer':
        return IntegerAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'double':
        return DoubleAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'text':
        return TextAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'date':
        return DateAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'single':
        return SingleChoiceAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'multiple':
        return MultipleChoiceAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'multiple_double':
        return MultipleDoubleAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'multiple_auto_complete':
        return MultipleChoiceAutoCompleteAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'scale':
        return ScaleAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'time':
        return TimeAnswerFormat.fromJson(json) as CustomAnswerFormat;
      case 'file':
        return ImageAnswerFormat.fromJson(json) as CustomAnswerFormat;
      default:
        throw AnswerFormatNotDefinedException();
    }
  }
  Map<String, dynamic> toJson();
}