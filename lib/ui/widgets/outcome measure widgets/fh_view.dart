import 'dart:math';

import 'package:biot/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../app/app.locator.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import '../../../model/question.dart';
import '../../../services/tts_service.dart';
import '../../common/ui_helpers.dart';
import '../response widgets/radiobutton_response.dart';

class FallHistoryView extends StatefulWidget {
  final OutcomeMeasure outcomeMeasure;

  FallHistoryView({super.key, required this.outcomeMeasure});

  @override
  _FallHistoryViewState createState() => _FallHistoryViewState();
}

class _FallHistoryViewState extends State<FallHistoryView> {
  late QuestionWithRadialResponse question1;
  late QuestionWithDiscreteScaleResponse question2;
  late QuestionWithDiscreteScaleResponse question3;
  late String q2;

  String _selectedKey = '';
  final _ttsService = locator<TtsService>();

  TtsState get ttsState => _ttsService.ttsState;

  @override
  void initState() {
    super.initState();
    question1 = widget.outcomeMeasure.questionCollection.getQuestionById('${ksFh}_1')
        as QuestionWithRadialResponse;
    question2 = widget.outcomeMeasure.questionCollection.getQuestionById('${ksFh}_2')
        as QuestionWithDiscreteScaleResponse;
    question3 = widget.outcomeMeasure.questionCollection.getQuestionById('${ksFh}_3')
        as QuestionWithDiscreteScaleResponse;
    q2 = question2.text;

    _ttsService.setLanguage(Locale('en'));

    _ttsService.addListener(notifyListener);
  }

  void notifyListener() {
    if (ttsState == TtsState.stopped) {
      _selectedKey = '';
    }

    setState(() {});
  }

  void onSelectKey(String newKey) {
    _selectedKey = newKey;
  }

  @override
  void dispose() {
    _ttsService.removeListener(notifyListener);
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Card(
                  key: Key('q1'),
                  color: (_selectedKey == 'q1') ? Colors.green : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(question1.text,
                                    style: contentTextStyle)),
                            IconButton(
                              onPressed: () {
                                _ttsService.speak(question1.ttsText);
                                onSelectKey('q1');
                              },
                              icon: Icon(Icons.volume_up),
                              splashRadius: 24.0,
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      RadioButtonResponse(
                          key: Key(question1.id),
                          question: question1,
                          answerStateChanged: () {
                            setState(() {
                              if (question1.value == 0) {
                                q2 = question2.text.replaceAll(
                                    RegExp('_____|"6 months"'), "4 weeks");
                              } else {
                                q2 = question2.text.replaceAll(
                                    RegExp('_____|"4 weeks"'), "6 months");
                              }
                            });
                          }),
                    ],
                  )),
              AbsorbPointer(
                absorbing: !question1.hasResponded,
                child: Card(
                  key: Key('q2'),
                  color: (_selectedKey == 'q2') ? Colors.green : null,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          question1.hasResponded ? Colors.white : Colors.grey,
                          BlendMode.modulate),
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          q2,
                                          style: contentTextStyle,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          String q2Text =
                                              '$q2 Please use scale.';
                                          // _ttsService.speak(q2Text);
                                          onSelectKey('q2');
                                        },
                                        icon: Icon(Icons.volume_up),
                                        splashRadius: 24.0,
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              height: 100,
                              child: question2.value == null
                                  ? Center(
                                      child: Text(
                                      'Please use scale',
                                      style: contentTextStyle,
                                    ))
                                  : Center(
                                      child: Text(
                                      question2.scaleValue.toStringAsFixed(0),
                                      style: TextStyle(fontSize: 50),
                                    )),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 50,
                                    onPressed: () {
                                      setState(() {
                                        question2.value = max(
                                            question2.min.toDouble(),
                                            question2.scaleValue -
                                                question2.interval);
                                      });
                                    },
                                    icon: Icon(Icons.arrow_left)),
                                Expanded(
                                  child: SfSlider(
                                    activeColor: Colors.orange,
                                    value: question2.scaleValue,
                                    min: question2.min.toDouble(),
                                    max: question2.max.toDouble(),
                                    interval: question2.interval.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        question2.value = value;
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                    iconSize: 50,
                                    onPressed: () {
                                      setState(() {
                                        question2.value = min(
                                            question2.max.toDouble(),
                                            question2.scaleValue +
                                                question2.interval);
                                      });
                                    },
                                    icon: Icon(Icons.arrow_right)),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      )),
                ),
              ),
              Card(
                key: Key('q3'),
                color: (_selectedKey == 'q3') ? Colors.green : null,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    question3.text,
                                    style: contentTextStyle,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    String q3Text =
                                        '${question3.ttsText} Please use scale.';
                                    // _ttsService.speak(q3Text);
                                    onSelectKey('q3');
                                  },
                                  icon: Icon(Icons.volume_up),
                                  splashRadius: 24.0,
                                )
                              ],
                            )),
                      ),
                      Container(
                        height: 100,
                        child: question3.value == null
                            ? Center(
                                child: Text(
                                'Please use scale',
                                style: contentTextStyle,
                              ))
                            : Center(
                                child: Text(
                                question3.scaleValue.toStringAsFixed(0),
                                style: TextStyle(fontSize: 50),
                              )),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              iconSize: 50,
                              onPressed: () {
                                setState(() {
                                  question3.value = max(
                                      question3.min.toDouble(),
                                      question3.scaleValue -
                                          question3.interval);
                                });
                              },
                              icon: Icon(Icons.arrow_left)),
                          Expanded(
                            child: SfSlider(
                              activeColor: Colors.orange,
                              value: question3.scaleValue,
                              min: question3.min.toDouble(),
                              max: question3.max.toDouble(),
                              interval: question3.interval.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  question3.value = value;
                                });
                              },
                            ),
                          ),
                          IconButton(
                              iconSize: 50,
                              onPressed: () {
                                setState(() {
                                  question3.value = min(
                                      question3.max.toDouble(),
                                      question3.scaleValue +
                                          question3.interval);
                                });
                              },
                              icon: Icon(Icons.arrow_right)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          // if (_ttsService.ttsState == TtsState.playing)
          //   Positioned.fill(
          //       child: Listener(
          //     onPointerDown: (e) => _ttsService.stop(),
          //     child: Container(
          //       color: Colors.black.withOpacity(0),
          //     ),
          //   ))
        ],
      ),
    );
  }
}
