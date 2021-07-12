import 'package:flutter/material.dart';
import 'package:gimme_job/models/job.dart';

class JobTile extends StatelessWidget {
  final Job job;

  JobTile({required this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 20.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown,
          ),
          title: Text(job.companyName),
          subtitle: Text(
            'Position: ${job.positionName}, ApplicationStatus: ${job.applicationStatus}',
          ),
        ), // a way to display infoormation in a list
      ),
    );
  }
}
