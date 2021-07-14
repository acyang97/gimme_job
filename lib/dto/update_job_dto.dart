class UpdateJobDto {
  String positionName;
  String companyName;
  int applicationStatus;
  DateTime nextKeyDate;

  UpdateJobDto({
    required this.positionName,
    required this.companyName,
    required this.applicationStatus,
    required this.nextKeyDate,
  });
}
