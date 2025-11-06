import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

/// Appointment status enum
enum AppointmentStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled
}

/// Appointment type enum
enum AppointmentType {
  consultation,
  demonstration,
  meeting,
  training,
  support,
  followUp,
  onboarding,
  review
}

/// Priority level for appointments
enum AppointmentPriority { low, medium, high, urgent }

/// Reminder settings for appointments
class AppointmentReminder {
  final String id;
  final Duration beforeAppointment;
  final bool isEnabled;
  final String method; // 'push', 'email', 'sms'
  final String? customMessage;

  AppointmentReminder({
    required this.id,
    required this.beforeAppointment,
    required this.isEnabled,
    required this.method,
    this.customMessage,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'beforeAppointmentMinutes': beforeAppointment.inMinutes,
        'isEnabled': isEnabled,
        'method': method,
        'customMessage': customMessage,
      };

  factory AppointmentReminder.fromMap(Map<String, dynamic> map) =>
      AppointmentReminder(
        id: map['id'] ?? '',
        beforeAppointment:
            Duration(minutes: map['beforeAppointmentMinutes'] ?? 0),
        isEnabled: map['isEnabled'] ?? false,
        method: map['method'] ?? 'push',
        customMessage: map['customMessage'],
      );
}

/// Appointment model
class Appointment {
  final String id;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final DateTime startTime;
  final DateTime endTime;
  final String organizerId;
  final List<String> participantIds;
  final String? locationId;
  final String? locationName;
  final String? locationAddress;
  final double? latitude;
  final double? longitude;
  final bool isVirtual;
  final String? meetingLink;
  final String? meetingPassword;
  final AppointmentType type;
  final AppointmentStatus status;
  final AppointmentPriority priority;
  final List<AppointmentReminder> reminders;
  final Map<String, dynamic> metadata;
  final List<String> attachmentUrls;
  final String? notes;
  final String? cancellationReason;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? lastModifiedBy;

