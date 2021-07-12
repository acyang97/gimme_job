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

  Job({
    required this.uid,
    required this.positionName,
    required this.companyName,
    required this.applicationStatus,
  });

  Job.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        positionName = json['positionName'],
        companyName = json['companyName'],
        applicationStatus = ApplicationStatus.values[json['applicationStatus']];

  Map<String, dynamic> toJson() => {
        'uid': this.uid,
        'positionName': this.positionName,
        'companyName': this.companyName,
        'applicationStatus': this.applicationStatus.index,
      };
}
