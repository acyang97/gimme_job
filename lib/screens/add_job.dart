import 'package:flutter/material.dart';
import 'package:gimme_job/constants.dart';
import 'package:gimme_job/models/job.dart';
import 'package:gimme_job/services/auth_service.dart';
import 'package:gimme_job/services/job_service.dart';

class AddJob extends StatefulWidget {
  const AddJob({Key? key}) : super(key: key);

  @override
  _AddJobState createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final JobService _jobService = JobService();
  final AuthService _authService = AuthService();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  String _companyName = '';
  String _positionName = '';
  // String _applicationStatus = ApplicationStatus.Applied.toString();
  int _applicationStatus = 0;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Company Name'),
            validator: (val) => val!.isEmpty ? 'Enter the company name' : null,
            onChanged: (val) {
              setState(() => _companyName = val);
            },
          ),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Position Name'),
            validator: (val) => val!.isEmpty ? 'Enter the position name' : null,
            onChanged: (val) {
              setState(() => _positionName = val);
            },
          ),
          DropdownButtonFormField(
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
            items: ApplicationStatus.values.map<DropdownMenuItem<String>>(
              (ApplicationStatus status) {
                return DropdownMenuItem<String>(
                  value: ApplicationStatus.values.indexOf(status).toString(),
                  child: Text(status.toString().split('.')[1]),
                );
              },
            ).toList(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.pink[400],
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                // do something to insert the data into the database
                Job job = new Job(
                  uid: _authService.getCurrentUser(),
                  applicationStatus:
                      ApplicationStatus.values[_applicationStatus],
                  positionName: this._positionName,
                  companyName: this._companyName,
                );
                bool result =
                    await _jobService.createNewJob(job).whenComplete(() {
                  setState(() {
                    loading = false;
                  });
                });
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
              'Add Job',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
