import 'package:flutter/foundation.dart';

/// Communication Provider for MultiSales Client App
/// Handles live chat, WhatsApp integration, and real-time messaging
class CommunicationProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _chatConversations = [];
  Map<String, dynamic>? _activeChat;
  List<Map<String, dynamic>> _chatMessages = [];
  bool _isChatConnected = false;
  bool _isTyping = false;
  String? _typingUser;
  Map<String, dynamic>? _supportAgent;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get chatConversations => _chatConversations;
  Map<String, dynamic>? get activeChat => _activeChat;
  List<Map<String, dynamic>> get chatMessages => _chatMessages;
  bool get isChatConnected => _isChatConnected;
  bool get isTyping => _isTyping;
  String? get typingUser => _typingUser;
  Map<String, dynamic>? get supportAgent => _supportAgent;

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

  // Initialize Chat Service
  Future<bool> initializeChatService(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      _isChatConnected = true;

      // Load existing conversations
      await loadChatConversations(clientId);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize chat service: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Chat Conversations
  Future<bool> loadChatConversations(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      _chatConversations = [
        {
          'conversationId': 'conv_001',
          'type': 'support', // support, sales, technical
          'title': 'Technical Support - Internet Connection',
          'lastMessage':
              'Thank you for contacting MultiSales support. How can we help you today?',
          'lastMessageTime': DateTime.now()
              .subtract(const Duration(minutes: 5))
              .toIso8601String(),
          'unreadCount': 2,
          'status': 'active', // active, waiting, resolved, closed
          'priority': 'medium',
          'agentName': 'Fatima Alami',
          'agentId': 'agent_001',
          'agentAvatar': 'https://example.com/avatar1.jpg',
          'department': 'Technical Support',
          'isOnline': true,
        },
        {
          'conversationId': 'conv_002',
          'type': 'sales',
          'title': 'Sales Inquiry - Fiber Internet Upgrade',
          'lastMessage':
              'I\'ll prepare a customized quote for the fiber upgrade and send it to you shortly.',
          'lastMessageTime': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'unreadCount': 0,
          'status': 'waiting',
          'priority': 'high',
          'agentName': 'Ahmed Bennani',
          'agentId': 'agent_002',
          'agentAvatar': 'https://example.com/avatar2.jpg',
          'department': 'Sales',
          'isOnline': false,
        },
        {
          'conversationId': 'conv_003',
          'type': 'technical',
          'title': 'Installation Appointment - Router Setup',
          'lastMessage':
              'Your technician will arrive tomorrow between 2-4 PM. Please ensure someone is available.',
          'lastMessageTime': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'unreadCount': 1,
          'status': 'resolved',
          'priority': 'low',
          'agentName': 'Youssef Tazi',
          'agentId': 'agent_003',
          'agentAvatar': 'https://example.com/avatar3.jpg',
          'department': 'Technical Installation',
          'isOnline': true,
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load chat conversations: $e');
      _setLoading(false);
      return false;
    }
  }

  // Start New Chat Conversation
  Future<String?> startNewChat({
    required String clientId,
    required String type, // support, sales, technical
    required String subject,
    String? initialMessage,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final conversationId = 'conv_${DateTime.now().millisecondsSinceEpoch}';

      final newConversation = {
        'conversationId': conversationId,
        'type': type,
        'title': '$type - $subject',
        'lastMessage': initialMessage ?? 'Conversation started',
        'lastMessageTime': DateTime.now().toIso8601String(),
        'unreadCount': 0,
        'status': 'active',
        'priority': 'medium',
        'agentName': _getAgentForType(type)['name'],
        'agentId': _getAgentForType(type)['id'],
        'agentAvatar': _getAgentForType(type)['avatar'],
        'department': _getDepartmentForType(type),
        'isOnline': true,
      };

      _chatConversations.insert(0, newConversation);

      // Auto-assign conversation and load initial messages
      await loadChatMessages(conversationId);

      _setLoading(false);
      return conversationId;
    } catch (e) {
      _setError('Failed to start new chat: $e');
      _setLoading(false);
      return null;
    }
  }

  // Load Chat Messages for Conversation
  Future<bool> loadChatMessages(String conversationId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Set active chat
      _activeChat = _chatConversations.firstWhere(
        (conv) => conv['conversationId'] == conversationId,
        orElse: () => {},
      );

      if (_activeChat == null || _activeChat!.isEmpty) {
        _setError('Conversation not found');
        _setLoading(false);
        return false;
      }

      // Load sample messages
      _chatMessages = [
        {
          'messageId': 'msg_001',
          'conversationId': conversationId,
          'senderId': 'client_123',
          'senderName': 'You',
          'senderType': 'client',
          'message':
              'Hello, I\'m having issues with my internet connection. It keeps disconnecting.',
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 10))
              .toIso8601String(),
          'messageType': 'text',
          'isRead': true,
          'attachments': [],
        },
        {
          'messageId': 'msg_002',
          'conversationId': conversationId,
          'senderId': _activeChat!['agentId'],
          'senderName': _activeChat!['agentName'],
          'senderType': 'agent',
          'message':
              'Hello! Thank you for contacting MultiSales support. I\'m sorry to hear about the connection issues. Can you tell me how often this happens?',
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 8))
              .toIso8601String(),
          'messageType': 'text',
          'isRead': true,
          'attachments': [],
        },
        {
          'messageId': 'msg_003',
          'conversationId': conversationId,
          'senderId': 'client_123',
          'senderName': 'You',
          'senderType': 'client',
          'message':
              'It happens several times a day, especially during peak hours. The connection drops for about 2-3 minutes each time.',
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 6))
              .toIso8601String(),
          'messageType': 'text',
          'isRead': true,
          'attachments': [],
        },
        {
          'messageId': 'msg_004',
          'conversationId': conversationId,
          'senderId': _activeChat!['agentId'],
          'senderName': _activeChat!['agentName'],
          'senderType': 'agent',
          'message':
              'I understand how frustrating that must be. Let me check your connection status and run some diagnostics. This will take just a moment.',
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 5))
              .toIso8601String(),
          'messageType': 'text',
          'isRead': true,
          'attachments': [],
        },
        {
          'messageId': 'msg_005',
          'conversationId': conversationId,
          'senderId': _activeChat!['agentId'],
          'senderName': _activeChat!['agentName'],
          'senderType': 'agent',
          'message':
              'I can see some signal instability in your area. I\'ll schedule a technician to check your equipment. Would tomorrow afternoon work for you?',
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 3))
              .toIso8601String(),
          'messageType': 'text',
          'isRead': false,
          'attachments': [],
        },
      ];

      // Mark conversation as read
      _markConversationAsRead(conversationId);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load chat messages: $e');
      _setLoading(false);
      return false;
    }
  }

  // Send Chat Message
  Future<bool> sendMessage({
    required String conversationId,
    required String message,
    String messageType = 'text',
    List<String>? attachments,
  }) async {
    if (message.trim().isEmpty) return false;

    try {
      final newMessage = {
        'messageId': 'msg_${DateTime.now().millisecondsSinceEpoch}',
        'conversationId': conversationId,
        'senderId': 'client_123',
        'senderName': 'You',
        'senderType': 'client',
        'message': message.trim(),
        'timestamp': DateTime.now().toIso8601String(),
        'messageType': messageType,
        'isRead': true,
        'attachments': attachments ?? [],
      };

      _chatMessages.add(newMessage);

      // Update conversation's last message
      _updateConversationLastMessage(conversationId, message.trim());

      notifyListeners();

      // Simulate agent response after a delay
      _simulateAgentResponse(conversationId);

      return true;
    } catch (e) {
      _setError('Failed to send message: $e');
      return false;
    }
  }

  // Open WhatsApp Chat
  Future<bool> openWhatsAppChat({String? phoneNumber, String? message}) async {
    try {
      final phone =
          phoneNumber ?? '+212522123456'; // Default MultiSales WhatsApp
      final text =
          message ?? 'Hello, I need assistance with my MultiSales services.';

      // In a real app, this would use url_launcher to open WhatsApp
      final whatsappUrl =
          'https://wa.me/$phone?text=${Uri.encodeComponent(text)}';

      // Simulate opening WhatsApp
      await Future.delayed(const Duration(milliseconds: 300));

      debugPrint('Opening WhatsApp: $whatsappUrl');
      return true;
    } catch (e) {
      _setError('Failed to open WhatsApp: $e');
      return false;
    }
  }

  // Set Typing Status
  void setTypingStatus(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  // Close Chat Conversation
  Future<bool> closeChatConversation(String conversationId) async {
    try {
      final conversationIndex = _chatConversations.indexWhere(
        (conv) => conv['conversationId'] == conversationId,
      );

      if (conversationIndex != -1) {
        _chatConversations[conversationIndex]['status'] = 'closed';

        if (_activeChat?['conversationId'] == conversationId) {
          _activeChat = null;
          _chatMessages.clear();
        }

        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError('Failed to close conversation: $e');
      return false;
    }
  }

  // Get Quick Replies
  List<String> getQuickReplies(String conversationType) {
    switch (conversationType) {
      case 'support':
        return [
          'Yes, that works for me',
          'No, I need a different time',
          'Can you explain more?',
          'The problem is still occurring',
          'Thank you for your help',
        ];
      case 'sales':
        return [
          'I\'m interested',
          'What\'s the price?',
          'Can I get a quote?',
          'When can we schedule a call?',
          'I need more information',
        ];
      case 'technical':
        return [
          'Yes, the technician can come',
          'I need to reschedule',
          'What should I prepare?',
          'How long will it take?',
          'Is there anything else I need to know?',
        ];
      default:
        return ['Yes', 'No', 'Thank you', 'I understand'];
    }
  }

  // Private helper methods
  Map<String, dynamic> _getAgentForType(String type) {
    switch (type) {
      case 'support':
        return {
          'id': 'agent_001',
          'name': 'Fatima Alami',
          'avatar': 'https://example.com/avatar1.jpg'
        };
      case 'sales':
        return {
          'id': 'agent_002',
          'name': 'Ahmed Bennani',
          'avatar': 'https://example.com/avatar2.jpg'
        };
      case 'technical':
        return {
          'id': 'agent_003',
          'name': 'Youssef Tazi',
          'avatar': 'https://example.com/avatar3.jpg'
        };
      default:
        return {
          'id': 'agent_001',
          'name': 'Support Agent',
          'avatar': 'https://example.com/avatar1.jpg'
        };
    }
  }

  String _getDepartmentForType(String type) {
    switch (type) {
      case 'support':
        return 'Customer Support';
      case 'sales':
        return 'Sales';
      case 'technical':
        return 'Technical Support';
      default:
        return 'General Support';
    }
  }

  void _markConversationAsRead(String conversationId) {
    final conversationIndex = _chatConversations.indexWhere(
      (conv) => conv['conversationId'] == conversationId,
    );

    if (conversationIndex != -1) {
      _chatConversations[conversationIndex]['unreadCount'] = 0;
    }
  }

  void _updateConversationLastMessage(String conversationId, String message) {
    final conversationIndex = _chatConversations.indexWhere(
      (conv) => conv['conversationId'] == conversationId,
    );

    if (conversationIndex != -1) {
      _chatConversations[conversationIndex]['lastMessage'] = message;
      _chatConversations[conversationIndex]['lastMessageTime'] =
          DateTime.now().toIso8601String();
    }
  }

  void _simulateAgentResponse(String conversationId) {
    Future.delayed(const Duration(seconds: 2), () {
      if (_activeChat?['conversationId'] == conversationId) {
        final responses = [
          'Thank you for the information. Let me check that for you.',
          'I understand. Let me process this request.',
          'That\'s a great question. I\'ll look into it right away.',
          'I\'ll need to verify this with our technical team.',
          'Perfect! I\'ll update your account accordingly.',
        ];

        final randomResponse =
            responses[DateTime.now().second % responses.length];

        final agentMessage = {
          'messageId': 'msg_${DateTime.now().millisecondsSinceEpoch}',
          'conversationId': conversationId,
          'senderId': _activeChat!['agentId'],
          'senderName': _activeChat!['agentName'],
          'senderType': 'agent',
          'message': randomResponse,
          'timestamp': DateTime.now().toIso8601String(),
          'messageType': 'text',
          'isRead': false,
          'attachments': [],
        };

        _chatMessages.add(agentMessage);
        _updateConversationLastMessage(conversationId, randomResponse);
        notifyListeners();
      }
    });
  }

  // Get total unread messages count
  int getTotalUnreadCount() {
    return _chatConversations.fold(
        0, (total, conv) => total + (conv['unreadCount'] as int));
  }

  // Disconnect chat service
  void disconnectChat() {
    _isChatConnected = false;
    _activeChat = null;
    _chatMessages.clear();
    _isTyping = false;
    _typingUser = null;
    notifyListeners();
  }
}
