import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

/// Provider for managing real-time chat and communication features
/// Handles direct messages, group chats, file sharing, and notifications
class CommunicationProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  // State management
  bool _isLoading = false;
  String? _errorMessage;
  bool _isTyping = false;

  // Chat data
  List<ChatConversation> _conversations = [];
  List<ChatMessage> _currentMessages = [];
  ChatConversation? _activeConversation;
  String? _currentUserId;

  // Real-time subscriptions
  Stream<QuerySnapshot>? _conversationsStream;
  Stream<QuerySnapshot>? _messagesStream;

  // File sharing
  bool _isUploadingFile = false;
  double _uploadProgress = 0.0;

  CommunicationProvider({
    FirestoreService? firestoreService,
    StorageService? storageService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _storageService = storageService ?? StorageService();

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isTyping => _isTyping;
  List<ChatConversation> get conversations => List.unmodifiable(_conversations);
  List<ChatMessage> get currentMessages => List.unmodifiable(_currentMessages);
  ChatConversation? get activeConversation => _activeConversation;
  bool get isUploadingFile => _isUploadingFile;
  double get uploadProgress => _uploadProgress;

  /// Initialize the communication provider with user ID
  Future<void> initialize(String userId) async {
    _currentUserId = userId;
    await _loadConversations();
    _setupConversationsListener();
  }

  /// Create a new conversation
  Future<void> createConversation({
    required List<String> participantIds,
    required String title,
    bool isGroup = false,
    String? description,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_currentUserId == null) {
        throw Exception('User not initialized');
      }

      // Add current user to participants if not already included
      final allParticipants = Set<String>.from(participantIds);
      allParticipants.add(_currentUserId!);

      final conversation = ChatConversation(
        id: '',
        title: title,
        description: description,
        participants: allParticipants.toList(),
        isGroup: isGroup,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: _currentUserId!,
        lastMessage: null,
        unreadCount: {},
      );

      final docRef =
          FirebaseFirestore.instance.collection('chat_conversations').doc();

      final conversationWithId = conversation.copyWith(id: docRef.id);

      await docRef.set(conversationWithId.toJson());

      await _loadConversations();
    } catch (e) {
      _setError('Failed to create conversation: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Send a message to the active conversation
  Future<void> sendMessage({
    required String content,
    ChatMessageType type = ChatMessageType.text,
    String? fileUrl,
    String? fileName,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      if (_activeConversation == null || _currentUserId == null) {
        throw Exception('No active conversation or user not initialized');
      }

      final message = ChatMessage(
        id: '',
        conversationId: _activeConversation!.id,
        senderId: _currentUserId!,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        fileUrl: fileUrl,
        fileName: fileName,
        metadata: metadata ?? {},
        readBy: {_currentUserId!: DateTime.now()},
      );

      final docRef =
          FirebaseFirestore.instance.collection('chat_messages').doc();

      final messageWithId = message.copyWith(id: docRef.id);

      await docRef.set(messageWithId.toJson());

      // Update conversation's last message and timestamp
      await FirebaseFirestore.instance
          .collection('chat_conversations')
          .doc(_activeConversation!.id)
          .update({
        'lastMessage': messageWithId.toJson(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Send push notifications to other participants
      await _sendNotificationsToParticipants(message);
    } catch (e) {
      _setError('Failed to send message: $e');
    }
  }

  /// Load conversation by ID and set as active
  Future<void> loadConversation(String conversationId) async {
    try {
      _setLoading(true);
      _setError(null);

      final conversationDoc = await _firestoreService.getDocument(
        collection: 'chat_conversations',
        documentId: conversationId,
      );

      if (conversationDoc['success'] == true &&
          conversationDoc['data'] != null) {
        _activeConversation = ChatConversation.fromJson({
          'id': conversationId,
          ...conversationDoc['data'] as Map<String, dynamic>,
        });

        // Mark messages as read
        await _markMessagesAsRead(conversationId);

        // Setup messages listener
        _setupMessagesListener(conversationId);

        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load conversation: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Mark messages as read in a conversation
  Future<void> markMessagesAsRead(String conversationId) async {
    await _markMessagesAsRead(conversationId);
  }

  /// Update typing indicator
  Future<void> updateTypingStatus(bool isTyping) async {
    _isTyping = isTyping;
    notifyListeners();

    if (_activeConversation != null && _currentUserId != null) {
      try {
        await _firestoreService.updateDocument(
          collection: 'chat_typing',
          documentId: '${_activeConversation!.id}_$_currentUserId',
          data: {
            'conversationId': _activeConversation!.id,
            'userId': _currentUserId!,
            'isTyping': isTyping,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      } catch (e) {
        // Ignore typing errors
      }
    }
  }

  /// Upload a file and send as message
  Future<void> uploadFileMessage({
    required String filePath,
    required String fileName,
    ChatMessageType? type,
    String? content,
  }) async {
    try {
      if (_activeConversation == null || _currentUserId == null) {
        throw Exception('No active conversation or user not initialized');
      }

      _isUploadingFile = true;
      _uploadProgress = 0.0;
      notifyListeners();

      // Determine file type if not provided
      final messageType = type ?? _getFileTypeFromExtension(fileName);

      // Upload file to Firebase Storage
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }

      final storagePath =
          'chat_files/${_activeConversation!.id}/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // Track upload progress (simplified - Firebase Storage has built-in progress tracking)
      _uploadProgress = 0.1;
      notifyListeners();

      final fileUrl = await _storageService.uploadFile(storagePath, file);

      if (fileUrl == null) {
        throw Exception('Failed to upload file to storage');
      }

      _uploadProgress = 1.0;
      notifyListeners();

      // Send message with file
      await sendMessage(
        content: content ?? 'Shared a file: $fileName',
        type: messageType,
        fileUrl: fileUrl,
        fileName: fileName,
        metadata: {
          'originalPath': filePath,
          'uploadTimestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      _setError('Failed to upload file: $e');
    } finally {
      _isUploadingFile = false;
      _uploadProgress = 0.0;
      notifyListeners();
    }
  }

  /// Cancel ongoing file upload
  void cancelFileUpload() {
    if (_isUploadingFile) {
      _isUploadingFile = false;
      _uploadProgress = 0.0;
      notifyListeners();
    }
  }

  /// Get file type from extension
  ChatMessageType _getFileTypeFromExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return ChatMessageType.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
        return ChatMessageType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'm4a':
        return ChatMessageType.audio;
      default:
        return ChatMessageType.file;
    }
  }

  /// Quick upload for images
  Future<void> uploadImageMessage(String imagePath, String fileName) async {
    await uploadFileMessage(
      filePath: imagePath,
      fileName: fileName,
      type: ChatMessageType.image,
      content: '📷 Shared an image',
    );
  }

  /// Quick upload for videos
  Future<void> uploadVideoMessage(String videoPath, String fileName) async {
    await uploadFileMessage(
      filePath: videoPath,
      fileName: fileName,
      type: ChatMessageType.video,
      content: '🎥 Shared a video',
    );
  }

  /// Delete a file from storage
  Future<bool> deleteFileFromStorage(String fileUrl) async {
    try {
      // Extract storage path from URL
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;
      final storagePath =
          pathSegments.skip(1).join('/'); // Skip 'v0/b/bucket/o/'

      return await _storageService.deleteFile(storagePath);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting file from storage: $e');
      }
      return false;
    }
  }

  /// Delete a message and its associated file
  Future<void> deleteMessage(String messageId, ChatMessage message) async {
    try {
      // Delete file from storage if it exists
      if (message.fileUrl != null) {
        await deleteFileFromStorage(message.fileUrl!);
      }

      // Delete message from Firestore
      await FirebaseFirestore.instance
          .collection('chat_messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      _setError('Failed to delete message: $e');
    }
  }

  /// Search conversations and messages
  Future<List<ChatSearchResult>> searchChats(String query) async {
    try {
      if (query.length < 2) return [];

      final results = <ChatSearchResult>[];

      // Search conversations
      final conversationDocs = await FirebaseFirestore.instance
          .collection('chat_conversations')
          .where('participants', arrayContains: _currentUserId)
          .get();

      for (final doc in conversationDocs.docs) {
        final conversation = ChatConversation.fromJson({
          'id': doc.id,
          ...doc.data(),
        });

        if (conversation.title.toLowerCase().contains(query.toLowerCase())) {
          results.add(ChatSearchResult(
            type: ChatSearchResultType.conversation,
            conversation: conversation,
            message: null,
            relevanceScore: 1.0,
          ));
        }
      }

      // Search messages
      final messageDocs = await FirebaseFirestore.instance
          .collection('chat_messages')
          .where('content', isGreaterThanOrEqualTo: query)
          .where('content', isLessThan: '$query\uf8ff')
          .limit(20)
          .get();

      for (final doc in messageDocs.docs) {
        final message = ChatMessage.fromJson({
          'id': doc.id,
          ...doc.data(),
        });

        // Check if user is participant in this conversation
        final conversationDoc = await _firestoreService.getDocument(
          collection: 'chat_conversations',
          documentId: message.conversationId,
        );

        if (conversationDoc['success'] == true &&
            conversationDoc['data'] != null) {
          final conversation = ChatConversation.fromJson({
            'id': message.conversationId,
            ...conversationDoc['data'] as Map<String, dynamic>,
          });

          if (conversation.participants.contains(_currentUserId)) {
            results.add(ChatSearchResult(
              type: ChatSearchResultType.message,
              conversation: conversation,
              message: message,
              relevanceScore: 0.8,
            ));
          }
        }
      }

      // Sort by relevance
      results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
      return results;
    } catch (e) {
      _setError('Search failed: $e');
      return [];
    }
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> _loadConversations() async {
    try {
      if (_currentUserId == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_conversations')
          .where('participants', arrayContains: _currentUserId)
          .orderBy('updatedAt', descending: true)
          .get();

      _conversations = querySnapshot.docs
          .map((doc) => ChatConversation.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load conversations: $e');
    }
  }

  void _setupConversationsListener() {
    if (_currentUserId == null) return;

    _conversationsStream = FirebaseFirestore.instance
        .collection('chat_conversations')
        .where('participants', arrayContains: _currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots();

    _conversationsStream!.listen(
      (snapshot) {
        _conversations = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return ChatConversation.fromJson({
            'id': doc.id,
            if (data != null) ...data,
          });
        }).toList();
        notifyListeners();
      },
      onError: (error) {
        _setError('Real-time conversations failed: $error');
      },
    );
  }

  void _setupMessagesListener(String conversationId) {
    _messagesStream = FirebaseFirestore.instance
        .collection('chat_messages')
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots();

    _messagesStream!.listen(
      (snapshot) {
        _currentMessages = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return ChatMessage.fromJson({
            'id': doc.id,
            if (data != null) ...data,
          });
        }).toList();
        notifyListeners();
      },
      onError: (error) {
        _setError('Real-time messages failed: $error');
      },
    );
  }

  Future<void> _markMessagesAsRead(String conversationId) async {
    try {
      if (_currentUserId == null) return;

      final unreadMessages = await FirebaseFirestore.instance
          .collection('chat_messages')
          .where('conversationId', isEqualTo: conversationId)
          .where('readBy.$_currentUserId', isNull: true)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {
          'readBy.$_currentUserId': DateTime.now().toIso8601String(),
        });
      }

      await batch.commit();
    } catch (e) {
      // Ignore read status errors
    }
  }

  Future<void> _sendNotificationsToParticipants(ChatMessage message) async {
    try {
      if (_activeConversation == null) return;

      final otherParticipants = _activeConversation!.participants
          .where((id) => id != _currentUserId)
          .toList();

      for (final participantId in otherParticipants) {
        // Note: Push notifications will be implemented when notification service is enhanced
        // This would integrate with FCM to send real-time notifications to participants
        if (kDebugMode) {
          print('📱 Would send notification to $participantId: '
              '${_activeConversation!.isGroup ? _activeConversation!.title : 'New Message'} - '
              '${message.type == ChatMessageType.text ? message.content : 'Sent a ${message.type.name}'}');
        }
      }
    } catch (e) {
      // Ignore notification errors
    }
  }

  @override
  void dispose() {
    // Clean up streams
    super.dispose();
  }
}

/// Chat conversation model
class ChatConversation {
  final String id;
  final String title;
  final String? description;
  final List<String> participants;
  final bool isGroup;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final ChatMessage? lastMessage;
  final Map<String, int> unreadCount;

  ChatConversation({
    required this.id,
    required this.title,
    this.description,
    required this.participants,
    required this.isGroup,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.lastMessage,
    required this.unreadCount,
  });

  ChatConversation copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? participants,
    bool? isGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    ChatMessage? lastMessage,
    Map<String, int>? unreadCount,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      participants: participants ?? this.participants,
      isGroup: isGroup ?? this.isGroup,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      participants: List<String>.from(json['participants'] ?? []),
      isGroup: json['isGroup'] ?? false,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      createdBy: json['createdBy'] ?? '',
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'participants': participants,
      'isGroup': isGroup,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
    };
  }
}

/// Chat message model
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final ChatMessageType type;
  final DateTime timestamp;
  final String? fileUrl;
  final String? fileName;
  final Map<String, dynamic> metadata;
  final Map<String, DateTime> readBy;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.fileUrl,
    this.fileName,
    required this.metadata,
    required this.readBy,
  });

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    ChatMessageType? type,
    DateTime? timestamp,
    String? fileUrl,
    String? fileName,
    Map<String, dynamic>? metadata,
    Map<String, DateTime>? readBy,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      metadata: metadata ?? this.metadata,
      readBy: readBy ?? this.readBy,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      type: ChatMessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChatMessageType.text,
      ),
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      readBy: (json['readBy'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, DateTime.parse(value)),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'fileUrl': fileUrl,
      'fileName': fileName,
      'metadata': metadata,
      'readBy':
          readBy.map((key, value) => MapEntry(key, value.toIso8601String())),
    };
  }
}

/// Message types
enum ChatMessageType {
  text,
  image,
  file,
  video,
  audio,
  location,
  system,
}

/// Search result model
class ChatSearchResult {
  final ChatSearchResultType type;
  final ChatConversation conversation;
  final ChatMessage? message;
  final double relevanceScore;

  ChatSearchResult({
    required this.type,
    required this.conversation,
    this.message,
    required this.relevanceScore,
  });
}

enum ChatSearchResultType {
  conversation,
  message,
}
