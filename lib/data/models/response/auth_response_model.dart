import 'dart:convert';

class AuthResponseModel {
  final User? user;
  final String? token;

  AuthResponseModel({
    this.user,
    this.token,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "token": token,
      };
}

class User {
  final int? id;
  final String? username;
  final int? companyId;
  final int? isSuperadmin;
  final int? roleId;
  final String? userType;
  final int? loginEnabled;
  final String? profileImage;
  final String? status;
  final String? phone;
  final String? address;
  final dynamic departmentId;
  final dynamic designationId;
  final dynamic shiftId;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedBy;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final dynamic twoFactorSecret;
  final dynamic twoFactorRecoveryCodes;
  final dynamic twoFactorConfirmedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.username,
    this.companyId,
    this.isSuperadmin,
    this.roleId,
    this.userType,
    this.loginEnabled,
    this.profileImage,
    this.status,
    this.phone,
    this.address,
    this.departmentId,
    this.designationId,
    this.shiftId,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.twoFactorSecret,
    this.twoFactorRecoveryCodes,
    this.twoFactorConfirmedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        companyId: json["company_id"],
        isSuperadmin: json["is_superadmin"],
        roleId: json["role_id"],
        userType: json["user_type"],
        loginEnabled: json["login_enabled"],
        profileImage: json["profile_image"],
        status: json["status"],
        phone: json["phone"],
        address: json["address"],
        departmentId: json["department_id"],
        designationId: json["designation_id"],
        shiftId: json["shift_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedBy: json["deleted_by"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        twoFactorSecret: json["two_factor_secret"],
        twoFactorRecoveryCodes: json["two_factor_recovery_codes"],
        twoFactorConfirmedAt: json["two_factor_confirmed_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "company_id": companyId,
        "is_superadmin": isSuperadmin,
        "role_id": roleId,
        "user_type": userType,
        "login_enabled": loginEnabled,
        "profile_image": profileImage,
        "status": status,
        "phone": phone,
        "address": address,
        "department_id": departmentId,
        "designation_id": designationId,
        "shift_id": shiftId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "deleted_by": deletedBy,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "two_factor_secret": twoFactorSecret,
        "two_factor_recovery_codes": twoFactorRecoveryCodes,
        "two_factor_confirmed_at": twoFactorConfirmedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
