import 'package:flutter/material.dart';
import 'package:pomodoro/state.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  int pomodoroTime;
  int shortBreakTime;
  int longBreakTime;
  int longBreakInterval;

  Setting(this.pomodoroTime, this.shortBreakTime, this.longBreakTime, this.longBreakInterval);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroState>(
        builder: (_, state, child) => buildHead(context)
    );
  }

  Widget buildHead(BuildContext context) {
    return SizedBox(
      width: 620,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Pomodoro", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
          buildSettingButton(context)
        ]
      ),
    );
  }

  Widget buildSettingButton(BuildContext context) {
    final state = context.read<PomodoroState>();
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => StatefulBuilder(builder: (context, setState) => AlertDialog(
                title: const Text("test"),
                content: buildContent(context, setState),
                actions: [
                  TextButton(onPressed: () {state.resetTimes(); Navigator.of(context).pop();}, child: const Text("reset")),
                  TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("cancel")),
                  TextButton(
                      onPressed: () {
                        state.setTimes(
                          pomodoroTime: widget.pomodoroTime,
                          shortBreakTime: widget.shortBreakTime,
                          longBreakTime: widget.longBreakTime,
                          longBreakInterval: widget.longBreakInterval
                        );

                        Navigator.of(context).pop(true);
                      },
                      child: const Text("confirm"))
                ],
              ))
          );
        },
        icon: const Icon(Icons.settings, color: Colors.white,)
    );
  }

  Widget buildContent(BuildContext context, void Function(void Function()) setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            const Text("Pomodoro Time"),
            Slider(
              value: widget.pomodoroTime.toDouble(),
              min: 10,
              max: 100,
              divisions: 18,

              onChanged: (value) {
                setState(() {
                  widget.pomodoroTime = value.toInt();
                });
              },
            ),
          ],
        ),

        Column(
          children: [
            const Text("ShortBreak Time"),
            Slider(
              value: widget.shortBreakTime.toDouble(),
              min: 1,
              max: 10,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  widget.shortBreakTime = value.toInt();
                });
              },
            ),
          ],
        ),

        Column(
          children: [
            const Text("LongBreak Time"),
            Slider(
              value: widget.longBreakTime.toDouble(),
              min: 1,
              max: 25,
              divisions: 25,
              onChanged: (value) {
                setState(() {
                  widget.longBreakTime = value.toInt();
                });
              },
            ),
          ],
        ),

        Column(
          children: [
            const Text("LongBreak Interval"),
            Slider(
              value: widget.longBreakInterval.toDouble(),
              min: 1,
              max: 10,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  widget.longBreakInterval = value.toInt();
                });
              },
            )
          ],
        )


      ],
    );
  }

}