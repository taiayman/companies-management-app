
class EmployeePerformance {
  final String employeeName;
  final double kpiScore;

  EmployeePerformance({required this.employeeName, required this.kpiScore});

  factory EmployeePerformance.fromMap(Map<String, dynamic> data) {
    return EmployeePerformance(
      employeeName: data['employeeName'] ?? 'Unknown',
      kpiScore: data['kpiScore']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeName': employeeName,
      'kpiScore': kpiScore,
    };
  }
}