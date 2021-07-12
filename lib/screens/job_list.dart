import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gimme_job/models/job.dart';
import 'package:gimme_job/services/auth_service.dart';
import 'package:gimme_job/widgets/job_tile.dart';

class JobList extends StatefulWidget {
  const JobList({Key? key}) : super(key: key);

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final AuthService _authService = AuthService();
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
    return ListView.builder(
      itemCount: snapshot!.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        print(doc["applicationStatus"]);
        return JobTile(
          job: Job.fromJson(doc.data() as Map<String, dynamic>),
        );
      },
    );
  }
}
