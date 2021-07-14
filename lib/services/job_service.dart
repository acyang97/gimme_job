import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gimme_job/dto/update_job_dto.dart';
import 'package:gimme_job/models/job.dart';
import 'package:intl/intl.dart';

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
      print(job);
      return true;
    } catch (e) {
      print('createNewJob error');
      print(e);
      return false;
    }
  }

  Future<bool> deleteJob(Job job) async {
    try {
      var snapshot = await jobsCollection
          .where('uid', isEqualTo: job.uid)
          .where('companyName', isEqualTo: job.companyName)
          .where('positionName', isEqualTo: job.positionName)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Job> _jobListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map(
        (d) {
          return Job(
            uid: d.get("uid") ?? "",
            positionName: d.get("positionName") ?? "",
            companyName: d.get("companyName") ?? "",
            applicationStatus:
                d.get("applicationStatus") ?? ApplicationStatus.Applied,
            nextKeyDate: d.get("nextKeyDate"),
          );
        },
      ).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Stream<List<Job>?> get jobs {
    return jobsCollection.snapshots().map(_jobListFromSnapshot);
  }

  String formatNextKeyDate(Job job) {
    return DateFormat("yyyy-MM-dd").format(job.nextKeyDate);
  }

  Future<bool> updateJob(
    Job job,
    String positionName,
    String companyName,
    DateTime dateTime,
    int applicationStatusIndex,
  ) async {
    try {
      var snapshot = await jobsCollection
          .where('uid', isEqualTo: job.uid)
          .where('companyName', isEqualTo: job.companyName)
          .where('positionName', isEqualTo: job.positionName)
          .limit(1)
          .get();
      final doc = snapshot.docs[0].reference;
      await jobsCollection.doc(doc.id).update(
        {
          'positionName': positionName,
          'companyName': companyName,
          'dateTime': dateTime,
          'applicationStatusIndex': applicationStatusIndex,
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateJobTest(Job job, UpdateJobDto updateJobDto) async {
    try {
      var snapshot = await jobsCollection
          .where('uid', isEqualTo: job.uid)
          .where('companyName', isEqualTo: job.companyName)
          .where('positionName', isEqualTo: job.positionName)
          .limit(1)
          .get();
      print(snapshot.docs.length);
      final doc = snapshot.docs[0].reference;
      await jobsCollection.doc(doc.id).update(
        {
          'positionName': updateJobDto.positionName,
          'companyName': updateJobDto.companyName,
          'nextKeyDate': updateJobDto.nextKeyDate,
          'applicationStatus': updateJobDto.applicationStatus,
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
