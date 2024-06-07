import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:business_management_app/models/company.dart';
import 'package:business_management_app/models/project.dart';
import 'package:business_management_app/services/company_service.dart';
import 'package:business_management_app/services/project_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final String companyId;

  CompanyDetailsScreen({required this.companyId});

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final CompanyService _companyService = CompanyService();
  final ProjectService _projectService = ProjectService();
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showButtons = true;
      });
    });
  }

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

  void _openWhatsApp(String phone) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      path: 'api.whatsapp.com/send',
      queryParameters: {'phone': phone},
    );
    if (await canLaunch(whatsappUri.toString())) {
      await launch(whatsappUri.toString());
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F0E8),
      appBar: AppBar(
        title: Text('Company Details', style: GoogleFonts.nunito()),
        backgroundColor: Color(0xFFD97757),
      ),
      body: FutureBuilder<Company>(
        future: _companyService.getCompanyById(widget.companyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading company details'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Company not found'));
          } else {
            Company company = snapshot.data!;
            return _buildCompanyDetails(context, company);
          }
        },
      ),
    );
  }

  Widget _buildCompanyDetails(BuildContext context, Company company) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company.name,
            style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              company.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'CEO: ${company.ceoName}',
            style: GoogleFonts.nunito(fontSize: 16),
          ),
          Text(
            'Email: ${company.ceoEmail}',
            style: GoogleFonts.nunito(fontSize: 16),
          ),
          Text(
            'Phone: ${company.ceoPhone}',
            style: GoogleFonts.nunito(fontSize: 16),
          ),
          Text(
            'WhatsApp: ${company.ceoWhatsApp}',
            style: GoogleFonts.nunito(fontSize: 16),
          ),
          SizedBox(height: 16),
          if (company.issueTitle.isNotEmpty) _buildIssueCard(company),
          Text(
            'Projects',
            style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Project>>(
              future: _projectService.getProjectsForCompany(company.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading projects'));
                } else {
                  List<Project>? projects = snapshot.data;
                  return projects != null && projects.isNotEmpty
                      ? ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            var project = projects[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(
                                  project.name,
                                  style: GoogleFonts.nunito(),
                                ),
                                subtitle: Text(
                                  'Budget: \$${project.budget}',
                                  style: GoogleFonts.nunito(),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: Text('No projects found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(Company company) {
    return Card(
      color: _getIssueCardColor(company.statusColor),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Reported Issue',
              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${company.issueTitle}',
                  style: GoogleFonts.nunito(fontSize: 16),
                ),
                Text(
                  'Description: ${company.issueDescription}',
                  style: GoogleFonts.nunito(fontSize: 16),
                ),
              ],
            ),
          ),
          if (_showButtons)
            AnimatedOpacity(
              opacity: _showButtons ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _sendEmail(company.ceoEmail),
                      icon: Icon(Icons.email),
                      label: Text('Email'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _openWhatsApp(company.ceoWhatsApp),
                      icon: Icon(Icons.message),
                      label: Text('WhatsApp'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getIssueCardColor(String statusColor) {
    switch (statusColor) {
      case 'red':
        return Colors.red[100]!;
      case 'yellow':
        return Colors.yellow[100]!;
      case 'green':
        return Colors.green[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}