  Appointment({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.startTime,
    required this.endTime,
    required this.organizerId,
    required this.participantIds,
    this.locationId,
    this.locationName,
    this.locationAddress,
    this.latitude,
    this.longitude,
    required this.isVirtual,
    this.meetingLink,
    this.meetingPassword,
    required this.type,
    required this.status,
    required this.priority,
    required this.reminders,
    required this.metadata,
    required this.attachmentUrls,
    this.notes,
    this.cancellationReason,
    this.actualStartTime,
    this.actualEndTime,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.lastModifiedBy,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'scheduledDate': Timestamp.fromDate(scheduledDate),
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'organizerId': organizerId,
        'participantIds': participantIds,
        'locationId': locationId,
        'locationName': locationName,
        'locationAddress': locationAddress,
        'latitude': latitude,
        'longitude': longitude,
        'isVirtual': isVirtual,
        'meetingLink': meetingLink,
        'meetingPassword': meetingPassword,
        'type': type.toString().split('.').last,
        'status': status.toString().split('.').last,
        'priority': priority.toString().split('.').last,
        'reminders': reminders.map((r) => r.toMap()).toList(),
        'metadata': metadata,
        'attachmentUrls': attachmentUrls,
        'notes': notes,
        'cancellationReason': cancellationReason,
        'actualStartTime': actualStartTime != null
            ? Timestamp.fromDate(actualStartTime!)
            : null,
        'actualEndTime':
            actualEndTime != null ? Timestamp.fromDate(actualEndTime!) : null,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'createdBy': createdBy,
        'lastModifiedBy': lastModifiedBy,
      };

  factory Appointment.fromMap(Map<String, dynamic> map, String documentId) =>
      Appointment(
        id: documentId,
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        scheduledDate: (map['scheduledDate'] as Timestamp).toDate(),
        startTime: (map['startTime'] as Timestamp).toDate(),
        endTime: (map['endTime'] as Timestamp).toDate(),
        organizerId: map['organizerId'] ?? '',
        participantIds: List<String>.from(map['participantIds'] ?? []),
        locationId: map['locationId'],
        locationName: map['locationName'],
        locationAddress: map['locationAddress'],
        latitude: map['latitude']?.toDouble(),
        longitude: map['longitude']?.toDouble(),
        isVirtual: map['isVirtual'] ?? false,
        meetingLink: map['meetingLink'],
        meetingPassword: map['meetingPassword'],
        type: AppointmentType.values.firstWhere(
          (e) => e.toString().split('.').last == map['type'],
          orElse: () => AppointmentType.meeting,
        ),
        status: AppointmentStatus.values.firstWhere(
          (e) => e.toString().split('.').last == map['status'],
          orElse: () => AppointmentStatus.scheduled,
        ),
        priority: AppointmentPriority.values.firstWhere(
          (e) => e.toString().split('.').last == map['priority'],
          orElse: () => AppointmentPriority.medium,
        ),
        reminders: (map['reminders'] as List<dynamic>?)
                ?.map((r) => AppointmentReminder.fromMap(r))
                .toList() ??
            [],
        metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
        attachmentUrls: List<String>.from(map['attachmentUrls'] ?? []),
        notes: map['notes'],
        cancellationReason: map['cancellationReason'],
        actualStartTime: map['actualStartTime'] != null
            ? (map['actualStartTime'] as Timestamp).toDate()
            : null,
        actualEndTime: map['actualEndTime'] != null
            ? (map['actualEndTime'] as Timestamp).toDate()
            : null,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        updatedAt: (map['updatedAt'] as Timestamp).toDate(),
        createdBy: map['createdBy'] ?? '',
        lastModifiedBy: map['lastModifiedBy'],
      );

  Appointment copyWith({
    String? title,
    String? description,
    DateTime? scheduledDate,
    DateTime? startTime,
    DateTime? endTime,
    String? organizerId,
    List<String>? participantIds,
    String? locationId,
    String? locationName,
    String? locationAddress,
    double? latitude,
    double? longitude,
    bool? isVirtual,
    String? meetingLink,
    String? meetingPassword,
    AppointmentType? type,
    AppointmentStatus? status,
    AppointmentPriority? priority,
    List<AppointmentReminder>? reminders,
    Map<String, dynamic>? metadata,
    List<String>? attachmentUrls,
    String? notes,
    String? cancellationReason,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    String? lastModifiedBy,
  }) {
    return Appointment(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      organizerId: organizerId ?? this.organizerId,
      participantIds: participantIds ?? this.participantIds,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isVirtual: isVirtual ?? this.isVirtual,
      meetingLink: meetingLink ?? this.meetingLink,
      meetingPassword: meetingPassword ?? this.meetingPassword,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      reminders: reminders ?? this.reminders,
      metadata: metadata ?? this.metadata,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
    );
  }
}

/// Time slot for scheduling
class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final String? bookedBy;
  final String? appointmentId;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.bookedBy,
    this.appointmentId,
  });
}

/// Calendar settings model
class CalendarSettings {
  final String userId;
  final Map<int, List<TimeSlot>>
      workingHours; // Day of week (1-7) -> time slots
  final List<DateTime> blockedDates;
  final Duration defaultAppointmentDuration;
  final Duration bufferTime;
  final bool allowBackToBackBookings;
  final int maxAdvanceBookingDays;
  final int minAdvanceBookingHours;
  final Map<AppointmentType, Duration> appointmentTypeDurations;

