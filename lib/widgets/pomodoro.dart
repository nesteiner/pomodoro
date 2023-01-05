import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro/models/focusstate.dart';
import 'package:pomodoro/state.dart';
import 'package:pomodoro/widgets/taskboard.dart';
import 'package:provider/provider.dart';

import '../database.dart';
import 'counter.dart';

class Pomodoro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var getcolor = (FocusState state) {
      if (state == FocusState.pomodoro) {
        return const Color.fromRGBO(186, 73, 73, 1);
      } else if (state == FocusState.shortBreak) {
        return const Color.fromRGBO(56, 133, 138, 1);
      } else {
        return const Color.fromRGBO(57, 112, 151, 1);
      }
    };

    final column = Column(
      children: [CounterWidget(), TaskBoard()],
    );

    final container = Consumer<PomodoroState>(
      builder: (_, state, child) => Container(
        decoration: BoxDecoration(color: getcolor(state.counter.focusState)),
        child: column,
      ),
    );

    final sizedbox = SizedBox.expand(
      child: container,
    );

    final cliprect = ClipRect(
      child: sizedbox,
    );

    return FutureBuilder(
        future: loadPomodoroState(),
        builder: (_, AsyncSnapshot<PomodoroState> snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.requireData;
            return ChangeNotifierProvider(
              create: (_) => state,
              child: sizedbox,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<PomodoroState> loadPomodoroState() async {
    final directory = await getApplicationSupportDirectory();

    final database = await $FloorAppDatbase
        .databaseBuilder(directory.path + "/data.db")
        .build();
    final taskdao = database.taskdao;
    final state = await PomodoroState.newInstance(
        selectedTask: null,
        pomodoroTime: 25,
        shortBreakTime: 5,
        longBreakTime: 15,
        longBreakInterval: 4,
        taskdao: taskdao);
    return state;
  }
}
