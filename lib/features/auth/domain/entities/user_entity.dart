class UserEntity {
  final String id;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatarUrl;
  final bool? isVerified;
  final bool? isActive;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.avatarUrl,
    this.isVerified,
    this.isActive,
  });

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? phoneNumber;
  }
}
