import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/contact_service.dart';

class ContactInfo {
  final String phone;
  final String email;
  final String address;
  final String hours;

  const ContactInfo({required this.phone, required this.email, required this.address, required this.hours});

  factory ContactInfo.fromMap(Map<String, dynamic>? m) {
    if (m == null) return ContactInfo.defaults();
    return ContactInfo(
      phone: (m['phone'] as String?) ?? '+212 784007410',
      email: (m['email'] as String?) ?? 'contact@multisales.ma',
      address: (m['address'] as String?) ?? '49 boulevard CHEFCHAOUNI II, Ain Sébaâ, Casablanca Maroc',
      hours: (m['hours'] as String?) ?? 'Lun–Ven 08:30 – 18:00',
    );
  }

  factory ContactInfo.defaults() => const ContactInfo(
        phone: '+212 784007410',
        email: 'contact@multisales.ma',
        address: '49 boulevard CHEFCHAOUNI II, Ain Sébaâ, Casablanca Maroc',
        hours: 'Lun–Ven 08:30 – 18:00',
      );
}

class ContactProvider with ChangeNotifier {
  ContactProvider({ContactService? service}) : _service = service ?? ContactService();

  final ContactService _service;

  bool _isLoading = false;
  String? _errorMessage;
  ContactInfo _info = ContactInfo.defaults();
  bool _isInfoLoading = false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ContactInfo get info => _info;
  bool get isInfoLoading => _isInfoLoading;

  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadContactInfo({String path = 'settings/contact'}) async {
    if (_isInfoLoading) return;
    _isInfoLoading = true;
    notifyListeners();
    try {
      final doc = await FirebaseFirestore.instance.doc(path).get();
      if (doc.exists) {
        _info = ContactInfo.fromMap(doc.data());
      }
    } catch (_) {
      // ignore errors, keep defaults
    } finally {
      _isInfoLoading = false;
      notifyListeners();
    }
  }

  /// Save contact settings to Firestore and update local state.
  Future<bool> saveContactInfo({required ContactInfo info, String path = 'settings/contact'}) async {
    try {
      final data = <String, dynamic>{
        'phone': info.phone,
        'email': info.email,
        'address': info.address,
        'hours': info.hours,
      };
      await _service.saveSettingsContact(data: data, path: path);
      _info = info;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void _setError(String? msg) {
    if (_errorMessage == msg) return;
    _errorMessage = msg;
    notifyListeners();
  }

  Future<bool> submit({required String name, required String email, required String message, bool sendCopy = false}) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.submitContact(name: name, email: email, message: message, sendCopy: sendCopy);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
