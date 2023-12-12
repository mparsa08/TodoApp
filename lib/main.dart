import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';
import 'package:todolist/data/source/hivetasksource.dart';
import 'package:todolist/screens/homepage/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());

  await Hive.openBox<Task>(taskBoxName);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: primaryVAriantColor,
  ));

  runApp(ChangeNotifierProvider<Repository<Task>>(
      create: (context) {
        return Repository<Task>(HiveTaskDataSource(Hive.box(taskBoxName)));
      },
      child: const MyApp()));
}

const primaryColor = Color(0xff794CFF);
const primaryVAriantColor = Color(0xff5C0AFF);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);
    // const secondryTextColor = Color(0xffAFBED0);
    return MaterialApp(
      title: 'ToDoList',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: primaryVAriantColor,
          background: Color(0xffF3F5F8),
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            headlineSmall: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
