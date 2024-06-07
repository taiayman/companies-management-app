import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:business_management_app/models/company.dart';
import 'package:business_management_app/models/project.dart';
import 'package:business_management_app/services/company_service.dart';
import 'package:business_management_app/services/project_service.dart';
import 'package:business_management_app/services/user_service.dart';
import 'package:business_management_app/models/user.dart' as AppUser;
import 'package:business_management_app/screens/add_project_screen.dart';
import 'package:business_management_app/screens/edit_project_screen.dart';
import 'package:business_management_app/screens/project_details_screen.dart';
import 'package:business_management_app/screens/report_issue_screen.dart';
import 'package:business_management_app/screens/send_notification_screen.dart';
import 'package:business_management_app/widgets/project_card.dart';
import 'package:business_management_app/utils/theme.dart';
import 'package:business_management_app/screens/profile_screen.dart';
import 'package:business_management_app/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CEODashboard extends StatefulWidget {
  final bool isDarkTheme;

  CEODashboard({required this.isDarkTheme});

  @override
  _CEODashboardState createState() => _CEODashboardState();
}

class _CEODashboardState extends State<CEODashboard> {
  final CompanyService _companyService = CompanyService();
  final ProjectService _projectService = ProjectService();
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  List<Project> _projects = [];
  Company? _selectedCompany;
  AppUser.User? _user;
  bool _isDarkTheme = false;
  String _selectedStatusColor = 'green'; // Default status color

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
    _loadUserAndCompany();
  }

  Future<void> _loadUserAndCompany() async {
    try {
      AppUser.User? user = await _userService.getCurrentUser();
      if (user == null || user.companyId.isEmpty) {
        throw Exception("User or company ID not found.");
      }

      print('User company ID: ${user.companyId}');
      setState(() {
        _user = user;
      });

      Company company = await _companyService.getCompanyById(user.companyId);
      setState(() {
        _selectedCompany = company;
        _selectedStatusColor = company.statusColor; // Initialize selected color

        // Ensure the status color is valid
        if (!['green', 'yellow', 'red'].contains(_selectedStatusColor)) {
          _selectedStatusColor = 'green';
        }
      });

      _loadProjects(company.id);
    } catch (e) {
      print('Error loading user and company: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('There was an error loading your data. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _loadProjects(String companyId) async {
    try {
      List<Project> projects = await _projectService.getProjectsForCompany(companyId);
      setState(() {
        _projects = projects;
      });
    } catch (e) {
      print('Error loading projects: $e');
    }
  }

  void _deleteProject(String projectId) async {
    await _projectService.deleteProject(projectId);
    _loadProjects(_selectedCompany!.id);
  }

  void _logout() async {
    await _authService.logout();
    await _storage.delete(key: 'userToken');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _updateCompanyStatus(String newStatus) async {
    if (_selectedCompany != null) {
      setState(() {
        _selectedStatusColor = newStatus;
        _selectedCompany!.statusColor = newStatus;
      });
      await _companyService.updateCompany(_selectedCompany!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme(_isDarkTheme).backgroundColor,
     appBar: AppBar(
  title: Text(
    'CEO Dashboard',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Color(0xFFD97757),
  iconTheme: IconThemeData(color: Colors.white),
  actions: [
    IconButton(
      icon: Icon(Icons.account_circle),
      onPressed: () {
        Navigator.pushNamed(context, '/profile');
      },
    ),
    IconButton(
      icon: Icon(Icons.logout),
      onPressed: _logout,
    ),
  ],
),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_user != null) _buildProfileHeader(),
            _buildActionButtons(),
            if (_selectedCompany != null)
              Column(
                children: [
                  _buildColorSelection(),
                  _buildProjectsSection(),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: _selectedCompany != null
  ? FloatingActionButton(
      onPressed: () {
        if (_selectedCompany != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProjectScreen(
                companyId: _selectedCompany!.id,
                companyName: _selectedCompany!.name,
              ),
            ),
          ).then((value) => _loadProjects(_selectedCompany!.id));
        }
      },
      backgroundColor: Color(0xFFD97757),
      child: Icon(Icons.add, color: Colors.white),
    )
  : null,
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(_user?.profileImage ?? 'https://via.placeholder.com/150'),
            radius: 30,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _user?.name ?? 'Unknown',
                style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'the CEO of ${_selectedCompany?.name ?? 'no company selected'}',
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionButton('Add a project', () {
            if (_selectedCompany != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProjectScreen(
                    companyId: _selectedCompany!.id,
                    companyName: _selectedCompany!.name,
                  ),
                ),
              ).then((value) => _loadProjects(_selectedCompany!.id));
            }
          }, Icons.add),
          _buildActionButton('Report an issue', () {
            if (_selectedCompany != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportIssueScreen(company: _selectedCompany!),
                ),
              );
            }
          }, Icons.report),
          _buildActionButton('Send a notification', () {
            if (_user != null && _selectedCompany != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendNotificationScreen(
                    ceoName: _user!.name,
                    companyName: _selectedCompany!.name,
                  ),
                ),
              );
            }
          }, Icons.notification_add),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, VoidCallback onPressed, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFD97757),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    textStyle: GoogleFonts.nunito(fontSize: 18),
  ),
  onPressed: onPressed,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: Colors.white),
      SizedBox(width: 8),
      Text(title, style: TextStyle(color: Colors.white)),
    ],
  ),
),
    );
  }

  Widget _buildColorSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ColorSelection(
        selectedColor: _selectedStatusColor,
        onColorSelected: _updateCompanyStatus,
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Projects',
            style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        _buildProjectsList(),
      ],
    );
  }

  Widget _buildProjectsList() {
    return Container(
      height: 400,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          return ProjectCard(
            project: _projects[index],
            onView: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(
                    project: _projects[index],
                    isDarkTheme: _isDarkTheme,
                  ),
                ),
              );
            },
            onUpdate: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProjectScreen(project: _projects[index]),
                ),
              ).then((value) => _loadProjects(_selectedCompany!.id));
            },
            onDelete: () {
              _deleteProject(_projects[index].id);
            },
          );
        },
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