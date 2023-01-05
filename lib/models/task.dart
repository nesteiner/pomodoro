import 'package:floor/floor.dart';

@Entity(tableName: "Task")
class Task {
  @primaryKey
  int? id;
  bool isdone;
  String text;
  int act;
  int est;

  Task(this.id, this.isdone, this.text, this.act, this.est);
  bool operator ==(Object other) => identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id?.hashCode ?? -1.hashCode;
}