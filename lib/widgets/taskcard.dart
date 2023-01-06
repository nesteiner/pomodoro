import 'package:flutter/material.dart';
import 'package:pomodoro/models/task.dart';
import 'package:pomodoro/state.dart';


class TaskCard extends StatefulWidget {
  Task task;
  bool isselected;
  PomodoroState state;
  TaskCard(this.task, this.isselected, this.state, {super.key});

  @override
  TaskCardState createState() => TaskCardState();
}

class TaskCardState extends State<TaskCard> {
  bool expanded = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.task.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: expanded ? buildCardExpand(context) : buildCard(context) ,
    );
  }

  Widget buildCard(BuildContext context) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Image.asset(
                    "assets/ok.png",
                    width: 22,
                    height: 22,
                    color: widget.task.isdone ? Colors.red : null,
                  ),

                  onTap: () {
                    setState(() {
                      widget.task.isdone = !widget.task.isdone;
                    });
                  },
                )),
            Text(
              widget.task.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.task.isdone ? Colors.grey : Colors.black,
                decoration: widget.task.isdone ? TextDecoration.lineThrough : null
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text("${widget.task.act}/${widget.task.est}"),
            IconButton(
                onPressed: () {
                  setState(() {
                    expanded = true;
                  });

                  // widget.state.selectedTask = widget.task;
                  widget.state.setTask(widget.task);
                },
                icon: const Icon(Icons.more_vert))
          ],
        )
      ],
    );

    final container = Container(
        padding: const EdgeInsets.only(top: 18, bottom: 18, left: 14),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                left: widget.isselected
                    ? const BorderSide(color: Color.fromRGBO(34, 34, 34, 1), width: 6)
                    : const BorderSide(color: Colors.transparent, width: 0))),
        child: row);

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isselected = true;
          expanded = false;
        });

        widget.state.setTask(widget.task);
      },

      onDoubleTap: () {
        setState(() {
          widget.isselected = true;
        });
      },

      child: container,
    );
  }

  Widget buildCardExpand(BuildContext context) {
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
          width: 75,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(239, 239, 239, 1),
              borderRadius: BorderRadius.circular(4)),
          child: Text(widget.state.selectedTask?.act.toString() ?? ""),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: const Text(
            "/",
            style: TextStyle(color: Color.fromRGBO(187, 187, 187, 1)),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          width: 75,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(239, 239, 239, 1),
              borderRadius: BorderRadius.circular(4)),
          child: Text(widget.state.selectedTask?.est.toString() ?? ""),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          // width: 40,
          // height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            border:
            Border.all(color: const Color.fromRGBO(223, 223, 223, 1), width: 1),
          ),

          child: Center(
            child: GestureDetector(
              onTap: () {
                // widget.state.increaseEst();
                setState(() {
                  widget.task.est += 1;
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
                // widget.state.decreaseEst();
                setState(() {
                  widget.task.est -= 1;
                });
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
          TextButton(
              onPressed: () async {
                await widget.state.deleteTask(widget.task);

                setState(() {
                  expanded = false;
                });
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                    color: Color.fromRGBO(136, 136, 136, 1),
                    fontWeight: FontWeight.bold),
              )),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    controller.text = widget.task.text;
                    setState(() {
                      expanded = false;
                    });
                  },
                  child: const Text("Cancel",
                      style: TextStyle(
                          color: Color.fromRGBO(136, 136, 136, 1),
                          fontWeight: FontWeight.bold))),
              TextButton(
                  onPressed: () async {
                    widget.task.text = controller.text;
                    print("controller.text: ${controller.text}");
                    await widget.state.updateTask(widget.task);
                    setState(() {
                      expanded = false;
                    });
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
