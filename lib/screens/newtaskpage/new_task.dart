import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';
import 'package:todolist/widgets.dart';

// ignore: must_be_immutable
class NewTask extends StatefulWidget {
  NewTask({super.key, this.comingTask, this.indexTaskEntity});

  final Task? comingTask;
  final int? indexTaskEntity;
  int myPriority1 = 1;
  Priority? priority;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.comingTask != null) {
      if (widget.comingTask!.priority == Priority.high) {
        widget.myPriority1 = 1;
      } else if (widget.comingTask!.priority == Priority.normal) {
        widget.myPriority1 = 2;
      } else {
        widget.myPriority1 = 3;
      }
    }
    widget.comingTask != null
        ? _titleController.text = widget.comingTask!.title
        : null;
    widget.comingTask != null
        ? _descriptionController.text = widget.comingTask!.description
        : null;
    super.initState();
  }

  voidinttoenumMypriority(int myPriority1) {
    if (myPriority1 == 1) {
      widget.priority = Priority.high;
      return widget.priority;
    } else if (myPriority1 == 2) {
      widget.priority = Priority.normal;
      return widget.priority;
    } else {
      widget.priority = Priority.low;
      return widget.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comingTask != null ? 'Edit Task' : 'Add Task'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newtask = Task();
          newtask.title = _titleController.text;
          newtask.description = _descriptionController.text;
          newtask.isCompelete = false;
          newtask.priority = voidinttoenumMypriority(widget.myPriority1);
          final repository =
              Provider.of<Repository<Task>>(context, listen: false);
          if (widget.comingTask != null) {
            widget.comingTask!.title = _titleController.text;
            widget.comingTask!.description = _descriptionController.text;
            widget.comingTask!.priority =
                voidinttoenumMypriority(widget.myPriority1);
            repository.createOrUpdate(widget.comingTask!);
          } else {
            repository.createOrUpdate(newtask);
          }

          Navigator.of(context).pop();
        },
        label: const Row(
          children: [
            Icon(Icons.check_circle),
            Text('Save Changes'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyPriorityRadio(
                    label: 'High',
                    color: themeData.colorScheme.primary,
                    groupValue: widget.myPriority1,
                    singleValue: 1,
                    onChanged: (value) {
                      setState(() {
                        widget.myPriority1 = 1; // Update myPriority1.
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MyPriorityRadio(
                    label: 'Normal',
                    color: Colors.orange,
                    groupValue: widget.myPriority1,
                    singleValue: 2,
                    onChanged: (value) {
                      setState(() {
                        widget.myPriority1 = 2; // Update myPriority1.
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MyPriorityRadio(
                    label: 'Low',
                    color: Colors.blue,
                    groupValue: widget.myPriority1,
                    singleValue: 3,
                    onChanged: (value) {
                      setState(() {
                        widget.myPriority1 = 3; // Update myPriority1.
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      lable: 'Title', titleController: _titleController),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: CustomTextField(
                        lable: 'Description',
                        titleController: _descriptionController)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyPriorityRadio extends StatelessWidget {
  const MyPriorityRadio({
    super.key,
    required this.label,
    required this.color,
    required this.groupValue,
    required this.singleValue,
    required this.onChanged,
  });
  final String label;

  final Color color;
  final int groupValue;
  final int singleValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(groupValue);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: const Color(0xffAFBED0),
          ),
        ),
        child: Stack(
          children: [
            Center(child: Text(label)),
            Positioned(
              right: 4,
              bottom: 0,
              top: 0,
              child: Center(
                child: _MyPriorityCheckBox(
                    ischecked: groupValue == singleValue, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPriorityCheckBox extends StatelessWidget {
  const _MyPriorityCheckBox({required this.ischecked, required this.color});
  final bool ischecked;

  final Color color;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: ischecked
          ? Icon(
              Icons.check,
              color: themeData.colorScheme.surface,
              size: themeData.textTheme.titleSmall!.fontSize,
            )
          : null,
    );
  }
}
