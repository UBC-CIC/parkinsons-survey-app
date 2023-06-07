import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/custom_selection_list_tile.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/text_choice.dart';
import 'package:survey_kit/src/result/question/multiple_choice_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/selection_list_tile.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';
import 'package:survey_kit/survey_kit.dart';

class MultipleChoiceAnswerWithClearAllView extends StatefulWidget {
  final QuestionStep questionStep;
  final MultipleChoiceQuestionResult? result;
  final bool isOptional;

  const MultipleChoiceAnswerWithClearAllView({
    Key? key,
    required this.questionStep,
    required this.result,
    required this.isOptional,
  }) : super(key: key);

  @override
  _MultipleChoiceAnswerView createState() => _MultipleChoiceAnswerView();
}

class _MultipleChoiceAnswerView extends State<MultipleChoiceAnswerWithClearAllView> {
  late final DateTime _startDateTime;
  late final MultipleChoiceAnswerFormat _multipleChoiceAnswer;

  List<TextChoice> _selectedChoices = [];

  @override
  void initState() {
    super.initState();
    _multipleChoiceAnswer = widget.questionStep.answerFormat as MultipleChoiceAnswerFormat;
    _selectedChoices = widget.result?.result ?? _multipleChoiceAnswer.defaultSelection;
    _startDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      controller: SurveyController(),
      step: widget.questionStep,
      resultFunction: () => MultipleChoiceQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDateTime,
        endDate: DateTime.now(),
        valueIdentifier: _selectedChoices.map((choices) => choices.value).join(','),
        result: _selectedChoices,
      ),
      isValid: widget.questionStep.isOptional || _selectedChoices.isNotEmpty,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                widget.questionStep.text,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                ..._multipleChoiceAnswer.textChoices
                    .map(
                      (TextChoice tc) => CustomSelectionListTile(
                          text: tc.text,
                          onTap: () {
                            setState(
                              () {
                                if (_selectedChoices.contains(tc)) {
                                  _selectedChoices.remove(tc);
                                } else {
                                  _selectedChoices = [..._selectedChoices, tc];
                                  if (_selectedChoices.contains(const TextChoice(text: 'None of the above', value: 'none'))) {
                                    _selectedChoices.remove(const TextChoice(text: 'None of the above', value: 'none'));
                                  }
                                }
                              },
                            );
                          },
                          isSelected: _selectedChoices.contains(tc),
                        ),
                    )
                    .toList(),
                widget.isOptional
                    ? Container()
                    : CustomSelectionListTile(
                          text: 'None of the above',
                          onTap: () {
                            setState(
                              () {
                                if (_selectedChoices.contains(const TextChoice(text: 'None of the above', value: 'none'))) {
                                  _selectedChoices.remove(const TextChoice(text: 'None of the above', value: 'none'));
                                } else {
                                  _selectedChoices = [const TextChoice(text: 'None of the above', value: 'none')];
                                }
                              },
                            );
                          },
                          isSelected: _selectedChoices.contains(const TextChoice(text: 'None of the above', value: 'none')),
                        ),
                
                if (_multipleChoiceAnswer.otherField) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ListTile(
                      title: TextField(
                        onChanged: (v) {
                          int? currentIndex;
                          final otherTextChoice = _selectedChoices.firstWhereIndexedOrNull((index, element) {
                            final isOtherField = element.text == 'Other';

                            if (isOtherField) {
                              currentIndex = index;
                            }

                            return isOtherField;
                          });

                          setState(() {
                            if (v.isEmpty && otherTextChoice != null) {
                              _selectedChoices.remove(otherTextChoice);
                            } else if (v.isNotEmpty) {
                              final updatedTextChoice = TextChoice(text: 'Other', value: v);
                              if (otherTextChoice == null) {
                                _selectedChoices.add(updatedTextChoice);
                              } else if (currentIndex != null) {
                                _selectedChoices[currentIndex!] = updatedTextChoice;
                              }
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Other',
                          labelStyle: Theme.of(context).textTheme.headlineSmall,
                          hintText: 'Write other information here',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