  CalendarSettings({
    required this.userId,
    required this.workingHours,
    required this.blockedDates,
    required this.defaultAppointmentDuration,
    required this.bufferTime,
    required this.allowBackToBackBookings,
    required this.maxAdvanceBookingDays,
    required this.minAdvanceBookingHours,
    required this.appointmentTypeDurations,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'workingHours': workingHours.map((day, slots) => MapEntry(
              day.toString(),
              slots
                  .map((slot) => {
                        'startTime': slot.startTime.toIso8601String(),
                        'endTime': slot.endTime.toIso8601String(),
                        'isAvailable': slot.isAvailable,
                        'bookedBy': slot.bookedBy,
                        'appointmentId': slot.appointmentId,
                      })
                  .toList(),
            )),
        'blockedDates':
            blockedDates.map((date) => Timestamp.fromDate(date)).toList(),
        'defaultAppointmentDurationMinutes':
            defaultAppointmentDuration.inMinutes,
        'bufferTimeMinutes': bufferTime.inMinutes,
        'allowBackToBackBookings': allowBackToBackBookings,
        'maxAdvanceBookingDays': maxAdvanceBookingDays,
        'minAdvanceBookingHours': minAdvanceBookingHours,
        'appointmentTypeDurations': appointmentTypeDurations.map(
          (type, duration) => MapEntry(
            type.toString().split('.').last,
            duration.inMinutes,
          ),
        ),
      };

  factory CalendarSettings.fromMap(Map<String, dynamic> map) =>
      CalendarSettings(
        userId: map['userId'] ?? '',
        workingHours: (map['workingHours'] as Map<String, dynamic>? ?? {}).map(
          (day, slots) => MapEntry(
            int.parse(day),
            (slots as List<dynamic>)
                .map((slot) => TimeSlot(
                      startTime: DateTime.parse(slot['startTime']),
                      endTime: DateTime.parse(slot['endTime']),
                      isAvailable: slot['isAvailable'] ?? true,
                      bookedBy: slot['bookedBy'],
                      appointmentId: slot['appointmentId'],
                    ))
                .toList(),
          ),
        ),
        blockedDates: (map['blockedDates'] as List<dynamic>?)
                ?.map((timestamp) => (timestamp as Timestamp).toDate())
                .toList() ??
            [],
        defaultAppointmentDuration:
            Duration(minutes: map['defaultAppointmentDurationMinutes'] ?? 60),
        bufferTime: Duration(minutes: map['bufferTimeMinutes'] ?? 15),
        allowBackToBackBookings: map['allowBackToBackBookings'] ?? false,
        maxAdvanceBookingDays: map['maxAdvanceBookingDays'] ?? 30,
        minAdvanceBookingHours: map['minAdvanceBookingHours'] ?? 24,
        appointmentTypeDurations:
            (map['appointmentTypeDurations'] as Map<String, dynamic>? ?? {})
                .map(
          (typeStr, durationMinutes) => MapEntry(
            AppointmentType.values.firstWhere(
              (e) => e.toString().split('.').last == typeStr,
              orElse: () => AppointmentType.meeting,
            ),
            Duration(minutes: durationMinutes),
          ),
        ),
      );
}

/// Provider for appointments and scheduling functionality
class AppointmentProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  // Note: NotificationService methods not implemented yet, using placeholders

  // State management
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUserId;

  // Appointments data
  List<Appointment> _appointments = [];
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _todayAppointments = [];
  final Map<String, List<Appointment>> _appointmentsByDate = {};
  CalendarSettings? _calendarSettings;

  // Filters and view settings
  DateTime _selectedDate = DateTime.now();
  List<AppointmentStatus> _statusFilters = AppointmentStatus.values;
  List<AppointmentType> _typeFilters = AppointmentType.values;
  AppointmentPriority? _priorityFilter;
  String _searchQuery = '';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Appointment> get appointments => _appointments;
  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Appointment> get todayAppointments => _todayAppointments;
  Map<String, List<Appointment>> get appointmentsByDate => _appointmentsByDate;
  CalendarSettings? get calendarSettings => _calendarSettings;
  DateTime get selectedDate => _selectedDate;
  List<AppointmentStatus> get statusFilters => _statusFilters;
  List<AppointmentType> get typeFilters => _typeFilters;
  AppointmentPriority? get priorityFilter => _priorityFilter;
  String get searchQuery => _searchQuery;

