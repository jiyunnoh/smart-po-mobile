import 'package:biot/constants/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app.locator.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import '../../../model/question.dart';
import '../../../services/app_locale_service.dart';
import '../../common/ui_helpers.dart';
import '../stopwatch.dart';

class FsstTimer extends StatefulWidget {
  final OutcomeMeasure outcomeMeasure;

  const FsstTimer({super.key, required this.outcomeMeasure});

  @override
  State<FsstTimer> createState() => _FsstTimerState();
}

class _FsstTimerState extends State<FsstTimer> {
  final TextEditingController _controller = TextEditingController();
  late Question trial1;
  late Question trial2;
  late Question assistiveDeviceUsedQuestion;
  late Question didRepeatQuestion;
  late Question didFaceForwardQuestion;
  List<bool> didRepeat = [false, false];
  List<bool> didFaceForward = [false, false];
  final _localeService = locator<AppLocaleService>();

  @override
  void initState() {
    super.initState();
    setQuestions();
    trial1.value = const Duration();
    trial2.value = const Duration();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setQuestions();
  }

  void setQuestions() {
    trial1 =
        widget.outcomeMeasure.questionCollection.getQuestionById("${ksFsst}_1")!;
    trial2 =
        widget.outcomeMeasure.questionCollection.getQuestionById("${ksFsst}_2")!;
    didRepeatQuestion =
        widget.outcomeMeasure.questionCollection.getQuestionById("${ksFsst}_3")!;
    assistiveDeviceUsedQuestion =
        widget.outcomeMeasure.questionCollection.getQuestionById("${ksFsst}_4")!;
    didFaceForwardQuestion =
        widget.outcomeMeasure.questionCollection.getQuestionById("${ksFsst}_5")!;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              assistiveDeviceUsedQuestion.text,
              style: contentTextStyle,
            ),
          ),
          TextField(
            autocorrect: false,
            controller: _controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp("[ 0-9a-zA-Z\\-_./();\\|]"))
            ],
            onChanged: (value) {
              // Setting assistive device used value
              assistiveDeviceUsedQuestion.value = _controller.text;
            },
            textAlignVertical: TextAlignVertical.center,
            maxLength: 16,
            style: contentTextStyle,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              suffixIcon: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        _controller.clear();
                        assistiveDeviceUsedQuestion.value = null;
                      },
                      child: const Icon(Icons.close)),
                ),
              ),
              hintText: _localeService.tr(
                  context.fallbackLocale!, LocaleKeys.assistDeviceHint),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                _localeService.tr(context.fallbackLocale!, LocaleKeys.trial1),
                style: const TextStyle(fontSize: 20)),
          ),
          const Divider(),
          StopWatchWidget(
            trial1.value,
            onStop: (elapsed) {
              trial1.value = elapsed;
            },
            onReset: () {
              trial1.value = const Duration();
            },
            locale: context.fallbackLocale!,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                _localeService.tr(context.fallbackLocale!, LocaleKeys.trial2),
                style: const TextStyle(fontSize: 20)),
          ),
          const Divider(),
          StopWatchWidget(
            trial2.value,
            onStop: (elapsed) {
              trial2.value = elapsed;
            },
            onReset: () {
              trial2.value = const Duration();
            },
            locale: context.fallbackLocale!,
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(didRepeatQuestion.text,
                      style: const TextStyle(fontSize: 20)),
                ),
                ToggleButtons(
                  isSelected: didRepeat,
                  selectedColor: Colors.white,
                  fillColor: Colors.orange,
                  onPressed: (index) {
                    setState(() {
                      didRepeat[index] = true;
                      for (var i = 0; i < didRepeat.length; i++) {
                        if (i == index) {
                          continue;
                        }
                        didRepeat[i] = false;
                      }
                      didRepeatQuestion.value = didRepeat[0];
                    });
                  },
                  children: [
                    Text(_localeService.tr(
                        context.fallbackLocale!, LocaleKeys.yes)),
                    Text(_localeService.tr(
                        context.fallbackLocale!, LocaleKeys.no))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(didFaceForwardQuestion.text,
                      style: const TextStyle(fontSize: 20)),
                ),
                ToggleButtons(
                  isSelected: didFaceForward,
                  selectedColor: Colors.white,
                  fillColor: Colors.orange,
                  onPressed: (index) {
                    setState(() {
                      didFaceForward[index] = true;
                      for (var i = 0; i < didFaceForward.length; i++) {
                        if (i == index) {
                          continue;
                        }
                        didFaceForward[i] = false;
                      }
                      didFaceForwardQuestion.value = didFaceForward[0];
                    });
                  },
                  children: [
                    Text(_localeService.tr(
                        context.fallbackLocale!, LocaleKeys.yes)),
                    Text(_localeService.tr(
                        context.fallbackLocale!, LocaleKeys.no))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
