// ignore_for_file: unused_element, unused_field, unused_import, unused_local_variable

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';
import '../size_config.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    //notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();

    // _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: SafeArea(
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 6,
            ),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            //notifyHelper.scheduledNotification();
            ThemeServices().switchTeme();
          },
          icon: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              _taskController.deleteAllTasks();
              notifyHelper.cancelAllNotification();
            },
            icon: Icon(
              Icons.cleaning_services_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          const SizedBox(
            width: 20,
          )
        ],
      );

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: 'Add Task',
              onTap: () async {
                await Get.to(const AddTaskPage());

                //ThemeServices().switchTeme();
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        width: 70,
        height: 100,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        initialSelectedDate: _selectedDate,
        onDateChange: (newDate) {
          _selectedDate = newDate;
          _taskController.getTasks();
        },
      ),
    );
  }

  _noTaskmsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 220,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    color: primaryClr.withOpacity(0.5),
                    height: 90,
                    semanticsLabel: 'Task',
                  ),
                  Text(
                    'You don\'t have any task yet! \nadd new task to make your days productive',
                    style: subTilteStyle,
                    textAlign: TextAlign.center,
                  ),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskmsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
                scrollDirection:
                    (SizeConfig.orientation == Orientation.landscape)
                        ? Axis.horizontal
                        : Axis.vertical,
                itemCount: _taskController.taskList.length,
                itemBuilder: (BuildContext context, int index) {
                  var task = _taskController.taskList[index];
                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      (task.repeat == 'Weekly' &&
                          _selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      task.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(task.date!).day ==
                              _selectedDate.day) {
                    DateTime date = DateFormat.jm().parse(task.startTime!);

                    String myTime = DateFormat('HH:mm').format(date);

                    debugPrint(myTime);
                    NotifyHelper().scheduledNotification(
                        int.parse(myTime.toString().split(':')[0]),
                        int.parse(myTime.toString().split(':')[1]),
                        task);

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(seconds: 2),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                task,
                              );
                            },
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else
                    return Container();
                }),
          );
        }
      }),
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      //buttons
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          color: isClose ? Colors.transparent : clr,
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.3
                : SizeConfig.screenHeight * 0.39),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              child: Container(
                width: 120,
                height: 6,
                color: Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed',
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      notifyHelper.cancelNotification(task);
                      Get.back();
                    },
                    clr: primaryClr),
            _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  _taskController.deleteTasks(task);
                  _taskController.getTasks();
                  notifyHelper.cancelNotification(task);
                  Get.back();
                },
                clr: Colors.red[300]!),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
          ],
        ),
      ),
    ));
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }
}
