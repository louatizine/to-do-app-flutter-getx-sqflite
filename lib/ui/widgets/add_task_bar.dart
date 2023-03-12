import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/contrllers/task_controller.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/ui/widgets/buttons.dart';
import 'package:untitled1/ui/widgets/input_field.dart';
import '../theme.dart';
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
   final TaskController  _taskController = Get.put(TaskController());
   final TextEditingController _titleController = TextEditingController();
   final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 Pm";
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList=[
    5,10,15,20
  ];

  String _selectedRepeat = "None";
  List<String> repeatList=[
    "None","Daily","Weekly","Monthly"
  ];


  int _selectedColor = 0;


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar:_appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child:SingleChildScrollView(
        child: Column(
          children: [
            Text("Add Task",
            style: headingStyle,
            ),
            MyInputField(title: "Title", hint: "Enter your Title", controller: _titleController, widget: null,),
            MyInputField(title: "Note", hint: "Enter your Note", controller: _noteController, widget: null,),
            MyInputField(title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              controller: TextEditingController(),
              widget: IconButton(
                icon: Icon(Icons.calendar_month_outlined,
                color: Colors.grey,
                ),
                onPressed: () {
                    _getDateFromUser();
                },

              ),),
            Row(
              children: [
                Expanded(
                    child: MyInputField(
                    title: "Start Date",
                    hint:_startTime,
                      controller: TextEditingController(),
                      widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStarTime:true);
                        },
                        icon:const Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey,
                        ),
                      ),
                ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: MyInputField(
                    title: "End Date",
                    hint:_endTime,
                    controller: TextEditingController(),
                    widget: IconButton(
                      onPressed: (){
                          _getTimeFromUser(isStarTime: false);
                      },
                      icon:const Icon(
                        Icons.access_time_filled_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MyInputField(title: "Remind", hint: "$_selectedRemind minutes early", controller: TextEditingController(),
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down_outlined,
                color: Colors.grey,

                ),
                iconSize: 32,
                elevation: 4,
                style:subTitleStyle,
                underline: Container(height: 0,),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                } ,
                items: remindList.map<DropdownMenuItem<String>>((int value){
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }
                ).toList(),
              ),
            ),
            MyInputField(title: "Repeat", hint: "$_selectedRepeat", controller: TextEditingController(),
              widget: DropdownButton(
                icon:const Icon(Icons.keyboard_arrow_down_outlined,
                  color: Colors.grey,

                ),
                iconSize: 32,
                elevation: 4,
                style:subTitleStyle,
                underline: Container(height: 0,),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                } ,
                items: repeatList.map<DropdownMenuItem<String>>((String? value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!,style: const TextStyle(color: Colors.grey)),
                  );
                }
                ).toList(),
              ),
            ),
            SizedBox(height: 18,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  _colorPalette(),
                MyButton(label: "Create Task", onTap: () => _validateDate(),)
              ],
            )
          ],
        ),
      ),
      ),
      );

  }


  _validateDate(){
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
        Get.snackbar("Required", "All field are required ! " ,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText:pink,
            icon:const Icon(Icons.warning_amber_rounded,color: Colors.red,),

        );


    }
  }



   _addTaskToDb() async {
      int value = await _taskController .addTask(
        task:Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat:  _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0
        ),
    );
        print("my id is " + "$value");
   }


   _colorPalette(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int index){
                return  GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor=index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar (
                      radius: 14,
                      backgroundColor: index==0?primary:index==1?pink:yellow,
                      child:_selectedColor==index?Icon(Icons.done,
                        color: Colors.white,
                        size: 16,
                      ):Container( ),
                    ),
                  ),
                );
              }
          ),

        )
      ],
    );

  }

  _appBar(BuildContext context){
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: const Icon(Icons.arrow_back,
          size:20,
          //color:Get.isDarkMode ? Colors.white:Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
              "assets/user.png"
          ),
        ),
        SizedBox(width: 20,),
      ],
    );
  }

  _getDateFromUser()async{
    DateTime? _pickerDate= await  showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2323),
    );

    if(_pickerDate!=null){
      setState(() {
        _selectedDate= _pickerDate;
        print(_selectedDate);
      });
    }else{
      print("it's null or something wrong");
    }
  }

  _getTimeFromUser({required bool isStarTime}) async {
  var pickedTime=await _showTimePicker();
  String _fomatedTime = pickedTime.format(context);
  if(pickedTime==null){
    print("Time canceled");
  }else if(isStarTime==true){
        setState(() {
          _startTime=_fomatedTime;
        });
  }else if(isStarTime==false){
        setState(() {
            _endTime=_fomatedTime;
        });
  }
  }

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute:int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }
}
