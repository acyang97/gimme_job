import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gimme_job/models/job.dart';

class JobService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // the collection ref
  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('jobs');

  String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  Future<bool> createNewJob(Job job) async {
    try {
      await jobsCollection.add(job.toJson());
      return true;
    } catch (e) {
      print('createNewJob error');
      print(e);
      return false;
    }
  }

  List<Job> _jobListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((d) {
        return Job(
          uid: d.get("uid") ?? "",
          positionName: d.get("positionName") ?? "",
          companyName: d.get("companyName") ?? "",
          applicationStatus:
              d.get("applicationStatus") ?? ApplicationStatus.Applied,
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Stream<List<Job>?> get jobs {
    return jobsCollection.snapshots().map(_jobListFromSnapshot);
  }
}
