/// User Model for MultiSales Client App
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? address;
  final String? city;
  final String? postalCode;
  final String role;
  final String accountType;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isOnboardingComplete;
  final String? profileImageUrl;
  final Map<String, dynamic>? preferences;
  final List<String>? services;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.address,
    this.city,
    this.postalCode,
    required this.role,
    required this.accountType,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isOnboardingComplete = false,
    this.profileImageUrl,
    this.preferences,
    this.services,
  });

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postalCode'],
      role: json['role'] ?? 'client',
      accountType: json['accountType'] ?? 'basic',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      isActive: json['isActive'] ?? true,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isOnboardingComplete: json['isOnboardingComplete'] ?? false,
      profileImageUrl: json['profileImageUrl'],
      preferences: json['preferences'],
      services:
          json['services'] != null ? List<String>.from(json['services']) : null,
    );
  }

  // Create UserModel from Firebase User
  factory UserModel.fromFirebaseUser({
    required String uid,
    required String email,
    String? displayName,
    required String role,
  }) {
    final names = displayName?.split(' ') ?? ['', ''];
    return UserModel(
      id: uid,
      email: email,
      firstName: names.isNotEmpty ? names[0] : '',
      lastName: names.length > 1 ? names.sublist(1).join(' ') : '',
      role: role,
      accountType: 'basic',
      createdAt: DateTime.now(),
      isActive: true,
      isEmailVerified: false,
      isPhoneVerified: false,
      isOnboardingComplete: false,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'role': role,
      'accountType': accountType,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isOnboardingComplete': isOnboardingComplete,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences,
      'services': services,
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
    String? role,
    String? accountType,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isOnboardingComplete,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
    List<String>? services,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      role: role ?? this.role,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      services: services ?? this.services,
    );
  }

  // Get full name
  String get fullName => '$firstName $lastName';

  // Get display name (first name + last initial)
  String get displayName =>
      '$firstName ${lastName.isNotEmpty ? lastName[0] : ''}';

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
