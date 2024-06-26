class Company {
  final String id;
  final String name;
  final String ceoId;
  final String ceoName;
  final String ceoEmail;
  final String ceoPhone;
  final String ceoWhatsApp;
  final int employeeCount;
  final List<String> projects;
  String statusColor;
  final String imageUrl;
  String issueTitle;
  String issueDescription;

  Company({
    required this.id,
    required this.name,
    required this.ceoId,
    required this.ceoName,
    required this.ceoEmail,
    required this.ceoPhone,
    required this.ceoWhatsApp,
    required this.employeeCount,
    required this.projects,
    this.statusColor = 'green',
    required this.imageUrl,
    this.issueTitle = '',
    this.issueDescription = '',
  });

  factory Company.fromMap(Map<String, dynamic> data) {
    return Company(
      id: data['id'] ?? '',
      name: data['name'] ?? 'Unnamed Company',
      ceoId: data['ceoId'] ?? '',
      ceoName: data['ceoName'] ?? 'Unknown CEO',
      ceoEmail: data['ceoEmail'] ?? '',
      ceoPhone: data['ceoPhone'] ?? '',
      ceoWhatsApp: data['ceoWhatsApp'] ?? '',
      employeeCount: data['employeeCount'] ?? 0,
      projects: List<String>.from(data['projects'] ?? []),
      statusColor: data['statusColor'] ?? 'green',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
      issueTitle: data['issueTitle'] ?? '',
      issueDescription: data['issueDescription'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ceoId': ceoId,
      'ceoName': ceoName,
      'ceoEmail': ceoEmail,
      'ceoPhone': ceoPhone,
      'ceoWhatsApp': ceoWhatsApp,
      'employeeCount': employeeCount,
      'projects': projects,
      'statusColor': statusColor,
      'imageUrl': imageUrl,
      'issueTitle': issueTitle,
      'issueDescription': issueDescription,
    };
  }
}

