import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/contrllers/task_controller.dart';
import 'package:untitled1/services/themes_servecies.dart';
import 'package:untitled1/ui/theme.dart';
import 'package:get/get.dart';
import 'package:untitled1/ui/widgets/add_task_bar.dart';
import 'package:untitled1/ui/widgets/buttons.dart';
import 'package:untitled1/ui/widgets/task_tile.dart';

import '../models/task.dart';
import '../services/notification_services.dart';

class HomePge extends StatefulWidget {
  const HomePge({Key? key}) : super(key: key);

  @override
  State<HomePge> createState() => _HomePgeState();
}

class _HomePgeState extends State<HomePge> {
DateTime _selectedDate = DateTime.now();
final _taskController = Get.put(TaskController());
var notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper= NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
           _addTaskBar(),
           _addDateBar(),
          const SizedBox(height: 10,),
          _showTasks(),
          ],
      )
      );
  }
  _showTasks(){
      return Expanded(
        child: Obx((){
          return ListView.builder(
              itemCount: _taskController.taskList.length,
              itemBuilder: (_, index){
                print(_taskController.taskList.length);
                return AnimationConfiguration.staggeredList(
                    position: index,
                      child: SlideAnimation
                        (
                        child: FadeInAnimation(
                        child: Row(
                       children: [
                        GestureDetector
                      (
                        onTap: () {
                                    _showBottomSheet(context, _taskController.taskList[index]);
                                  },
                            child: TaskTile(_taskController.taskList[index]),
                      )
                  ],
                ),
                ),
                )
                );

          });
        }),
      );
  }


_showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
          Container(
            padding: const EdgeInsets.only(top: 4),
            height: task.isCompleted==1?
            MediaQuery.of(context).size.height*0.24:
            MediaQuery.of(context).size.height*0.32,
              color: Get.isDarkMode?darkGreyClr:Colors.white,
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
                  ),
                ),
                const Spacer(),
                task.isCompleted==1
                ?Container()
                    :_bottomSheetButton(label: "Task Completed", onTap: (){
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                }, clr: primary,
                  context:context,
                ),
                const SizedBox(height: 20,),
                  _bottomSheetButton(label: "Delete Task", onTap: (){
                    _taskController.delete(task);
                     Get.back();
                    },
                      clr: Colors.red[300]!,
                      context:context,
                  ),
                const SizedBox(height: 20,),
                _bottomSheetButton(label: "Close", onTap: (){
                  Get.back();
                },
                  clr: Colors.red[300]!,
                  isClose:true,
                  context:context,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )
    );

}

_bottomSheetButton({
required String label ,
  required  Function()? onTap,
  required Color clr ,
  bool isClose=false,
  required BuildContext context
}){
return GestureDetector(
  onTap: onTap,
  child: Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    height: 55,
    width: MediaQuery.of(context).size.width*0.9,
    decoration: BoxDecoration(
      border: Border.all(
        width: 2,
        color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
      ),
      borderRadius: BorderRadius.circular(20),
      color:isClose==true?Colors.transparent:clr,
    ),
    child: Center(
      child: Text(
        label,
        style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
      ),
    ),
  ),
);
}
  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top:20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primary,
        selectedTextColor: Colors.white,
        dateTextStyle:GoogleFonts.lato(
            textStyle :const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.grey
            )
        ),
        dayTextStyle:GoogleFonts.lato(
            textStyle :const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey
            )
        ),
        monthTextStyle:GoogleFonts.lato(
            textStyle :const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey
            )
        ),
        onDateChange: (date){
          _selectedDate=date;
        },

      ),
    )
    ;
  }
  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text('Today',style: headingStyle,)
            ],
          ),
          MyButton(label: '+ ADD Task',
            onTap:()async{
            await Get.to(()=>const AddTaskPage());
            _taskController.getTasks();
            },
          )
    ],
      ),
    );

  }
  _appBar(){
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
          onTap: (){
              ThemeServecies().switchTheme();
              notifyHelper.displayNotification(
                title:"Theme Changed",
                body:Get.isDarkMode?"Activated Dark Theme":"Activated Light Theme"
              );

              notifyHelper.scheduledNotification();
          },
        child: const Icon(
          /*Get.isDarkMode? Icons.wb_sunny_outlined:*/ Icons.nightlight_round_outlined,
          size:20,
        //color: Get.isDarkMode?  Colors.white:Colors.black,
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
}


