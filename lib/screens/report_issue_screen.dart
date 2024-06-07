import 'package:flutter/material.dart';
import 'package:business_management_app/models/company.dart';
import 'package:business_management_app/services/company_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportIssueScreen extends StatefulWidget {
  final Company company;

  ReportIssueScreen({required this.company});

  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final CompanyService _companyService = CompanyService();
  String _selectedColor = 'red';

  void _reportIssue() async {
    widget.company.issueTitle = _titleController.text;
    widget.company.issueDescription = _descriptionController.text;
    widget.company.statusColor = _selectedColor; // Set the status color

    await _companyService.updateCompany(widget.company);

    Navigator.pop(context);
  }

  Color _getStatusColor(String statusColor) {
    switch (statusColor) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report an Issue', style: GoogleFonts.nunito(color: Colors.white)),
        backgroundColor: Color(0xFFD97757),
      ),
      backgroundColor: Color(0xFFF2F0E8), // Set background color here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Issue Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Issue Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Text(
              'Issue Severity',
              style: GoogleFonts.nunito(fontSize: 16),
            ),
            SizedBox(height: 10),
            ColorSelection(
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reportIssue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD97757),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              child: Text('Submit Issue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorSelection extends StatelessWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  ColorSelection({required this.selectedColor, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildColorButton(context, 'green', Colors.green),
        _buildColorButton(context, 'yellow', Colors.yellow),
        _buildColorButton(context, 'red', Colors.red),
      ],
    );
  }

  Widget _buildColorButton(BuildContext context, String colorName, Color color) {
    bool isSelected = selectedColor == colorName;
    return GestureDetector(
      onTap: () => onColorSelected(colorName),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: isSelected
              ? Border.all(color: Colors.blue, width: 3.0)
              : null,
        ),
        width: 50.0,
        height: 50.0,
        child: Center(
          child: isSelected
              ? Icon(Icons.check, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
