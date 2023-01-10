import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/models/focusstate.dart';
import 'package:pomodoro/models/status.dart';
import 'package:pomodoro/state.dart';
import 'package:provider/provider.dart';

const WIDTH = 480.0;

class CounterWidget extends StatelessWidget {
  CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH,
      decoration:
          const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.1)),
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildFocusButtons(context),
          buildTimeText(context),
          buildClickButton(context)
        ],
      ),
    );
  }

  Widget buildFocusButtons(BuildContext context) {
    final state = context.read<PomodoroState>();

    const textstyle = TextStyle(color: Colors.white);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            state.setFocusState(FocusState.pomodoro);
          },
          child: const Text("Pomodoro", style: textstyle),
        ),
        TextButton(
            onPressed: () {
              state.setFocusState(FocusState.shortBreak);
            },
            child: const Text(
              "Short break",
              style: textstyle,
            )),
        TextButton(
            onPressed: () {
              state.setFocusState(FocusState.longBreak);
            },
            child: const Text("Long break", style: textstyle))
      ],
    );
  }

  Widget buildTimeText(BuildContext context) {
    final text = Selector<PomodoroState, String>(
      selector: (_, state) => state.counter.timeText(),
      builder: (_, value, child) => Text(
        value,
        style: const TextStyle(
            fontSize: 120, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: text,
    );
  }

  Widget buildClickButton(BuildContext context) {
    const textstyle = TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(186, 73, 73, 1),
        fontWeight: FontWeight.bold,
        fontFamily: "ArialRounded");

    final state = context.read<PomodoroState>();
    return Selector<PomodoroState, bool>(
      selector: (_, state) => state.counter.status == Status.paused,
      builder: (_, value, child) => GestureDetector(
          onTap: () {
            if (value) {
              state.startCountDown();
            } else {
              state.stopCountDown();
            }
          },
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              height: 55,
              width: 200,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  value ? "START" : "STOP",
                  style: textstyle,
                ),
              ))),
    );
  }
}
