import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_management_app/models/feedback.dart';

class FeedbackService {
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedbacks');

  Future<void> addFeedback(Feedback feedback) async {
    await _feedbackCollection.doc(feedback.id).set(feedback.toMap());
  }

  Future<List<Feedback>> getFeedbackForProject(String projectId) async {
    QuerySnapshot querySnapshot =
        await _feedbackCollection.where('projectId', isEqualTo: projectId).get();
    return querySnapshot.docs
        .map((doc) => Feedback.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Feedback>> getFeedbackForCEO(String ceoId) async {
    QuerySnapshot querySnapshot =
        await _feedbackCollection.where('ceoId', isEqualTo: ceoId).get();
    return querySnapshot.docs
        .map((doc) => Feedback.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteFeedback(String feedbackId) async {
    await _feedbackCollection.doc(feedbackId).delete();
  }
}
