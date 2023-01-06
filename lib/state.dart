import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/models/counter.dart';
import 'package:pomodoro/models/focusstate.dart';
import 'package:pomodoro/models/status.dart';
import 'package:pomodoro/models/task.dart';

import 'dao/taskdao.dart';


class PomodoroState extends ChangeNotifier {
  Task? selectedTask;
  late List<Task> tasks;

  int pomodoroTime;
  int shortBreakTime;
  int longBreakTime;
  int longBreakInterval;
  late Counter counter;
  Timer? timer = null;
  TaskDao taskdao;

  PomodoroState({required this.selectedTask,
    required this.pomodoroTime,
    required this.shortBreakTime,
    required this.longBreakTime,
    required this.longBreakInterval,
    required this.taskdao
  }) {
    counter = Counter(pomodoroTime, shortBreakTime, longBreakTime, longBreakInterval: longBreakInterval);
    loadTasks();
  }

  static Future<PomodoroState> newInstance({
    required Task? selectedTask,
    required int pomodoroTime,
    required int shortBreakTime,
    required int longBreakTime,
    required int longBreakInterval,
    required TaskDao taskdao
  }) async {
    PomodoroState state = PomodoroState(
        selectedTask: selectedTask,
        pomodoroTime: pomodoroTime,
        shortBreakTime: shortBreakTime,
        longBreakTime: longBreakTime,
        longBreakInterval: longBreakInterval,
        taskdao: taskdao);
    await state.loadTasks();
    return state;
  }
  void setTask(Task task) {
    selectedTask = task;
    notifyListeners();
  }

  void setFocusState(FocusState state) {
    counter.setFocusState(state);
    timer?.cancel();
    notifyListeners();
  }

  void startCountDown() {
    counter.isfinished = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(counter.isfinished) {
          timer.cancel();
          if(counter.focusState != FocusState.pomodoro) {
            selectedTask?.act += 1;
          }

      } else {
        counter.countDownOnce();
      }

      notifyListeners();
    });
  }

  void stopCountDown() {
    counter.status = Status.paused;
    timer?.cancel();

    notifyListeners();
  }

  Future<void> loadTasks() async {
    tasks = await taskdao.findAll();
  }

  Future<void> insertTask(Task task) async {
    int result = await taskdao.insertOne(task);
    task.id = result;
    tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await taskdao.updateOne(task);
    int index = tasks.indexWhere((element) => element.id == task.id);
    if(index != -1) {
      tasks[index] = task;
    }

    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await taskdao.deleteOne(task);
    tasks.removeWhere((element) => element.id == task.id);
    selectedTask = null;

    notifyListeners();
  }

  Future<void> deleteAllTasks() async {
    await taskdao.deleteAll(tasks);
    tasks = [];
    selectedTask = null;
    notifyListeners();
  }

  Future<void> deleteFinishedTasks() async {
    await taskdao.deleteAll(tasks.where((element) => element.isdone).toList());
    tasks.removeWhere((element) => element.isdone);
    notifyListeners();
  }

  Future<void> clearActPomodoro() async {
    tasks.forEach((element) { element.act = 0; });
    await taskdao.updateAll(tasks);
    notifyListeners();
  }
}