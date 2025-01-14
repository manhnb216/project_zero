import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:de1_mobile_friends/tuAI/tu_ai.dart';
import 'package:flutter/material.dart';

class TuAiMessageWidget extends StatelessWidget {
  const TuAiMessageWidget({
    Key? key,
    required this.tuAiOutput,
    required this.onYesNoRespond,
  }) : super(key: key);

  final TuAiOutput tuAiOutput;
  final Function(bool answer) onYesNoRespond;

  @override
  Widget build(BuildContext context) {
    switch (tuAiOutput.mode) {
      case TuAiOutputMode.plain_text:
      case TuAiOutputMode.filter_food:
        return _basicMsg(tuAiOutput.text);
      case TuAiOutputMode.suggest_type_yes_no:
        return _yesNoMsg();
      default:
        throw Exception(
            "[TuAiMessageWidget] Not supported ${tuAiOutput.mode.name}");
    }
  }

  Widget _yesNoMsg() {
    return Column(
      children: [
        _basicMsg(tuAiOutput.text),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                onYesNoRespond(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                onYesNoRespond(true);
              },
              child: const Text("Yes"),
            ),
          ],
        )
      ],
    );
  }

  Widget _basicMsg(String msg) {
    return BubbleSpecialOne(
      text: msg,
      color: Colors.grey,
      tail: false,
      isSender: false,
      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
