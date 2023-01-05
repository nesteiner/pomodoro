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
    return Consumer<PomodoroState>(builder: (_, state, child) {
      return Container(
        width: WIDTH,
        decoration: const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.1)),
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildFocusButtons(context, state),
            buildTimeText(context, state),
            buildClickButton(context, state)
          ],
        ),
      );
    });
  }

  Widget buildFocusButtons(BuildContext context, PomodoroState state) {
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

  Widget buildTimeText(BuildContext context, PomodoroState state) {
    final text = Text(
      state.counter.timeText(),
      style: const TextStyle(
          fontSize: 120,
          color: Colors.white,
          fontWeight: FontWeight.bold,
      ),
    );
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: text,
    );
  }

  Widget buildClickButton(BuildContext context, PomodoroState state) {
    const textstyle = TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(186, 73, 73, 1),
        fontWeight: FontWeight.bold,
        fontFamily: "ArialRounded");

    return GestureDetector(
        onTap: () {
          if (state.counter.status == Status.paused) {
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
                state.counter.status == Status.paused ? "START" : "STOP",
                style: textstyle,
              ),
            )));
  }
}