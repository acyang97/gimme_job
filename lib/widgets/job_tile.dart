import 'package:flutter/material.dart';
import 'package:gimme_job/models/job.dart';
import 'package:gimme_job/services/job_service.dart';

class JobTile extends StatelessWidget {
  final Job job;
  final JobService _jobService = new JobService();

  JobTile({required this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.blue,
          ),
          // TODO: Implement feature to edit
          trailing: IconButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onPressed: () {
              // navigate to the
            },
          ),
          title: Padding(
            padding: EdgeInsets.only(
              top: 5.0,
            ),
            child: Text(
              job.companyName,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Position: ${job.positionName}',
                ),
                Text(
                  'Status: ${job.getApplicatioStatus(job)}',
                ),
                Text(
                  'Next Key Date: ${_jobService.formatNextKeyDate(job)}',
                ),
              ],
            ),
          ),
        ), // a way to display infoormation in a list
      ),
    );
  }
}
