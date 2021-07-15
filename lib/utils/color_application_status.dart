import 'package:gimme_job/models/job.dart';
import 'package:flutter/material.dart';

class ColorApplicationStatus {
  static Color getColor(ApplicationStatus applicationStatus) {
    switch (applicationStatus) {
      case ApplicationStatus.Applied:
        return Colors.blue;
      case ApplicationStatus.WaitingForInterview:
        return Colors.yellow;
      case ApplicationStatus.Interviewed:
        return Colors.orange;
      case ApplicationStatus.Offered:
        return Colors.green;
      case ApplicationStatus.Ghosted:
        return Colors.deepPurple;
      case ApplicationStatus.Rejected:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
