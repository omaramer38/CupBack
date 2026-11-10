enum UserRole {
  customer,
  businessOwner,
}

class UserSession {
  final String name;
  final String phone;
  final UserRole role;
  final String? businessName;
  final String? ownerContactPhone;
  final bool isActivated;
  final DateTime? createdAt;

  const UserSession({
    required this.name,
    required this.phone,
    required this.role,
    this.businessName,
    this.ownerContactPhone,
    this.isActivated = false,
    this.createdAt,
  });

  bool get isBusiness => role == UserRole.businessOwner;
  bool get isCustomer => role == UserRole.customer;

  UserSession copyWith({
    String? name,
    String? phone,
    UserRole? role,
    String? businessName,
    String? ownerContactPhone,
    bool? isActivated,
    DateTime? createdAt,
  }) {
    return UserSession(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      businessName: businessName ?? this.businessName,
      ownerContactPhone: ownerContactPhone ?? this.ownerContactPhone,
      isActivated: isActivated ?? this.isActivated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
