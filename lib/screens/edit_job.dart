import 'package:flutter/material.dart';
import 'package:gimme_job/services/auth_service.dart';
import 'package:gimme_job/services/job_service.dart';
import 'package:gimme_job/utils/job_argument.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:gimme_job/utils/constants.dart';
import 'package:gimme_job/models/job.dart';

class EditJobPage extends StatefulWidget {
  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final JobService _jobService = JobService();
  final AuthService _authService = AuthService();
  bool loading = false;
  final _editKey = new GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;
  String _companyName = '';
  String _positionName = '';
  // String _applicationStatus = ApplicationStatus.Applied.toString();
  int _applicationStatus = 0;
  String error = '';

  DateTime? selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as JobArgument;
    _companyName = args.job.companyName;
    print('$_companyName');
    _positionName = args.job.positionName;
    print('$_positionName');
    _applicationStatus = args.job.applicationStatus.index;
    selectedDate = args.job.nextKeyDate;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: const Text(
          'Gimme Job',
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.red[400],
            ),
            onPressed: () async {
              await _authService.signOut();
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _editKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 3.0, left: 3.0),
                    child: Text('Company Name'),
                  ),
                  TextFormField(
                    initialValue: _companyName,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Company Name'),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter the company name' : null,
                    onChanged: (val) {
                      setState(() => _companyName = val);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0, left: 3.0),
                    child: Text('Position Name'),
                  ),
                  TextFormField(
                    initialValue: _positionName,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Position Name'),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter the position name' : null,
                    onChanged: (val) {
                      setState(() => _positionName = val);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.0, bottom: 3.0),
                    child: Text('Application Status'),
                  ),
                  DropdownButtonFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Application Status'),
                    value: _applicationStatus.toString(),
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? newValue) {
                      setState(() {
                        _applicationStatus = int.parse(newValue!);
                      });
                    },
                    items:
                        ApplicationStatus.values.map<DropdownMenuItem<String>>(
                      (ApplicationStatus status) {
                        return DropdownMenuItem<String>(
                          value: ApplicationStatus.values
                              .indexOf(status)
                              .toString(),
                          child: Text(status.toString().split('.')[1]),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 3.0, left: 3.0),
                    child: Text('Next key date'),
                  ),
                  DateTimeField(
                    initialValue: selectedDate,
                    format: DateFormat("yyyy-MM-dd"),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: currentValue ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      return date;
                    },
                    autovalidateMode: autoValidateMode,
                    validator: (date) => date == null ? 'Invalid date' : null,
                    onChanged: (date) => setState(() {
                      selectedDate = date;
                    }),
                    onSaved: (date) => setState(() {
                      selectedDate = date;
                    }),
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Next Key Date',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink[400],
              ),
              onPressed: () async {
                if (_editKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  Job job = new Job(
                    uid: _authService.getCurrentUser(),
                    applicationStatus:
                        ApplicationStatus.values[_applicationStatus],
                    positionName: this._positionName,
                    companyName: this._companyName,
                    nextKeyDate: this.selectedDate!,
                  );
                  bool result =
                      await _jobService.createNewJob(job).whenComplete(
                    () {
                      setState(() {
                        loading = false;
                      });
                    },
                  );
                  if (!result) {
                    setState(
                      () {
                        error = 'Something wrong';
                        loading = false;
                      },
                    );
                  }
                }
              },
              child: Text(
                'Edit Job',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
