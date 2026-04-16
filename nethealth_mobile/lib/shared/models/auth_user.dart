import 'dart:convert';
import 'enums.dart';

class AuthUser {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final AccountStatus accountStatus;
  final String? avatar;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.accountStatus,
    this.avatar,
  });

  String get firstName => fullName.split(' ').first;
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['id'] != null) {
      if (json['id'] is int) {
        parsedId = json['id'];
      } else if (json['id'] is String) {
        parsedId = int.tryParse(json['id']) ?? 0;
      }
    }

    return AuthUser(
      id:            parsedId,
      fullName:      json['full_name']?.toString() ?? 'Unknown',
      email:         json['email']?.toString() ?? '',
      phone:         json['phone']?.toString() ?? '',
      role:          UserRole.fromString(json['role']?.toString() ?? 'patient'),
      accountStatus: AccountStatus.fromString(json['account_status']?.toString() ?? 'active'),
      avatar:        json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id':             id,
        'full_name':      fullName,
        'email':          email,
        'phone':          phone,
        'role':           role.name,
        'account_status': accountStatus.name,
        'avatar':         avatar,
      };

  String toJsonString() => jsonEncode(toJson());
  static AuthUser fromJsonString(String s) => AuthUser.fromJson(jsonDecode(s));

  // Mock factory
  factory AuthUser.mock() => const AuthUser(
        id:            1,
        fullName:      'Ahmed Mohamed',
        email:         'patient@test.com',
        phone:         '+20 100 000 0001',
        role:          UserRole.patient,
        accountStatus: AccountStatus.active,
        avatar:        null,
      );

  AuthUser copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    UserRole? role,
    AccountStatus? accountStatus,
    String? avatar,
  }) =>
      AuthUser(
        id:            id ?? this.id,
        fullName:      fullName ?? this.fullName,
        email:         email ?? this.email,
        phone:         phone ?? this.phone,
        role:          role ?? this.role,
        accountStatus: accountStatus ?? this.accountStatus,
        avatar:        avatar ?? this.avatar,
      );
}