  AppointmentProvider({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  /// Initialize the appointment provider
  Future<void> initialize(String userId) async {
    _currentUserId = userId;
    await Future.wait([
      loadAppointments(),
      loadCalendarSettings(),
    ]);
  }

  /// Load appointments for the current user
  Future<void> loadAppointments() async {
    if (_currentUserId == null) return;

    _setLoading(true);
    try {
      // Load appointments where user is organizer
      final organizerQuery = FirebaseFirestore.instance
          .collection('appointments')
          .where('organizerId', isEqualTo: _currentUserId)
          .orderBy('startTime', descending: false);

      final organizerSnapshot = await organizerQuery.get();

      // Load appointments where user is participant
      final participantQuery = FirebaseFirestore.instance
          .collection('appointments')
          .where('participantIds', arrayContains: _currentUserId)
          .orderBy('startTime', descending: false);

      final participantSnapshot = await participantQuery.get();

      // Combine and deduplicate appointments
      final Map<String, Appointment> appointmentMap = {};

      for (final doc in organizerSnapshot.docs) {
        final appointment = Appointment.fromMap(doc.data(), doc.id);
        appointmentMap[appointment.id] = appointment;
      }

      for (final doc in participantSnapshot.docs) {
        final appointment = Appointment.fromMap(doc.data(), doc.id);
        appointmentMap[appointment.id] = appointment;
      }

      _appointments = appointmentMap.values.toList();
      _appointments.sort((a, b) => a.startTime.compareTo(b.startTime));

      _updateDerivedAppointmentLists();
      _clearError();
    } catch (e) {
      _setError('Failed to load appointments: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load calendar settings for the current user
  Future<void> loadCalendarSettings() async {
    if (_currentUserId == null) return;

    try {
      final result = await _firestoreService.getDocument(
        collection: 'calendar_settings',
        documentId: _currentUserId!,
      );

      if (result['success'] == true && result['data'] != null) {
        _calendarSettings = CalendarSettings.fromMap(result['data']);
      } else {
        // Create default calendar settings
        _calendarSettings = _createDefaultCalendarSettings();
        await saveCalendarSettings(_calendarSettings!);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load calendar settings: $e');
    }
  }

  /// Create a new appointment
  Future<Appointment?> createAppointment(Appointment appointment) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    _setLoading(true);
    try {
      // Check for conflicts
      final conflicts = await _checkAppointmentConflicts(appointment);
      if (conflicts.isNotEmpty) {
        throw Exception('Time slot conflicts with existing appointments');
      }

      await _firestoreService.createDocument(
        collection: 'appointments',
        documentId: appointment.id,
        data: appointment.toMap(),
      );

      final createdAppointment = appointment.copyWith();

      // Add to local state
      _appointments.add(createdAppointment);
      _updateDerivedAppointmentLists();

      // Schedule reminders
      await _scheduleReminders(createdAppointment);

      // Send notifications to participants
      await _notifyParticipants(createdAppointment, 'Appointment scheduled');

      _clearError();
      return createdAppointment;
    } catch (e) {
      _setError('Failed to create appointment: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing appointment
  Future<bool> updateAppointment(
      String appointmentId, Appointment updatedAppointment) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    _setLoading(true);
    try {
      // Check for conflicts if time changed
      final originalAppointment =
          _appointments.firstWhere((a) => a.id == appointmentId);
      if (originalAppointment.startTime != updatedAppointment.startTime ||
          originalAppointment.endTime != updatedAppointment.endTime) {
        final conflicts = await _checkAppointmentConflicts(updatedAppointment,
            excludeId: appointmentId);
        if (conflicts.isNotEmpty) {
          throw Exception('Time slot conflicts with existing appointments');
        }
      }

      await _firestoreService.updateDocument(
        collection: 'appointments',
        documentId: appointmentId,
        data: updatedAppointment.toMap(),
      );

      // Update local state
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = updatedAppointment;
        _updateDerivedAppointmentLists();
      }

      // Update reminders
      await _updateReminders(updatedAppointment);

      // Notify participants of changes
      await _notifyParticipants(updatedAppointment, 'Appointment updated');

      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to update appointment: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cancel an appointment
  Future<bool> cancelAppointment(
      String appointmentId, String cancellationReason) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    _setLoading(true);
    try {
      final appointment =
          _appointments.firstWhere((a) => a.id == appointmentId);
      final cancelledAppointment = appointment.copyWith(
        status: AppointmentStatus.cancelled,
        cancellationReason: cancellationReason,
        lastModifiedBy: _currentUserId,
      );

      await _firestoreService.updateDocument(
        collection: 'appointments',
        documentId: appointmentId,
        data: cancelledAppointment.toMap(),
      );

      // Update local state
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = cancelledAppointment;
        _updateDerivedAppointmentLists();
      }

      // Cancel reminders
      await _cancelReminders(appointmentId);

      // Notify participants
      await _notifyParticipants(
          cancelledAppointment, 'Appointment cancelled: $cancellationReason');

      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to cancel appointment: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get available time slots for a specific date
  Future<List<TimeSlot>> getAvailableTimeSlots(
      DateTime date, Duration duration) async {
    if (_calendarSettings == null) return [];

    final dayOfWeek = date.weekday;
    final workingHours = _calendarSettings!.workingHours[dayOfWeek] ?? [];

    if (workingHours.isEmpty) return [];

    final availableSlots = <TimeSlot>[];

    for (final workingSlot in workingHours) {
      if (!workingSlot.isAvailable) continue;

      DateTime currentTime = workingSlot.startTime;
      final endTime = workingSlot.endTime;

      while (currentTime.add(duration).isBefore(endTime) ||
          currentTime.add(duration).isAtSameMomentAs(endTime)) {
        final slotEndTime = currentTime.add(duration);

        // Check if this slot conflicts with existing appointments
        final hasConflict = _appointments.any((appointment) =>
            appointment.scheduledDate.year == date.year &&
            appointment.scheduledDate.month == date.month &&
            appointment.scheduledDate.day == date.day &&
            appointment.status != AppointmentStatus.cancelled &&
            _timeSlotsOverlap(currentTime, slotEndTime, appointment.startTime,
                appointment.endTime));

        if (!hasConflict) {
          availableSlots.add(TimeSlot(
            startTime: currentTime,
            endTime: slotEndTime,
            isAvailable: true,
          ));
        }

        currentTime =
            currentTime.add(duration).add(_calendarSettings!.bufferTime);
      }
    }

    return availableSlots;
  }

  /// Save calendar settings
  Future<void> saveCalendarSettings(CalendarSettings settings) async {
    if (_currentUserId == null) return;

    try {
      await _firestoreService.createDocument(
        collection: 'calendar_settings',
        documentId: _currentUserId!,
        data: settings.toMap(),
      );
      _calendarSettings = settings;
      notifyListeners();
    } catch (e) {
      _setError('Failed to save calendar settings: $e');
    }
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Set status filters
  void setStatusFilters(List<AppointmentStatus> filters) {
    _statusFilters = filters;
    _updateDerivedAppointmentLists();
  }

  /// Set type filters
  void setTypeFilters(List<AppointmentType> filters) {
    _typeFilters = filters;
    _updateDerivedAppointmentLists();
  }

  /// Set priority filter
  void setPriorityFilter(AppointmentPriority? filter) {
    _priorityFilter = filter;
    _updateDerivedAppointmentLists();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _updateDerivedAppointmentLists();
  }

  /// Clear all filters
  void clearFilters() {
    _statusFilters = AppointmentStatus.values;
    _typeFilters = AppointmentType.values;
    _priorityFilter = null;
    _searchQuery = '';
    _updateDerivedAppointmentLists();
  }

  /// Start an appointment (mark as in progress)
  Future<bool> startAppointment(String appointmentId) async {
    return await _updateAppointmentStatus(
        appointmentId, AppointmentStatus.inProgress,
        actualStartTime: DateTime.now());
  }

  /// Complete an appointment
  Future<bool> completeAppointment(String appointmentId,
      {String? notes}) async {
    final appointment = _appointments.firstWhere((a) => a.id == appointmentId);
    final completedAppointment = appointment.copyWith(
      status: AppointmentStatus.completed,
      actualEndTime: DateTime.now(),
      notes: notes ?? appointment.notes,
      lastModifiedBy: _currentUserId,
    );

    return await updateAppointment(appointmentId, completedAppointment);
  }

  /// Mark appointment as no-show
  Future<bool> markAsNoShow(String appointmentId) async {
    return await _updateAppointmentStatus(
        appointmentId, AppointmentStatus.noShow);
  }

  /// Reschedule an appointment
  Future<bool> rescheduleAppointment(
      String appointmentId, DateTime newStartTime, DateTime newEndTime) async {
    final appointment = _appointments.firstWhere((a) => a.id == appointmentId);
    final rescheduledAppointment = appointment.copyWith(
      startTime: newStartTime,
      endTime: newEndTime,
      status: AppointmentStatus.rescheduled,
      lastModifiedBy: _currentUserId,
    );

    return await updateAppointment(appointmentId, rescheduledAppointment);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _updateDerivedAppointmentLists() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Apply filters
    List<Appointment> filteredAppointments = _appointments.where((appointment) {
      // Status filter
      if (!_statusFilters.contains(appointment.status)) return false;

      // Type filter
      if (!_typeFilters.contains(appointment.type)) return false;

      // Priority filter
      if (_priorityFilter != null && appointment.priority != _priorityFilter) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!appointment.title.toLowerCase().contains(query) &&
            !appointment.description.toLowerCase().contains(query) &&
            !(appointment.locationName?.toLowerCase().contains(query) ??
                false)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Update upcoming appointments (next 7 days, not cancelled/completed)
    _upcomingAppointments = filteredAppointments.where((appointment) {
      final appointmentDate = DateTime(
        appointment.scheduledDate.year,
        appointment.scheduledDate.month,
        appointment.scheduledDate.day,
      );
      return appointmentDate.isAfter(today.subtract(const Duration(days: 1))) &&
          appointmentDate.isBefore(today.add(const Duration(days: 8))) &&
          appointment.status != AppointmentStatus.cancelled &&
          appointment.status != AppointmentStatus.completed;
    }).toList();

    // Update today's appointments
    _todayAppointments = filteredAppointments.where((appointment) {
      final appointmentDate = DateTime(
        appointment.scheduledDate.year,
        appointment.scheduledDate.month,
        appointment.scheduledDate.day,
      );
      return appointmentDate.isAtSameMomentAs(today);
    }).toList();

    // Group appointments by date
    _appointmentsByDate.clear();
    for (final appointment in filteredAppointments) {
      final dateKey =
          '${appointment.scheduledDate.year}-${appointment.scheduledDate.month.toString().padLeft(2, '0')}-${appointment.scheduledDate.day.toString().padLeft(2, '0')}';
      _appointmentsByDate[dateKey] = _appointmentsByDate[dateKey] ?? [];
      _appointmentsByDate[dateKey]!.add(appointment);
    }

    notifyListeners();
  }

  Future<List<Appointment>> _checkAppointmentConflicts(Appointment appointment,
      {String? excludeId}) async {
    return _appointments.where((existing) {
      if (excludeId != null && existing.id == excludeId) return false;
      if (existing.status == AppointmentStatus.cancelled) return false;

      // Check if appointments are on the same date
      if (!_isSameDate(existing.scheduledDate, appointment.scheduledDate)) {
        return false;
      }

      // Check if organizer or any participant has conflicts
      final hasCommonParticipant =
          existing.organizerId == appointment.organizerId ||
              existing.participantIds.contains(appointment.organizerId) ||
              appointment.participantIds.contains(existing.organizerId) ||
              existing.participantIds
                  .any((id) => appointment.participantIds.contains(id));

      if (!hasCommonParticipant) return false;

      // Check time overlap
      return _timeSlotsOverlap(
        existing.startTime,
        existing.endTime,
        appointment.startTime,
        appointment.endTime,
      );
    }).toList();
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _timeSlotsOverlap(
      DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isBefore(end2) && start2.isBefore(end1);
  }

  Future<void> _scheduleReminders(Appointment appointment) async {
    for (final reminder in appointment.reminders) {
      if (!reminder.isEnabled) continue;

      final reminderTime =
          appointment.startTime.subtract(reminder.beforeAppointment);

      // NotificationService integration pending - using debug logging
      // When NotificationService is available, schedule notification at reminderTime
      if (kDebugMode) {
        print('Reminder scheduled for ${appointment.title} at $reminderTime');
      }
    }
  }

  Future<void> _updateReminders(Appointment appointment) async {
    // Cancel existing reminders
    await _cancelReminders(appointment.id);

    // Schedule new reminders
    await _scheduleReminders(appointment);
  }

  Future<void> _cancelReminders(String appointmentId) async {
    final appointment = _appointments.firstWhere((a) => a.id == appointmentId);
    for (final reminder in appointment.reminders) {
      // NotificationService integration pending - using debug logging
      // When NotificationService is available, cancel scheduled notifications
      if (kDebugMode) {
        print(
            'Reminder cancelled for appointment: $appointmentId, reminder: ${reminder.id}');
      }
    }
  }

  Future<void> _notifyParticipants(
      Appointment appointment, String message) async {
    for (final participantId in appointment.participantIds) {
      if (participantId != _currentUserId) {
        // NotificationService integration pending - using debug logging
        // When NotificationService is available, send push notification to participantId
        if (kDebugMode) {
          print('Notification sent to $participantId: $message');
        }
      }
    }
  }

  Future<bool> _updateAppointmentStatus(
      String appointmentId, AppointmentStatus status,
      {DateTime? actualStartTime, DateTime? actualEndTime}) async {
    final appointment = _appointments.firstWhere((a) => a.id == appointmentId);
    final updatedAppointment = appointment.copyWith(
      status: status,
      actualStartTime: actualStartTime ?? appointment.actualStartTime,
      actualEndTime: actualEndTime ?? appointment.actualEndTime,
      lastModifiedBy: _currentUserId,
    );

    return await updateAppointment(appointmentId, updatedAppointment);
  }

  CalendarSettings _createDefaultCalendarSettings() {
    final defaultWorkingHours = <int, List<TimeSlot>>{};

    // Monday to Friday, 9 AM to 5 PM
    for (int day = 1; day <= 5; day++) {
      defaultWorkingHours[day] = [
        TimeSlot(
          startTime: DateTime(2024, 1, 1, 9, 0), // 9:00 AM
          endTime: DateTime(2024, 1, 1, 17, 0), // 5:00 PM
          isAvailable: true,
        ),
      ];
    }

    return CalendarSettings(
      userId: _currentUserId!,
      workingHours: defaultWorkingHours,
      blockedDates: [],
      defaultAppointmentDuration: const Duration(hours: 1),
      bufferTime: const Duration(minutes: 15),
      allowBackToBackBookings: false,
      maxAdvanceBookingDays: 30,
      minAdvanceBookingHours: 24,
      appointmentTypeDurations: {
        AppointmentType.consultation: const Duration(minutes: 30),
        AppointmentType.demonstration: const Duration(hours: 1),
        AppointmentType.meeting: const Duration(hours: 1),
        AppointmentType.training: const Duration(hours: 2),
        AppointmentType.support: const Duration(minutes: 45),
        AppointmentType.followUp: const Duration(minutes: 30),
        AppointmentType.onboarding: const Duration(hours: 3),
        AppointmentType.review: const Duration(hours: 1),
      },
    );
  }
}
