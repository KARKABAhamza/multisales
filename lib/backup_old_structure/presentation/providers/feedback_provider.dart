import 'package:flutter/foundation.dart';

/// Feedback Provider for MultiSales Client App
/// Handles client feedback, ratings, reviews, and satisfaction surveys
class FeedbackProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _submittedFeedback = [];
  List<Map<String, dynamic>> _availableSurveys = [];
  Map<String, dynamic>? _activeSurvey;
  List<Map<String, dynamic>> _serviceRatings = [];
  Map<String, double> _overallRatings = {};

  bool _feedbackSubmissionEnabled = true;
  bool _anonymousFeedbackEnabled = true;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get submittedFeedback => _submittedFeedback;
  List<Map<String, dynamic>> get availableSurveys => _availableSurveys;
  Map<String, dynamic>? get activeSurvey => _activeSurvey;
  List<Map<String, dynamic>> get serviceRatings => _serviceRatings;
  Map<String, double> get overallRatings => _overallRatings;
  bool get feedbackSubmissionEnabled => _feedbackSubmissionEnabled;
  bool get anonymousFeedbackEnabled => _anonymousFeedbackEnabled;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Initialize Feedback System
  Future<bool> initializeFeedbackSystem(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      await Future.wait([
        _loadSubmittedFeedback(clientId),
        _loadAvailableSurveys(),
        _loadServiceRatings(clientId),
        _calculateOverallRatings(),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize feedback system: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Client's Submitted Feedback
  Future<bool> _loadSubmittedFeedback(String clientId) async {
    try {
      _submittedFeedback = [
        {
          'id': 'feedback_001',
          'clientId': clientId,
          'type': 'service_rating',
          'category': 'technical_support',
          'rating': 5,
          'title': 'Excellent Technical Support',
          'comment':
              'The technician was professional, knowledgeable, and solved my internet issue quickly. Great service!',
          'submittedDate': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'serviceId': 'tech_support_001',
          'technicianId': 'tech_ahmed_001',
          'isAnonymous': false,
          'status': 'reviewed',
          'response': {
            'message':
                'Thank you for your positive feedback! We\'ll share this with Ahmed.',
            'respondedBy': 'Customer Relations Team',
            'respondedDate': DateTime.now()
                .subtract(const Duration(days: 3))
                .toIso8601String(),
          },
          'tags': ['technical_support', 'installation', 'professional'],
        },
        {
          'id': 'feedback_002',
          'clientId': clientId,
          'type': 'app_feedback',
          'category': 'mobile_app',
          'rating': 4,
          'title': 'Good App, Could Use More Features',
          'comment':
              'The app is user-friendly and works well. Would love to see more payment options and better notifications.',
          'submittedDate': DateTime.now()
              .subtract(const Duration(days: 12))
              .toIso8601String(),
          'serviceId': 'mobile_app',
          'technicianId': null,
          'isAnonymous': true,
          'status': 'acknowledged',
          'response': {
            'message':
                'We appreciate your suggestions! New payment options and notification improvements are coming in our next update.',
            'respondedBy': 'Product Team',
            'respondedDate': DateTime.now()
                .subtract(const Duration(days: 8))
                .toIso8601String(),
          },
          'tags': ['mobile_app', 'features', 'payments', 'notifications'],
        },
        {
          'id': 'feedback_003',
          'clientId': clientId,
          'type': 'service_complaint',
          'category': 'internet_service',
          'rating': 2,
          'title': 'Frequent Internet Disconnections',
          'comment':
              'My internet keeps disconnecting several times a day. This has been ongoing for weeks and affects my work.',
          'submittedDate': DateTime.now()
              .subtract(const Duration(days: 20))
              .toIso8601String(),
          'serviceId': 'internet_001',
          'technicianId': null,
          'isAnonymous': false,
          'status': 'resolved',
          'response': {
            'message':
                'We apologize for the inconvenience. A technician has replaced your router and the issue should be resolved. We\'ve also credited your account.',
            'respondedBy': 'Technical Support Manager',
            'respondedDate': DateTime.now()
                .subtract(const Duration(days: 15))
                .toIso8601String(),
          },
          'tags': ['internet', 'connectivity', 'technical_issue'],
          'resolution': {
            'action': 'Router replacement and account credit',
            'creditAmount': 100.0,
            'followUpDate':
                DateTime.now().add(const Duration(days: 7)).toIso8601String(),
          },
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load submitted feedback: $e');
      return false;
    }
  }

  // Load Available Surveys
  Future<bool> _loadAvailableSurveys() async {
    try {
      _availableSurveys = [
        {
          'id': 'survey_001',
          'title': 'Service Satisfaction Survey',
          'description':
              'Help us improve our services by sharing your experience',
          'category': 'satisfaction',
          'estimatedTime': 5, // minutes
          'totalQuestions': 8,
          'incentive': '50 MAD account credit',
          'validUntil':
              DateTime.now().add(const Duration(days: 14)).toIso8601String(),
          'isCompleted': false,
          'priority': 'high',
          'questions': [
            {
              'id': 'q1',
              'type': 'rating',
              'question':
                  'How satisfied are you with your overall MultiSales experience?',
              'required': true,
              'minRating': 1,
              'maxRating': 5,
            },
            {
              'id': 'q2',
              'type': 'rating',
              'question':
                  'How would you rate the quality of our internet service?',
              'required': true,
              'minRating': 1,
              'maxRating': 5,
            },
            {
              'id': 'q3',
              'type': 'multiple_choice',
              'question':
                  'Which aspect of our service is most important to you?',
              'required': true,
              'options': [
                'Speed',
                'Reliability',
                'Customer Support',
                'Pricing',
                'Coverage'
              ],
            },
            {
              'id': 'q4',
              'type': 'text',
              'question':
                  'What improvements would you like to see in our services?',
              'required': false,
              'maxLength': 500,
            },
          ],
        },
        {
          'id': 'survey_002',
          'title': 'Mobile App Experience Survey',
          'description': 'Share your thoughts on our mobile app',
          'category': 'product_feedback',
          'estimatedTime': 3,
          'totalQuestions': 5,
          'incentive': null,
          'validUntil':
              DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          'isCompleted': false,
          'priority': 'medium',
          'questions': [
            {
              'id': 'q1',
              'type': 'rating',
              'question': 'How easy is it to navigate our mobile app?',
              'required': true,
              'minRating': 1,
              'maxRating': 5,
            },
            {
              'id': 'q2',
              'type': 'multiple_choice',
              'question': 'Which feature do you use most often?',
              'required': true,
              'options': [
                'Account Management',
                'Bill Payment',
                'Support Chat',
                'Service Requests',
                'Usage Tracking'
              ],
            },
            {
              'id': 'q3',
              'type': 'yes_no',
              'question': 'Would you recommend our app to others?',
              'required': true,
            },
          ],
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load available surveys: $e');
      return false;
    }
  }

  // Load Service Ratings
  Future<bool> _loadServiceRatings(String clientId) async {
    try {
      _serviceRatings = [
        {
          'serviceType': 'internet_service',
          'serviceName': 'Fiber Internet 200 Mbps',
          'averageRating': 4.2,
          'totalRatings': 156,
          'clientRating': 4,
          'lastRatedDate': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
        },
        {
          'serviceType': 'customer_support',
          'serviceName': 'Technical Support',
          'averageRating': 4.7,
          'totalRatings': 89,
          'clientRating': 5,
          'lastRatedDate': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
        },
        {
          'serviceType': 'mobile_app',
          'serviceName': 'MultiSales Mobile App',
          'averageRating': 4.1,
          'totalRatings': 234,
          'clientRating': 4,
          'lastRatedDate': DateTime.now()
              .subtract(const Duration(days: 12))
              .toIso8601String(),
        },
        {
          'serviceType': 'installation_service',
          'serviceName': 'Professional Installation',
          'averageRating': 4.5,
          'totalRatings': 67,
          'clientRating': null, // Not rated yet
          'lastRatedDate': null,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load service ratings: $e');
      return false;
    }
  }

  // Calculate Overall Ratings
  Future<bool> _calculateOverallRatings() async {
    try {
      _overallRatings = {
        'overall_satisfaction': 4.3,
        'service_quality': 4.2,
        'customer_support': 4.7,
        'value_for_money': 4.0,
        'app_experience': 4.1,
      };

      return true;
    } catch (e) {
      _setError('Failed to calculate overall ratings: $e');
      return false;
    }
  }

  // Submit Service Rating
  Future<bool> submitServiceRating({
    required String serviceType,
    required String serviceName,
    required int rating,
    String? comment,
    List<String>? tags,
    bool isAnonymous = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      if (rating < 1 || rating > 5) {
        _setError('Rating must be between 1 and 5');
        _setLoading(false);
        return false;
      }

      await Future.delayed(const Duration(milliseconds: 800));

      final newFeedback = {
        'id': 'feedback_${DateTime.now().millisecondsSinceEpoch}',
        'clientId': 'client_123',
        'type': 'service_rating',
        'category': serviceType,
        'rating': rating,
        'title': _generateFeedbackTitle(rating),
        'comment': comment ?? '',
        'submittedDate': DateTime.now().toIso8601String(),
        'serviceId': serviceType,
        'technicianId': null,
        'isAnonymous': isAnonymous,
        'status': 'pending',
        'response': null,
        'tags': tags ?? [],
      };

      _submittedFeedback.insert(0, newFeedback);

      // Update service rating
      final serviceIndex =
          _serviceRatings.indexWhere((s) => s['serviceType'] == serviceType);
      if (serviceIndex != -1) {
        _serviceRatings[serviceIndex]['clientRating'] = rating;
        _serviceRatings[serviceIndex]['lastRatedDate'] =
            DateTime.now().toIso8601String();
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to submit rating: $e');
      _setLoading(false);
      return false;
    }
  }

  // Submit General Feedback
  Future<bool> submitGeneralFeedback({
    required String category,
    required String title,
    required String comment,
    int? rating,
    List<String>? tags,
    bool isAnonymous = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final newFeedback = {
        'id': 'feedback_${DateTime.now().millisecondsSinceEpoch}',
        'clientId': 'client_123',
        'type': 'general_feedback',
        'category': category,
        'rating': rating,
        'title': title,
        'comment': comment,
        'submittedDate': DateTime.now().toIso8601String(),
        'serviceId': null,
        'technicianId': null,
        'isAnonymous': isAnonymous,
        'status': 'pending',
        'response': null,
        'tags': tags ?? [],
      };

      _submittedFeedback.insert(0, newFeedback);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to submit feedback: $e');
      _setLoading(false);
      return false;
    }
  }

  // Start Survey
  Future<bool> startSurvey(String surveyId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final survey = _availableSurveys.firstWhere(
        (s) => s['id'] == surveyId,
        orElse: () => {},
      );

      if (survey.isEmpty) {
        _setError('Survey not found');
        _setLoading(false);
        return false;
      }

      if (survey['isCompleted']) {
        _setError('Survey already completed');
        _setLoading(false);
        return false;
      }

      _activeSurvey = survey;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to start survey: $e');
      _setLoading(false);
      return false;
    }
  }

  // Submit Survey Response
  Future<bool> submitSurveyResponse({
    required String surveyId,
    required Map<String, dynamic> responses,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final surveyIndex =
          _availableSurveys.indexWhere((s) => s['id'] == surveyId);

      if (surveyIndex == -1) {
        _setError('Survey not found');
        _setLoading(false);
        return false;
      }

      // Mark survey as completed
      _availableSurveys[surveyIndex]['isCompleted'] = true;
      _availableSurveys[surveyIndex]['completedDate'] =
          DateTime.now().toIso8601String();
      _availableSurveys[surveyIndex]['responses'] = responses;

      // Clear active survey
      _activeSurvey = null;

      // Add to feedback history
      final surveyFeedback = {
        'id': 'feedback_${DateTime.now().millisecondsSinceEpoch}',
        'clientId': 'client_123',
        'type': 'survey_response',
        'category': _availableSurveys[surveyIndex]['category'],
        'rating': responses['overall_rating'],
        'title': 'Survey: ${_availableSurveys[surveyIndex]['title']}',
        'comment': 'Survey response submitted',
        'submittedDate': DateTime.now().toIso8601String(),
        'serviceId': null,
        'technicianId': null,
        'isAnonymous': false,
        'status': 'completed',
        'response': null,
        'tags': ['survey'],
        'surveyId': surveyId,
        'surveyResponses': responses,
      };

      _submittedFeedback.insert(0, surveyFeedback);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to submit survey response: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get Feedback by Category
  List<Map<String, dynamic>> getFeedbackByCategory(String category) {
    return _submittedFeedback
        .where((feedback) => feedback['category'] == category)
        .toList();
  }

  // Get Feedback by Rating
  List<Map<String, dynamic>> getFeedbackByRating(int rating) {
    return _submittedFeedback
        .where((feedback) => feedback['rating'] == rating)
        .toList();
  }

  // Get Pending Feedback (awaiting response)
  List<Map<String, dynamic>> getPendingFeedback() {
    return _submittedFeedback
        .where((feedback) => feedback['status'] == 'pending')
        .toList();
  }

  // Get Available Categories
  List<String> getFeedbackCategories() {
    return [
      'internet_service',
      'customer_support',
      'mobile_app',
      'technical_support',
      'billing',
      'installation_service',
      'general',
    ];
  }

  // Calculate Client Satisfaction Score
  double getClientSatisfactionScore() {
    if (_submittedFeedback.isEmpty) return 0.0;

    final ratingsOnly = _submittedFeedback
        .where((feedback) => feedback['rating'] != null)
        .map((feedback) => feedback['rating'] as int)
        .toList();

    if (ratingsOnly.isEmpty) return 0.0;

    final average = ratingsOnly.reduce((a, b) => a + b) / ratingsOnly.length;
    return double.parse(average.toStringAsFixed(1));
  }

  // Get Recent Feedback (last 30 days)
  List<Map<String, dynamic>> getRecentFeedback() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    return _submittedFeedback.where((feedback) {
      final submittedDate = DateTime.parse(feedback['submittedDate']);
      return submittedDate.isAfter(thirtyDaysAgo);
    }).toList();
  }

  // Private helper methods
  String _generateFeedbackTitle(int rating) {
    switch (rating) {
      case 5:
        return 'Excellent Service Experience';
      case 4:
        return 'Good Service Experience';
      case 3:
        return 'Average Service Experience';
      case 2:
        return 'Below Average Experience';
      case 1:
        return 'Poor Service Experience';
      default:
        return 'Service Feedback';
    }
  }

  // Toggle feedback submission
  void toggleFeedbackSubmission(bool enabled) {
    _feedbackSubmissionEnabled = enabled;
    notifyListeners();
  }

  // Toggle anonymous feedback
  void toggleAnonymousFeedback(bool enabled) {
    _anonymousFeedbackEnabled = enabled;
    notifyListeners();
  }

  // Get statistics
  Map<String, dynamic> getFeedbackStatistics() {
    final totalFeedback = _submittedFeedback.length;
    final averageRating = getClientSatisfactionScore();
    final pendingCount = getPendingFeedback().length;
    final recentCount = getRecentFeedback().length;

    return {
      'totalSubmitted': totalFeedback,
      'averageRating': averageRating,
      'pendingResponses': pendingCount,
      'recentFeedback': recentCount,
      'availableSurveys':
          _availableSurveys.where((s) => !s['isCompleted']).length,
    };
  }
}
