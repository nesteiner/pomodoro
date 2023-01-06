import 'package:floor/floor.dart';
import 'package:pomodoro/models/task.dart';

@dao
abstract class TaskDao {
  @Query("select * from Task")
  Future<List<Task>> findAll();

  @insert
  Future<int> insertOne(Task task);

  @delete
  Future<void> deleteOne(Task task);

  @delete
  Future<void> deleteAll(List<Task> tasks);

  @update
  Future<void> updateOne(Task task);

  @update
  Future<void> updateAll(List<Task> tasks);
}