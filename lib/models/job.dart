enum ApplicationPriority {
  Low,
  Medium,
  High,
}

enum ApplicationStatus {
  Applied, // Yellow
  WaitingForInterview, //Orange
  Interviewed, // Light Pink
  Offered, // Green
  Ghosted, // Ghost pokemon
  Rejected, // Red
}

class Job {
  final String uid;
  final String positionName;
  final String companyName;
  final ApplicationStatus applicationStatus;
  final DateTime nextKeyDate;

  Job({
    required this.uid,
    required this.positionName,
    required this.companyName,
    required this.applicationStatus,
    required this.nextKeyDate,
  });

  Job.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        positionName = json['positionName'],
        companyName = json['companyName'],
        applicationStatus = ApplicationStatus.values[json['applicationStatus']],
        nextKeyDate = json['nextKeyDate'].toDate();
  // nextKeyDate = DateTime.parse(json['nextKeyDate']);

  Map<String, dynamic> toJson() => {
        'uid': this.uid,
        'positionName': this.positionName,
        'companyName': this.companyName,
        'applicationStatus': this.applicationStatus.index,
        'nextKeyDate': this.nextKeyDate,
      };

  String getApplicatioStatus(Job job) {
    if (job.applicationStatus == ApplicationStatus.WaitingForInterview) {
      return "Waiting for Interview";
    }
    return job.applicationStatus.toString().split('.').last;
  }
}
