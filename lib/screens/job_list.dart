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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .where("uid", isEqualTo: _authService.getCurrentUser())
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            }
            return Expanded(
              child: _buildList(snapshot.data),
            );
          },
        ),
      ],
    );
  }

  Widget _buildList(QuerySnapshot? snapshot) {
    return loading
        ? Loading()
        : ListView.builder(
            itemCount: snapshot!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.docs[index];
              print(doc["applicationStatus"]);
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
                            onPressed: () => Navigator.of(context).pop(false),
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
          );
  }
}
