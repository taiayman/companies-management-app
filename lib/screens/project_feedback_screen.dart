import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:business_management_app/models/feedback.dart' as ModelFeedback;
import 'package:business_management_app/services/feedback_service.dart';
import 'package:business_management_app/utils/theme.dart';

class ProjectFeedbackScreen extends StatefulWidget {
  final String ceoId;
  final bool isDarkTheme;

  ProjectFeedbackScreen({required this.ceoId, required this.isDarkTheme});

  @override
  _ProjectFeedbackScreenState createState() => _ProjectFeedbackScreenState();
}

class _ProjectFeedbackScreenState extends State<ProjectFeedbackScreen> {
  final FeedbackService _feedbackService = FeedbackService();
  List<ModelFeedback.Feedback> _feedbacks = [];

  @override
  void initState() {
    super.initState();
    _fetchFeedbacks();
  }

  Future<void> _fetchFeedbacks() async {
    try {
      List<ModelFeedback.Feedback> feedbacks = await _feedbackService.getFeedbackForCEO(widget.ceoId);
      setState(() {
        _feedbacks = feedbacks;
      });
    } catch (e) {
      print('Error loading feedbacks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme(widget.isDarkTheme).colorScheme.background,
      appBar: AppBar(
        title: Text('Project Feedbacks'),
        backgroundColor: appTheme(widget.isDarkTheme).primaryColor,
      ),
      body: _buildFeedbackList(),
    );
  }

  Widget _buildFeedbackList() {
    return _feedbacks.isEmpty
        ? Center(child: Text('No feedbacks available'))
        : ListView.builder(
            itemCount: _feedbacks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_feedbacks[index].content),
                subtitle: Text('Project: ${_feedbacks[index].projectId}\nDate: ${_feedbacks[index].date}'),
              );
            },
          );
  }
}

