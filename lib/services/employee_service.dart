
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_management_app/models/employee_performance.dart';

class EmployeeService {
  final CollectionReference _employeeCollection = FirebaseFirestore.instance.collection('employeePerformance');

  Future<List<EmployeePerformance>> getAllEmployeePerformances() async {
    try {
      QuerySnapshot querySnapshot = await _employeeCollection.get();
      return querySnapshot.docs.map((doc) => EmployeePerformance.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error getting employee performance data: $e');
    }
  }
}
