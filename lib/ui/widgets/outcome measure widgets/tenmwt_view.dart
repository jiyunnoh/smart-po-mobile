import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import '../../../model/question.dart';
import '../../common/ui_helpers.dart';
import '../stopwatch.dart';

class TenMWTView extends StatefulWidget {
  final OutcomeMeasure outcomeMeasure;

  const TenMWTView({super.key, required this.outcomeMeasure});

  @override
  State<TenMWTView> createState() => _TenMWTViewState();
}

class _TenMWTViewState extends State<TenMWTView> {
  late Question comfWalkTrial1;
  late Question comfWalkTrial2;
  late Question fastWalkTrial1;
  late Question fastWalkTrial2;
  late Question assistiveDevice;
  late QuestionWithRadialResponse actualDistanceTimed;
  late QuestionWithRadialResponse assistanceLevel;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setQuestions();
    comfWalkTrial1.value = const Duration();
    comfWalkTrial2.value = const Duration();
    fastWalkTrial1.value = const Duration();
    fastWalkTrial2.value = const Duration();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setQuestions();
  }

  void setQuestions() {
    comfWalkTrial1 =
        widget.outcomeMeasure.questionCollection.getQuestionById('tmwt_1')!;
    comfWalkTrial2 =
        widget.outcomeMeasure.questionCollection.getQuestionById('tmwt_2')!;
    fastWalkTrial1 =
        widget.outcomeMeasure.questionCollection.getQuestionById('tmwt_3')!;
    fastWalkTrial2 =
        widget.outcomeMeasure.questionCollection.getQuestionById('tmwt_4')!;
    assistiveDevice =
        widget.outcomeMeasure.questionCollection.getQuestionById('tmwt_5')!;
    assistanceLevel = widget.outcomeMeasure.questionCollection
        .getQuestionById('tmwt_6')! as QuestionWithRadialResponse;
    actualDistanceTimed = widget.outcomeMeasure.questionCollection
        .getQuestionById('tmwt_7')! as QuestionWithRadialResponse;
  }

  Widget _getDistanceDropDown() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                actualDistanceTimed.text,
                style: contentTextStyle,
              )),
        ),
        DropdownButtonFormField<String>(
          hint: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              LocaleKeys.distanceTimed,
              style: contentTextStyle,
            ).tr(),
          ),
          onChanged: (value) {
            setState(() {
              actualDistanceTimed.value = value;
            });
          },
          value: actualDistanceTimed.value,
          items: actualDistanceTimed.options
              .map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '$value m',
                    overflow: TextOverflow.visible,
                  ),
                ));
          }).toList(),
        ),
      ],
    );
  }

  Widget _getAssistanceLevelDropDown() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                assistanceLevel.text,
                style: contentTextStyle,
              )),
        ),
        DropdownButtonFormField<String>(
          hint: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              LocaleKeys.assistanceLevel,
              style: contentTextStyle,
            ).tr(),
          ),
          onChanged: (value) {
            setState(() {
              assistanceLevel.value = value;
            });
          },
          value: assistanceLevel.value,
          items: assistanceLevel.options.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    value,
                    overflow: TextOverflow.visible,
                  ).tr(),
                ));
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          assistiveDevice.text,
                          style: contentTextStyle,
                        )),
                  ),
                  TextField(
                    controller: _controller,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[ 0-9a-zA-Z\\-_./();\\|]"))
                    ],
                    onChanged: (value) {
                      // Setting assistive device used value
                      assistiveDevice.value = _controller.text;
                    },
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 16,
                    style: contentTextStyle,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                _controller.clear();
                                assistiveDevice.value = null;
                              },
                              child: const Icon(Icons.close)),
                        ),
                      ),
                      hintText: LocaleKeys.assistDeviceHint.tr(),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  _getAssistanceLevelDropDown(),
                  const SizedBox(
                    height: 20,
                  ),
                  _getDistanceDropDown()
                ],
              ),
              Card(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      LocaleKeys.comfortableSpeed,
                      style: TextStyle(fontSize: 25),
                    ).tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.trial1,
                          style: contentTextStyle,
                        ).tr()),
                  ),
                  const Divider(),
                  StopWatchWidget(comfWalkTrial1.value,
                      key: Key(comfWalkTrial1.text), onStop: (elapsedTime) {
                    print(elapsedTime.toString());
                    comfWalkTrial1.value = elapsedTime;
                  }, onReset: () {
                    comfWalkTrial1.value = const Duration();
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.trial2,
                          style: contentTextStyle,
                        ).tr()),
                  ),
                  const Divider(),
                  StopWatchWidget(comfWalkTrial2.value,
                      key: Key(comfWalkTrial2.text), onStop: (elapsedTime) {
                    comfWalkTrial2.value = elapsedTime;
                  }, onReset: () {
                    comfWalkTrial2.value = const Duration();
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
              Card(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      LocaleKeys.maximumSpeed,
                      style: TextStyle(fontSize: 25),
                    ).tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.trial1,
                          style: contentTextStyle,
                        ).tr()),
                  ),
                  const Divider(),
                  StopWatchWidget(fastWalkTrial1.value,
                      key: Key(fastWalkTrial1.text), onStop: (elapsedTime) {
                    fastWalkTrial1.value = elapsedTime;
                  }, onReset: () {
                    fastWalkTrial1.value = const Duration();
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.trial2,
                          style: contentTextStyle,
                        ).tr()),
                  ),
                  const Divider(),
                  StopWatchWidget(fastWalkTrial2.value,
                      key: Key(fastWalkTrial2.text), onStop: (elapsedTime) {
                    fastWalkTrial2.value = elapsedTime;
                  }, onReset: () {
                    fastWalkTrial2.value = const Duration();
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
