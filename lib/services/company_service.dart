import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_management_app/models/company.dart';

class CompanyService {
  final CollectionReference _companyCollection = FirebaseFirestore.instance.collection('companies');

  Stream<Company> getCompanyByIdStream(String companyId) {
    return _companyCollection.doc(companyId).snapshots().map((snapshot) {
      return Company.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  Future<Company> getCompanyById(String companyId) async {
    try {
      DocumentSnapshot doc = await _companyCollection.doc(companyId).get();
      if (doc.exists) {
        return Company.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Company not found');
      }
    } catch (e) {
      print('Error getting company by ID $companyId: $e');
      throw e;
    }
  }

  Future<List<Company>> getAllCompanies() async {
    try {
      QuerySnapshot querySnapshot = await _companyCollection.get();
      return querySnapshot.docs.map((doc) => Company.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error getting all companies: $e');
    }
  }

  Future<void> updateCompany(Company company) async {
    await _companyCollection.doc(company.id).update(company.toMap());
  }
}