// ignore_for_file: prefer_final_fields, unused_field, unused_local_variable, unused_element

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)));
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                hint: 'Enter title here',
                title: 'Title',
                //widget: Icon(Icons.access_alarm),
                controller: _titleController,
              ),
              InputField(
                hint: 'Enter note here',
                title: 'Note',
                //widget: Icon(Icons.access_alarm),
                controller: _noteController,
              ),
              InputField(
                hint: DateFormat.yMd().format(_selectedDate),
                title: 'Date',
                widget: IconButton(
                    onPressed: () {},
                    icon: IconButton(
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _getDateFromUser();
                      },
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      hint: _startTime,
                      title: 'Start Time',
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: IconButton(
                            icon: const Icon(
                              Icons.access_time_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getTimeFromUser(isStartTime: true);
                            },
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      hint: _endTime,
                      title: 'End Time',
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: IconButton(
                            icon: const Icon(
                              Icons.access_time_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getTimeFromUser(isStartTime: false);
                            },
                          )),
                    ),
                  ),
                ],
              ),
              InputField(
                hint: '$_selectedRemind minuts early',
                title: 'Remind',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                      items: remindList
                          .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem(
                                  value: value.toString(),
                                  child: Text(
                                    '$value',
                                    style: const TextStyle(color: Colors.white),
                                  )))
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTilteStyle,
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        });
                      },
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              InputField(
                hint: _selectedRepeat,
                title: 'Repeat',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                      items: repeatList
                          .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  )))
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTilteStyle,
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                      label: 'Creat Task',
                      onTap: () {
                        _validateDate();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(
            width: 20,
          )
        ],
      );

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                  print('index is $index');
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      _taskController.getTasks();

      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All filled are required',
          colorText: pinkClr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(20100),
    );
    if (_pickedDate != null)
      setState(() {
        _selectedDate = _pickedDate;
      });
    else
      print('error date');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? TimeOfDay.now()
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15))));
    String formatting = _pickedTime!.format(context);
    if (isStartTime)
      setState(() {
        _startTime = formatting;
      });
    else if (!isStartTime)
      setState(() {
        _endTime = formatting;
      });
    else
      print('error');
  }
}
