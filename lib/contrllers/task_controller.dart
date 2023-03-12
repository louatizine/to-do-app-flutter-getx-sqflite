import 'package:get/get.dart';
import 'package:untitled1/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    super.onReady();
  }
  var taskList = <Task>[].obs;

 Future<int> addTask({Task? task}) async {
    return await  DBhelper.insert(task);
}

//get all the data from the table
void getTasks() async {
   List<Map <String,dynamic> > tasks = await DBhelper.query();
   taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
}

void delete(Task task){
   DBhelper.delete(task);
   getTasks();
}
void markTaskCompleted(int id )async{
   await DBhelper.update(id);
   getTasks();
}
}