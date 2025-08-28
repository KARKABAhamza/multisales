/// User account model for MultiSales app
class UserAccount {
  final String id;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? company;
  final String? jobTitle;
  final String? address;
  final String? city;
  final String? country;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, dynamic> preferences;

  UserAccount({
    required this.id,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.profileImageUrl,
    this.company,
    this.jobTitle,
    this.address,
    this.city,
    this.country,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.preferences = const {},
  });

  /// Create UserAccount from Firestore document
  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      company: map['company'],
      jobTitle: map['jobTitle'],
      address: map['address'],
      city: map['city'],
      country: map['country'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isActive: map['isActive'] ?? true,
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
    );
  }

  /// Convert UserAccount to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'company': company,
      'jobTitle': jobTitle,
      'address': address,
      'city': city,
      'country': country,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'preferences': preferences,
    };
  }

  /// Create a copy with updated fields
  UserAccount copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? profileImageUrl,
    String? company,
    String? jobTitle,
    String? address,
    String? city,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? preferences,
  }) {
    return UserAccount(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  String toString() {
    return 'UserAccount(id: $id, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserAccount && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
