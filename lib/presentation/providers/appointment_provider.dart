import 'package:flutter/foundation.dart';

/// Appointment Booking Provider for MultiSales Client App
/// Handles technical appointments and in-agency visit bookings
class AppointmentProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _availableSlots = [];
  List<Map<String, dynamic>> _clientAppointments = [];
  List<Map<String, dynamic>> _technicians = [];
  List<Map<String, dynamic>> _agencies = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get availableSlots => _availableSlots;
  List<Map<String, dynamic>> get clientAppointments => _clientAppointments;
  List<Map<String, dynamic>> get technicians => _technicians;
  List<Map<String, dynamic>> get agencies => _agencies;

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

  // Load Available Appointment Slots
  Future<bool> loadAvailableSlots({
    required String serviceType, // 'technical', 'installation', 'consultation'
    required DateTime startDate,
    required DateTime endDate,
    String? cityCode,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      _availableSlots = [
        {
          'id': 'slot_001',
          'date': '2025-08-01',
          'timeSlot': '09:00-11:00',
          'technicianId': 'tech_001',
          'technicianName': 'Ahmed Benali',
          'serviceType': serviceType,
          'location': 'Casablanca',
          'available': true,
          'price': serviceType == 'consultation' ? 0.0 : 150.0,
        },
        {
          'id': 'slot_002',
          'date': '2025-08-01',
          'timeSlot': '14:00-16:00',
          'technicianId': 'tech_002',
          'technicianName': 'Fatima Alami',
          'serviceType': serviceType,
          'location': 'Casablanca',
          'available': true,
          'price': serviceType == 'consultation' ? 0.0 : 150.0,
        },
        {
          'id': 'slot_003',
          'date': '2025-08-02',
          'timeSlot': '10:00-12:00',
          'technicianId': 'tech_001',
          'technicianName': 'Ahmed Benali',
          'serviceType': serviceType,
          'location': 'Casablanca',
          'available': true,
          'price': serviceType == 'consultation' ? 0.0 : 150.0,
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load available slots: $e');
      _setLoading(false);
      return false;
    }
  }

  // Book Technical Appointment
  Future<bool> bookTechnicalAppointment({
    required String clientId,
    required String slotId,
    required String serviceType,
    required Map<String, dynamic> clientAddress,
    required String issueDescription,
    String? preferredTechnician,
    String? specialInstructions,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final appointmentId = 'apt_${DateTime.now().millisecondsSinceEpoch}';
      final selectedSlot =
          _availableSlots.firstWhere((slot) => slot['id'] == slotId);

      final newAppointment = {
        'id': appointmentId,
        'clientId': clientId,
        'appointmentNumber': 'MS-APT-${appointmentId.substring(4)}',
        'slotId': slotId,
        'serviceType': serviceType,
        'technicianId': selectedSlot['technicianId'],
        'technicianName': selectedSlot['technicianName'],
        'date': selectedSlot['date'],
        'timeSlot': selectedSlot['timeSlot'],
        'clientAddress': clientAddress,
        'issueDescription': issueDescription,
        'specialInstructions': specialInstructions,
        'status':
            'confirmed', // confirmed, in_progress, completed, cancelled, rescheduled
        'bookedAt': DateTime.now().toIso8601String(),
        'estimatedDuration': _getEstimatedDuration(serviceType),
        'price': selectedSlot['price'],
        'paymentStatus': 'pending',
        'reminderSent': false,
      };

      _clientAppointments.add(newAppointment);

      // Remove booked slot from available slots
      _availableSlots.removeWhere((slot) => slot['id'] == slotId);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to book appointment: $e');
      _setLoading(false);
      return false;
    }
  }

  // Book Agency Visit
  Future<bool> bookAgencyVisit({
    required String clientId,
    required String agencyId,
    required String visitPurpose,
    required DateTime preferredDate,
    required String preferredTime,
    String? notes,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final visitId = 'visit_${DateTime.now().millisecondsSinceEpoch}';
      final selectedAgency =
          _agencies.firstWhere((agency) => agency['id'] == agencyId);

      final newVisit = {
        'id': visitId,
        'clientId': clientId,
        'visitNumber': 'MS-VISIT-${visitId.substring(6)}',
        'agencyId': agencyId,
        'agencyName': selectedAgency['name'],
        'agencyAddress': selectedAgency['address'],
        'visitPurpose': visitPurpose,
        'date': preferredDate.toIso8601String().split('T')[0],
        'time': preferredTime,
        'notes': notes,
        'status': 'scheduled', // scheduled, confirmed, completed, cancelled
        'bookedAt': DateTime.now().toIso8601String(),
        'estimatedDuration': '30 minutes',
        'queueNumber': null, // Will be assigned on the day
      };

      _clientAppointments.add(newVisit);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to book agency visit: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Client Appointments
  Future<bool> loadClientAppointments(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      _clientAppointments = [
        {
          'id': 'apt_1722345600000',
          'clientId': clientId,
          'appointmentNumber': 'MS-APT-1722345600000',
          'serviceType': 'technical',
          'technicianName': 'Ahmed Benali',
          'date': '2025-08-01',
          'timeSlot': '14:00-16:00',
          'status': 'confirmed',
          'issueDescription': 'Internet connection issues',
          'address': 'Casablanca, Maarif',
        },
        {
          'id': 'visit_1722432000000',
          'clientId': clientId,
          'visitNumber': 'MS-VISIT-1722432000000',
          'agencyName': 'MultiSales Casablanca Center',
          'visitPurpose': 'Contract signature',
          'date': '2025-08-03',
          'time': '10:00',
          'status': 'scheduled',
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load appointments: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Technicians List
  Future<bool> loadTechnicians({String? cityCode}) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _technicians = [
        {
          'id': 'tech_001',
          'name': 'Ahmed Benali',
          'specialization': 'Network & Internet',
          'rating': 4.8,
          'reviewCount': 156,
          'location': 'Casablanca',
          'languages': ['Arabic', 'French'],
          'experience': '5+ years',
          'available': true,
        },
        {
          'id': 'tech_002',
          'name': 'Fatima Alami',
          'specialization': 'Cloud Solutions',
          'rating': 4.9,
          'reviewCount': 203,
          'location': 'Casablanca',
          'languages': ['Arabic', 'French', 'English'],
          'experience': '7+ years',
          'available': true,
        },
        {
          'id': 'tech_003',
          'name': 'Youssef Makroum',
          'specialization': 'Mobile & Security',
          'rating': 4.7,
          'reviewCount': 89,
          'location': 'Rabat',
          'languages': ['Arabic', 'French'],
          'experience': '4+ years',
          'available': true,
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load technicians: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Agencies List
  Future<bool> loadAgencies({String? cityCode}) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      _agencies = [
        {
          'id': 'agency_001',
          'name': 'MultiSales Casablanca Center',
          'address': 'Boulevard Mohammed V, Casablanca',
          'phone': '+212 522 123 456',
          'hours': 'Mon-Fri: 8:00-18:00, Sat: 9:00-13:00',
          'services': ['Account Management', 'Technical Support', 'Sales'],
          'coordinates': {'lat': 33.5731, 'lng': -7.5898},
          'waitTime': '15 minutes',
        },
        {
          'id': 'agency_002',
          'name': 'MultiSales Rabat Branch',
          'address': 'Avenue Mohammed VI, Rabat',
          'phone': '+212 537 987 654',
          'hours': 'Mon-Fri: 8:30-17:30, Sat: 9:00-12:00',
          'services': ['Account Management', 'Technical Support'],
          'coordinates': {'lat': 34.0209, 'lng': -6.8416},
          'waitTime': '10 minutes',
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load agencies: $e');
      _setLoading(false);
      return false;
    }
  }

  // Cancel Appointment
  Future<bool> cancelAppointment(String appointmentId, String reason) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final appointmentIndex = _clientAppointments.indexWhere(
        (apt) => apt['id'] == appointmentId,
      );

      if (appointmentIndex != -1) {
        _clientAppointments[appointmentIndex]['status'] = 'cancelled';
        _clientAppointments[appointmentIndex]['cancellationReason'] = reason;
        _clientAppointments[appointmentIndex]['cancelledAt'] =
            DateTime.now().toIso8601String();
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to cancel appointment: $e');
      _setLoading(false);
      return false;
    }
  }

  // Reschedule Appointment
  Future<bool> rescheduleAppointment({
    required String appointmentId,
    required String newSlotId,
    String? reason,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final appointmentIndex = _clientAppointments.indexWhere(
        (apt) => apt['id'] == appointmentId,
      );

      final newSlot =
          _availableSlots.firstWhere((slot) => slot['id'] == newSlotId);

      if (appointmentIndex != -1) {
        _clientAppointments[appointmentIndex]['status'] = 'rescheduled';
        _clientAppointments[appointmentIndex]['date'] = newSlot['date'];
        _clientAppointments[appointmentIndex]['timeSlot'] = newSlot['timeSlot'];
        _clientAppointments[appointmentIndex]['rescheduledAt'] =
            DateTime.now().toIso8601String();
        _clientAppointments[appointmentIndex]['rescheduleReason'] = reason;
      }

      // Remove new slot from available slots
      _availableSlots.removeWhere((slot) => slot['id'] == newSlotId);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to reschedule appointment: $e');
      _setLoading(false);
      return false;
    }
  }

  String _getEstimatedDuration(String serviceType) {
    switch (serviceType) {
      case 'installation':
        return '2-3 hours';
      case 'technical':
        return '1-2 hours';
      case 'consultation':
        return '30-60 minutes';
      case 'maintenance':
        return '1-2 hours';
      default:
        return '1 hour';
    }
  }
}
