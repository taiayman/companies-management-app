import 'package:flutter/material.dart';
import 'package:business_management_app/models/project.dart';
import 'package:business_management_app/models/team_member.dart';
import 'package:business_management_app/models/feedback.dart' as CustomFeedback;
import 'package:business_management_app/services/project_service.dart';
import 'package:business_management_app/services/feedback_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  final bool isDarkTheme;
  final bool isBoss;

  ProjectDetailsScreen({
    required this.project,
    required this.isDarkTheme,
    this.isBoss = false, // Add a default value
  });

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final ProjectService _projectService = ProjectService();
  final FeedbackService _feedbackService = FeedbackService();
  final TextEditingController _feedbackController = TextEditingController();
  List<TeamMember> _teamMembers = [];
  List<CustomFeedback.Feedback> _feedbacks = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
    _fetchFeedbacks();
  }

  Future<void> _fetchTeamMembers() async {
    if (widget.project.teamMemberIds.isNotEmpty) {
      List<TeamMember> teamMembers =
          await _projectService.getTeamMembers(widget.project.teamMemberIds);
      setState(() {
        _teamMembers = teamMembers;
      });
    }
  }

  Future<void> _fetchFeedbacks() async {
    List<CustomFeedback.Feedback> feedbacks =
        await _feedbackService.getFeedbackForProject(widget.project.id);
    setState(() {
      _feedbacks = feedbacks;
    });
  }

  void _submitFeedback() async {
    if (_feedbackController.text.isNotEmpty) {
      final feedback = CustomFeedback.Feedback(
        id: Uuid().v4(),
        projectId: widget.project.id,
        bossId: 'boss-id', // Replace with actual boss ID
        content: _feedbackController.text,
        date: DateTime.now(),
      );
      await _feedbackService.addFeedback(feedback);
      _feedbackController.clear();
      _fetchFeedbacks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkTheme ? const Color(0xFF2C2B28) : const Color(0xFFF2F0E8),
      appBar: AppBar(
        title: Text(widget.project.name,
            style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: const Color(0xFFD97757),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Description'),
              const SizedBox(height: 8),
              Text(widget.project.details,
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: widget.isDarkTheme
                          ? Colors.white
                          : Colors.black)),
              const SizedBox(height: 16),
              _buildSectionTitle('Goals'),
              const SizedBox(height: 8),
              Text(widget.project.goals,
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: widget.isDarkTheme
                          ? Colors.white
                          : Colors.black)),
              const SizedBox(height: 16),
              _buildSectionTitle('Start and End Date'),
              const SizedBox(height: 8),
              Text(
                '${DateFormat('yyyy/MM/dd').format(widget.project.start.toLocal())} to ${DateFormat('yyyy/MM/dd').format(widget.project.end.toLocal())}',
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    color:
                        widget.isDarkTheme ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Budget'),
              const SizedBox(height: 8),
              Text('\$${widget.project.budget}',
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: widget.isDarkTheme
                          ? Colors.white
                          : Colors.black)),
              const SizedBox(height: 16),
              _buildSectionTitle('Team Members'),
              const SizedBox(height: 8),
              _buildTeamMembersWrap(),
              const SizedBox(height: 16),
              _buildFeedbackSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: widget.isDarkTheme ? Colors.white : Colors.black),
    );
  }

  Widget _buildTeamMembersWrap() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.project.teamMemberNames.map((name) {
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color:
                widget.isDarkTheme ? const Color(0xFF444444) : Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
                color: widget.isDarkTheme
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
                width: 1),
          ),
          child: Text(
            name,
            style: GoogleFonts.nunito(
                fontSize: 16,
                color: widget.isDarkTheme ? Colors.white : Colors.black),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Feedback'),
        if (widget.isBoss) ...[
          const SizedBox(height: 13),
          TextField(
            controller: _feedbackController,
            decoration: InputDecoration(
              labelText: 'Add Feedback',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _submitFeedback,
            child: const Text('Submit Feedback'),
          ),
          const SizedBox(height: 16),
        ],
        _buildFeedbackList(),
      ],
    );
  }

  Widget _buildFeedbackList() {
    return _feedbacks.isEmpty
        ? Text('No feedback available',
            style: GoogleFonts.nunito(
                fontSize: 16,
                color: widget.isDarkTheme ? Colors.white : Colors.black))
        : SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = _feedbacks[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Stack(
                      children: [
                        // Feedback content within the card
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: widget.isDarkTheme
                                ? const Color(0xFF444444)
                                : Colors.yellow[200],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.only(
                              left: 16.0,
                              top: 16.0,
                              bottom: 16.0,
                              right: 56.0), // Add right padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  feedback.content,
                                  style: GoogleFonts.nunito(
                                    fontSize: 17,
                                    color: widget.isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Date: ${DateFormat('yyyy/MM/dd').format(feedback.date.toLocal())}',
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: widget.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Positioned close icon
                        if (widget.isBoss)
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color:
                                      Color.fromARGB(255, 235, 59, 59)),
                              onPressed: () {
                                _removeFeedback(feedback.id);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }



  void _removeFeedback(String feedbackId) {
    // Implement the logic to remove the feedback from the database or local list
    // For example, you can call a method from the FeedbackService to delete the feedback
    _feedbackService.deleteFeedback(feedbackId);

    // Update the local list of feedbacks
    setState(() {
      _feedbacks = _feedbacks
          .where((feedback) => feedback.id != feedbackId)
          .toList();
    });
  }
}