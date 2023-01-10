import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:pomodoro/models/focusstate.dart';
import 'package:pomodoro/models/status.dart';

class Counter {
  late int pomodoroTime;
  late int shortBreakTime;
  late int longBreakTime;
  late List<int> currentTime; // [minutes, seconds]

  late FocusState focusState = FocusState.pomodoro;
  late int longBreakInterval;
  late int interval = 0;
  late bool isfinished = false;
  late Status status;

  AudioPlayer audioPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.release);
  AssetSource musicUrl = AssetSource("notifaction.mp3");

  Counter(this.pomodoroTime, this.shortBreakTime, this.longBreakTime, {
    this.longBreakInterval = 4
  }) {
    currentTime = [1, 0];
    status = Status.paused;
    setFocusState(focusState);
  }

  void countDownOnce() {
    status = Status.running;
    currentTime[1] -= 1;
    if(currentTime[1] == -1) {
      if(currentTime[0] != 0) {
        currentTime[1] = 59;
        currentTime[0] -= 1;
      } else {
        currentTime[1] = 0;
        isfinished = true;
        status = Status.paused;

        audioPlayer.play(musicUrl);
        Timer(Duration(seconds: 3), () async {
          await audioPlayer.release();
        });

        if(focusState == FocusState.pomodoro) {
          interval += 1;
          
          if(interval % longBreakInterval == 0) {
            setFocusState(FocusState.longBreak);
          } else {
            setFocusState(FocusState.shortBreak);
          }
        } else {
          setFocusState(FocusState.pomodoro);
        }
      }
    }
  }

  void setFocusState(FocusState focusState) {
    this.focusState = focusState;
    currentTime[1] = 0;
    if(focusState == FocusState.pomodoro) {
      currentTime[0] = pomodoroTime;
    } else if(focusState == FocusState.shortBreak) {
      currentTime[0] = shortBreakTime;
    } else {
      currentTime[0] = longBreakTime;
    }
  }

  String timeText() {
    return "${zeroPadding(currentTime[0])}:${zeroPadding(currentTime[1])}";
  }

  String zeroPadding(int number) {
    if(number < 10) {
      return "0${number}";
    } else {
      return "${number}";
    }
  }
}
