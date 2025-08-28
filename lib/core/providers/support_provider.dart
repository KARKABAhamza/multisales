import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/support_ticket.dart';
import '../models/faq_item.dart';

/// Support and ticketing provider for MultiSales app
/// Manages customer support tickets, FAQ system, and help resources
class SupportProvider with ChangeNotifier {
  final FirestoreService _firestoreService;

  // Tickets
  List<SupportTicket> _userTickets = [];
  final List<SupportTicket> _allTickets = []; // For admin/support staff
  SupportTicket? _selectedTicket;

  // FAQ and Help
  List<FaqItem> _faqItems = [];
  List<String> _helpCategories = [];
  final Map<String, List<FaqItem>> _categorizedFaq = {};

  // State management
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSubmittingTicket = false;

  // Filters and search
  String _searchQuery = '';
  String _selectedPriority = 'all';
  String _selectedStatus = 'all';
  String _selectedCategory = 'all';

  SupportProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _initializeData();
  }

  // Getters
  List<SupportTicket> get userTickets => _userTickets;
  List<SupportTicket> get allTickets => _allTickets;
  SupportTicket? get selectedTicket => _selectedTicket;
  List<FaqItem> get faqItems => _faqItems;
  List<String> get helpCategories => _helpCategories;
  Map<String, List<FaqItem>> get categorizedFaq => _categorizedFaq;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSubmittingTicket => _isSubmittingTicket;

  String get searchQuery => _searchQuery;
  String get selectedPriority => _selectedPriority;
  String get selectedStatus => _selectedStatus;
  String get selectedCategory => _selectedCategory;

  // Filtered tickets
  List<SupportTicket> get filteredTickets {
    var tickets = _userTickets;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      tickets = tickets
          .where((ticket) =>
              ticket.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              ticket.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply priority filter
    if (_selectedPriority != 'all') {
      tickets = tickets
          .where((ticket) => ticket.priority == _selectedPriority)
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != 'all') {
      tickets =
          tickets.where((ticket) => ticket.status == _selectedStatus).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'all') {
      tickets = tickets
          .where((ticket) => ticket.category == _selectedCategory)
          .toList();
    }

    return tickets;
  }

  // Statistics
  Map<String, int> get ticketStats {
    return {
      'total': _userTickets.length,
      'open': _userTickets.where((t) => t.status == 'open').length,
      'in_progress':
          _userTickets.where((t) => t.status == 'in_progress').length,
      'resolved': _userTickets.where((t) => t.status == 'resolved').length,
      'closed': _userTickets.where((t) => t.status == 'closed').length,
      'high_priority': _userTickets.where((t) => t.priority == 'high').length,
    };
  }

  /// Initialize support data
  Future<void> _initializeData() async {
    await Future.wait([
      loadUserTickets(),
      loadFaqItems(),
      loadHelpCategories(),
    ]);
  }

  /// Create a new support ticket
  Future<String?> createTicket({
    required String title,
    required String description,
    required String category,
    required String priority,
    List<String>? attachments,
    String? userId,
  }) async {
    try {
      _setSubmittingTicket(true);
      _clearError();

      final now = DateTime.now();
      final ticket = SupportTicket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        category: category,
        priority: priority,
        status: 'open',
        userId:
            userId ?? 'anonymous_user_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: now,
        updatedAt: now,
        attachments: attachments ?? [],
      );

      // Save to Firestore
      final result = await _firestoreService.createDocument(
        collection: 'support_tickets',
        documentId: ticket.id,
        data: ticket.toMap(),
      );

      if (result['success'] == true) {
        // Add to local list
        _userTickets.insert(0, ticket);
        notifyListeners();
        return ticket.id;
      } else {
        _setError('Failed to save ticket: ${result['error']}');
        return null;
      }
    } catch (e) {
      _setError('Failed to create support ticket: $e');
      return null;
    } finally {
      _setSubmittingTicket(false);
    }
  }

  /// Load user's support tickets
  Future<void> loadUserTickets() async {
    try {
      _setLoading(true);
      _clearError();

      // Try to load from Firestore first
      final result =
          await _firestoreService.getCollection(collection: 'support_tickets');
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> ticketsData = result['data'];
        _userTickets =
            ticketsData.map((data) => SupportTicket.fromMap(data)).toList();
      } else {
        // Fall back to mock data if Firestore fails
        debugPrint('Failed to load tickets from Firestore: ${result['error']}');
        _userTickets = _generateMockTickets();
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load support tickets: $e');
      // Fall back to mock data on exception
      _userTickets = _generateMockTickets();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load FAQ items
  Future<void> loadFaqItems() async {
    try {
      // Try to load from Firestore first
      final result =
          await _firestoreService.getCollection(collection: 'faq_items');
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> faqData = result['data'];
        _faqItems = faqData.map((data) => FaqItem.fromMap(data)).toList();
      } else {
        // Fall back to mock data if Firestore fails
        debugPrint('Failed to load FAQ from Firestore: ${result['error']}');
        _faqItems = _generateMockFaqItems();
      }

      _organizeFaqByCategory();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load FAQ items: $e');
      // Fall back to mock data on exception
      _faqItems = _generateMockFaqItems();
      _organizeFaqByCategory();
      notifyListeners();
    }
  }

  /// Load help categories
  Future<void> loadHelpCategories() async {
    try {
      _helpCategories = [
        'Account Management',
        'Billing & Payment',
        'Technical Issues',
        'Service Setup',
        'General Questions',
        'Product Information',
        'Troubleshooting',
      ];
      notifyListeners();
    } catch (e) {
      _setError('Failed to load help categories: $e');
    }
  }

  /// Update ticket status (admin function)
  Future<void> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      final ticketIndex = _userTickets.indexWhere((t) => t.id == ticketId);
      if (ticketIndex != -1) {
        final updatedTicket = _userTickets[ticketIndex].copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );

        // Update in Firestore first
        final result = await _firestoreService.updateDocument(
          collection: 'support_tickets',
          documentId: ticketId,
          data: updatedTicket.toMap(),
        );

        if (result['success'] == true) {
          _userTickets[ticketIndex] = updatedTicket;
          notifyListeners();
        } else {
          _setError('Failed to update ticket: ${result['error']}');
        }
      }
    } catch (e) {
      _setError('Failed to update ticket status: $e');
    }
  }

  /// Add message to ticket
  Future<void> addTicketMessage({
    required String ticketId,
    required String message,
    bool isFromSupport = false,
  }) async {
    try {
      final ticketIndex = _userTickets.indexWhere((t) => t.id == ticketId);
      if (ticketIndex != -1) {
        final ticket = _userTickets[ticketIndex];
        final newMessages = List<TicketMessage>.from(ticket.messages);

        newMessages.add(TicketMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: message,
          isFromSupport: isFromSupport,
          timestamp: DateTime.now(),
          authorName: isFromSupport ? 'Support Team' : 'You',
        ));

        final updatedTicket = ticket.copyWith(
          messages: newMessages,
          updatedAt: DateTime.now(),
        );

        _userTickets[ticketIndex] = updatedTicket;

        // Update selected ticket if it's the same
        if (_selectedTicket?.id == ticketId) {
          _selectedTicket = updatedTicket;
        }

        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to add message: $e');
    }
  }

  /// Search functionality
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Filter functionality
  void setPriorityFilter(String priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedPriority = 'all';
    _selectedStatus = 'all';
    _selectedCategory = 'all';
    notifyListeners();
  }

  /// Select ticket for details view
  void selectTicket(SupportTicket ticket) {
    _selectedTicket = ticket;
    notifyListeners();
  }

  void clearSelectedTicket() {
    _selectedTicket = null;
    notifyListeners();
  }

  /// Delete a support ticket
  Future<bool> deleteTicket(String ticketId) async {
    try {
      final result = await _firestoreService.deleteDocument(
        collection: 'support_tickets',
        documentId: ticketId,
      );

      if (result['success'] == true) {
        _userTickets.removeWhere((t) => t.id == ticketId);
        if (_selectedTicket?.id == ticketId) {
          _selectedTicket = null;
        }
        notifyListeners();
        return true;
      } else {
        _setError('Failed to delete ticket: ${result['error']}');
        return false;
      }
    } catch (e) {
      _setError('Failed to delete ticket: $e');
      return false;
    }
  }

  /// Add a new FAQ item (admin function)
  Future<bool> addFaqItem(FaqItem faqItem) async {
    try {
      final result = await _firestoreService.createDocument(
        collection: 'faq_items',
        documentId: faqItem.id,
        data: faqItem.toMap(),
      );

      if (result['success'] == true) {
        _faqItems.add(faqItem);
        _organizeFaqByCategory();
        notifyListeners();
        return true;
      } else {
        _setError('Failed to add FAQ item: ${result['error']}');
        return false;
      }
    } catch (e) {
      _setError('Failed to add FAQ item: $e');
      return false;
    }
  }

  /// Update FAQ item (admin function)
  Future<bool> updateFaqItem(FaqItem faqItem) async {
    try {
      final result = await _firestoreService.updateDocument(
        collection: 'faq_items',
        documentId: faqItem.id,
        data: faqItem.toMap(),
      );

      if (result['success'] == true) {
        final index = _faqItems.indexWhere((f) => f.id == faqItem.id);
        if (index != -1) {
          _faqItems[index] = faqItem;
          _organizeFaqByCategory();
          notifyListeners();
        }
        return true;
      } else {
        _setError('Failed to update FAQ item: ${result['error']}');
        return false;
      }
    } catch (e) {
      _setError('Failed to update FAQ item: $e');
      return false;
    }
  }

  /// Organize FAQ by category
  void _organizeFaqByCategory() {
    _categorizedFaq.clear();
    for (final faq in _faqItems) {
      if (!_categorizedFaq.containsKey(faq.category)) {
        _categorizedFaq[faq.category] = [];
      }
      _categorizedFaq[faq.category]!.add(faq);
    }
  }

  /// Generate mock tickets for development
  List<SupportTicket> _generateMockTickets() {
    final now = DateTime.now();
    return [
      SupportTicket(
        id: '1',
        title: 'Internet Connection Issues',
        description: 'My internet connection keeps dropping every few hours.',
        category: 'Technical Issues',
        priority: 'high',
        status: 'open',
        userId: 'user1',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        messages: [
          TicketMessage(
            id: 'msg1',
            message:
                'My internet connection keeps dropping every few hours. This has been happening for the past 3 days.',
            isFromSupport: false,
            timestamp: now.subtract(const Duration(hours: 2)),
            authorName: 'You',
          ),
          TicketMessage(
            id: 'msg2',
            message:
                'Hello! We\'ve received your ticket and are investigating the issue. Can you please try restarting your router?',
            isFromSupport: true,
            timestamp: now.subtract(const Duration(hours: 1)),
            authorName: 'Support Team',
          ),
        ],
      ),
      SupportTicket(
        id: '2',
        title: 'Billing Question',
        description: 'I have a question about my last invoice.',
        category: 'Billing & Payment',
        priority: 'medium',
        status: 'resolved',
        userId: 'user1',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        messages: [
          TicketMessage(
            id: 'msg3',
            message:
                'I have a question about my last invoice. There seems to be an extra charge.',
            isFromSupport: false,
            timestamp: now.subtract(const Duration(days: 1)),
            authorName: 'You',
          ),
          TicketMessage(
            id: 'msg4',
            message:
                'Thank you for contacting us. The extra charge is for the premium support package you activated last month.',
            isFromSupport: true,
            timestamp: now.subtract(const Duration(hours: 6)),
            authorName: 'Billing Team',
          ),
        ],
      ),
    ];
  }

  /// Generate mock FAQ items
  List<FaqItem> _generateMockFaqItems() {
    final now = DateTime.now();
    return [
      FaqItem(
        id: '1',
        question: 'How do I reset my password?',
        answer:
            'You can reset your password by clicking the "Forgot Password" link on the login page.',
        category: 'Account Management',
        isHelpful: true,
        viewCount: 150,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      FaqItem(
        id: '2',
        question: 'What payment methods do you accept?',
        answer:
            'We accept all major credit cards, bank transfers, and digital payment methods.',
        category: 'Billing & Payment',
        isHelpful: true,
        viewCount: 120,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      FaqItem(
        id: '3',
        question: 'How do I troubleshoot connection issues?',
        answer:
            'First, try restarting your router. If the issue persists, check all cable connections.',
        category: 'Troubleshooting',
        isHelpful: true,
        viewCount: 200,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSubmittingTicket(bool submitting) {
    _isSubmittingTicket = submitting;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Refresh all data
  Future<void> refresh() async {
    await _initializeData();
  }

  @override
  void dispose() {
    _userTickets.clear();
    _allTickets.clear();
    _faqItems.clear();
    _helpCategories.clear();
    _categorizedFaq.clear();
    super.dispose();
  }
}
