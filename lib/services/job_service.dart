import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gimme_job/models/job.dart';

class JobService {
  // the collection ref
  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('jobs');

  Future<void> createNewJob(Job job) async {
    try {
      await jobsCollection.add({
        "positionName": job.positionName,
        "companyName": job.companyName,
        "applicationStatus": job.applicationStatus,
      });
    } catch (e) {
      print(e);
    }
  }
}
