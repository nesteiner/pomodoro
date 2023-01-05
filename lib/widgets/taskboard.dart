import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pomodoro/models/task.dart';
import 'package:pomodoro/state.dart';
import 'package:pomodoro/widgets/taskcard.dart';
import 'package:provider/provider.dart';


const WIDTH = 480.0;

class TaskBoard extends StatefulWidget {
  @override
  TaskBoardState createState() => TaskBoardState();
}

class TaskBoardState extends State<TaskBoard> {
  TextEditingController controller = TextEditingController();
  bool expanded = false;
  Task inputtask = Task(null, false, "", 0, 1);

  @override
  Widget build(BuildContext context) {
    final listview = Consumer<PomodoroState>(
        builder: (_, PomodoroState state, child) => ReorderableListView.builder(
          shrinkWrap: true,
          buildDefaultDragHandles: false,
          itemCount: state.tasks.length,
          onReorder: (int oldindex, int newindex) {
            setState(() {
              if (oldindex < newindex) {
                newindex -= 1;
              }

              final Task item = state.tasks.removeAt(oldindex);
              state.tasks.insert(newindex, item);
            });
          },
          itemBuilder: (context, index) {
            final task = state.tasks[index];
            return ReorderableDragStartListener(
              key: Key(task.id.toString()),
              index: index,
              child: TaskCard(task, false, state)
            );
          },
        ));

    final addtask = Consumer<PomodoroState>(
        builder: (_, state, child) => buildAddTask(context, state));

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: WIDTH),
          child: listview,
        ),

        SizedBox(
          width: WIDTH,
          child: addtask,
        )

      ],
    );

  }


  Widget buildAddTask(BuildContext context, PomodoroState state) {
    return expanded ? buildAddTaskExpand(context, state) : buildAddTaskOriginal(context, state);
  }

  Widget buildAddTaskOriginal(BuildContext context, PomodoroState state) {
    final container = Container(
      margin: EdgeInsets.only(top: 12),
      height: 64,
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.4), width: 2)
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: EdgeInsets.only(right: 8),
            child: Image.asset("assets/plus-circle-white.png"),
          ),

          Text("Add Task", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 0.8)),)
        ],
      ),
    );
      


    final opacity = Opacity(
        opacity: 0.8,
      child: container,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = true;
        });
      },

      child: opacity,
    );
  }

  Widget buildAddTaskExpand(BuildContext context, PomodoroState state) {
    final panelpart1 = Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(
            fontSize: 22,
            color: Color.fromRGBO(85, 85, 85, 1),
            fontWeight: FontWeight.bold),
      ),
    );

    final panelpart2 = Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Act/Est Pomodoros",
              style: TextStyle(
                  color: Color.fromRGBO(85, 85, 85, 1),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ],
        ));

    final panelpart3 = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          width: 75,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(239, 239, 239, 1),
              borderRadius: BorderRadius.circular(4)),
          child: Text(inputtask.est.toString()),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          // width: 40,
          // height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            border: Border.all(color: const Color.fromRGBO(223, 223, 223, 1), width: 1),
          ),

          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  inputtask.est += 1;
                });
              },
              child: const Icon(Icons.arrow_drop_up),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          // width: 40,
          // height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              border: Border.all(
                  color: const Color.fromRGBO(223, 223, 223, 1), width: 1)),

          child: Center(
            child: GestureDetector(
              onTap: () {
                if(inputtask.est != 1) {
                  setState(() {
                    inputtask.est -= 1;
                  });
                }
              },
              child: const Icon(Icons.arrow_drop_down_sharp),
            ),
          ),
        )
      ],
    );


    const textstyle = TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(0, 0, 0, 0.4),
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline);

    final panelpart4 = Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "+ Add Note",
                style: textstyle,
              )),
          TextButton(
              onPressed: () {},
              child: const Text(
                "+ Add Project",
                style: textstyle,
              ))
        ],
      ),
    );

    final panel = Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Colors.white),
      child: Column(
        children: [panelpart1, panelpart2, panelpart3, panelpart4],
      ),
    );

    final buttons = Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 239, 239, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Container()),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    controller.text = inputtask.text;
                    setState(() {
                      expanded = false;
                    });
                  },
                  child: const Text("Cancel",
                      style: TextStyle(
                          color: Color.fromRGBO(136, 136, 136, 1),
                          fontWeight: FontWeight.bold))),
              TextButton(
                  onPressed: () {
                    setState(() {
                      inputtask.text = controller.text;
                      expanded = false;
                    });

                    controller.text = "";
                    state.insertTask(inputtask);
                    inputtask = Task(null, false, "", 0, 1);
                  },
                  child: const Text("Save"))
            ],
          )
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [panel, buttons],
      ),
    );
  }
}
