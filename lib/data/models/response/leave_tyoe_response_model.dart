import 'dart:convert';

class LeaveTypeResponseModel {
  final String? message;
  final List<LeaveType>? data;

  LeaveTypeResponseModel({
    this.message,
    this.data,
  });

  factory LeaveTypeResponseModel.fromJson(String str) =>
      LeaveTypeResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaveTypeResponseModel.fromMap(Map<String, dynamic> json) =>
      LeaveTypeResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<LeaveType>.from(
                json["data"]!.map((x) => LeaveType.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class LeaveType {
  final int? id;
  final int? companyId;
  final String? name;
  final int? isPaid;
  final int? totalLeaves;
  final int? maxLeavePerMonth;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LeaveType({
    this.id,
    this.companyId,
    this.name,
    this.isPaid,
    this.totalLeaves,
    this.maxLeavePerMonth,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveType.fromJson(String str) => LeaveType.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaveType.fromMap(Map<String, dynamic> json) => LeaveType(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        isPaid: json["is_paid"],
        totalLeaves: json["total_leaves"],
        maxLeavePerMonth: json["max_leave_per_month"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "company_id": companyId,
        "name": name,
        "is_paid": isPaid,
        "total_leaves": totalLeaves,
        "max_leave_per_month": maxLeavePerMonth,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
