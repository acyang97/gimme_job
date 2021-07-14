import 'package:flutter/material.dart';
import 'package:gimme_job/screens/add_job.dart';
import 'package:gimme_job/screens/edit_job.dart';
import 'package:gimme_job/screens/landing_page.dart';
import 'package:gimme_job/utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.HOME,
      routes: {
        Routes.HOME: (context) => LandingPage(),
        Routes.EDIT_JOB: (context) => EditJobPage(),
        Routes.ADD_JOB: (context) => AddJob(),
      },
    );
  }
}
