import 'dart:async';
import 'package:floor/floor.dart';
import 'package:pomodoro/models/task.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'dao/taskdao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Task])
abstract class AppDatbase extends FloorDatabase {
  TaskDao get taskdao;
}