import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimme_job/models/job.dart';
import 'package:gimme_job/services/auth_service.dart';
import 'package:gimme_job/services/job_service.dart';
import 'package:gimme_job/utils/loading.dart';
import 'package:gimme_job/widgets/job_tile.dart';

class JobList extends StatefulWidget {
  const JobList({Key? key}) : super(key: key);

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final AuthService _authService = AuthService();
  final JobService _jobService = JobService();
  bool loading = false;
  // For the sorting of the list
  String _orderBy = 'applicationStatus';
  bool _isDescending = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .where("uid", isEqualTo: _authService.getCurrentUser())
              // have to add a composite index to firebase
              .orderBy(
                _orderBy,
                descending: _isDescending,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: Text('No Applications added yet!'),
                ),
              );
            }
            return Expanded(
              child: _buildList(snapshot.data, _orderBy, _isDescending),
            );
          },
        ),
      ],
    );
  }

  Widget _buildList(
    QuerySnapshot? snapshot,
    String _orderBy,
    bool _isDescending,
  ) {
    return loading
        ? Loading()
        : Stack(
            children: [
              ListView.builder(
                itemCount: snapshot!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.docs[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      color: Colors.redAccent,
                    ),
                    onDismissed: (DismissDirection direction) {
                      setState(() {});
                    },
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this application?"),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.pink[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  _jobService.deleteJob(
                                    Job.fromJson(
                                      doc.data() as Map<String, dynamic>,
                                    ),
                                  );
                                  Navigator.of(context).pop(true);
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: const Text(
                                  "DELETE",
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text(
                                  "CANCEL",
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: JobTile(
                      job: Job.fromJson(
                        doc.data() as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 20,
                right: 20,
                height: 60,
                width: 60,
                child: Ink(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.red[400],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.sort),
                    iconSize: 30,
                    color: Colors.white,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Text(
                                'Sort By',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(height: 10.0),
                              ListTile(
                                leading:
                                    new Icon(Icons.accessibility_new_sharp),
                                title: new Text('Application Status'),
                                onTap: () {
                                  setState(() {
                                    this._orderBy = 'applicationStatus';
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.timelapse),
                                title: new Text('Next Key Date'),
                                onTap: () {
                                  setState(() {
                                    this._orderBy = 'nextKeyDate';
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.business),
                                title: new Text('Company Name'),
                                onTap: () {
                                  setState(() {
                                    this._orderBy = 'companyName';
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.title),
                                title: new Text('Position Name'),
                                onTap: () {
                                  setState(() {
                                    this._orderBy = 'positionName';
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
