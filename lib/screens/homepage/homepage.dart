import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';
import 'package:todolist/screens/homepage/bloc/task_list_bloc.dart';
import 'package:todolist/screens/newtaskpage/new_task.dart';
import 'package:todolist/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NewTask();
              },
            ),
          );
        },
        label: const Row(children: [Text('New Task')]),
      ),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(context.read<Repository<Task>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themData.colorScheme.primary,
                      themData.colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themData.textTheme.headlineSmall!.copyWith(
                                color: themData.colorScheme.onPrimary),
                          ),
                          Icon(
                            CupertinoIcons.square_favorites_alt,
                            color: themData.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: themData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: themData.colorScheme.onSurface
                                  .withOpacity(0.1),
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            context
                                .read<TaskListBloc>()
                                .add(TaskListSearch(value));
                          },
                          decoration: InputDecoration(
                            label: const Text('Search tasks...'),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: const Icon(CupertinoIcons.search),
                            prefixIconColor: const Color(0xffAFBED0),
                            labelStyle: themData.textTheme.bodyMedium!
                                .copyWith(color: const Color(0xffAFBED0)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Consumer<Repository<Task>>(
                  builder: (context, value, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themData: themData);
                        } else if (state is TaskListEmpty) {
                          return const EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is TaskListError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          throw Exception('state is not valid');
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('There is no Task\nPLease Add New Task!'));
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themData,
  });

  final List<Task> items;
  final ThemeData themData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: themData.colorScheme.primary,
                    width: 2,
                  ))),
                  child: Text(
                    'Today',
                    style: themData.textTheme.headlineSmall,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteAll());
                  },
                  elevation: 0,
                  color: const Color(0xffEAEFF5),
                  textColor: const Color(0xffAFBED0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text('Delete All'), Icon(CupertinoIcons.delete)],
                  ),
                )
              ],
            ),
          );
        } else {
          final indexTaskEntity = index - 1;
          final taskEntity = items[index - 1];
          return TaskItem(
            taskEntity: taskEntity,
            indexTaskEntity: indexTaskEntity,
          );
        }
      },
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem(
      {super.key, required this.taskEntity, required this.indexTaskEntity});

  final Task taskEntity;
  final int indexTaskEntity;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NewTask(
                  comingTask: widget.taskEntity,
                  indexTaskEntity: widget.indexTaskEntity,
                );
              },
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 84,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: themeData.colorScheme.onPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: themeData.colorScheme.onSurface.withOpacity(0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    MyCheckBox(
                      ischecked: widget.taskEntity.isCompelete,
                      onTap: () async {
                        final repository = Provider.of<Repository<Task>>(
                            context,
                            listen: false);
                        setState(() {
                          widget.taskEntity.isCompelete =
                              !widget.taskEntity.isCompelete;
                          repository.createOrUpdate(widget.taskEntity);
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.taskEntity.title,
                      style: themeData.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: widget.taskEntity.isCompelete
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 84,
              width: 10,
              decoration: BoxDecoration(
                color: widget.taskEntity.priority == Priority.high
                    ? themeData.colorScheme.primary
                    : widget.taskEntity.priority == Priority.normal
                        ? Colors.orange
                        : Colors.blue,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
