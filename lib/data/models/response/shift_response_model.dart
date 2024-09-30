import 'dart:convert';

class ShiftResponseModel {
  final String? message;
  final List<Shift>? data;

  ShiftResponseModel({
    this.message,
    this.data,
  });

  factory ShiftResponseModel.fromJson(String str) =>
      ShiftResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShiftResponseModel.fromMap(Map<String, dynamic> json) =>
      ShiftResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Shift>.from(json["data"]!.map((x) => Shift.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Shift {
  final int? id;
  final int? companyId;
  final int? createdBy;
  final String? name;
  final String? clockInTime;
  final String? clockOutTime;
  final dynamic lateMarkAfter;
  final bool? isSelfClocking;
  final dynamic earlyClockInTime;
  final dynamic allowClockOutTill;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Shift({
    this.id,
    this.companyId,
    this.createdBy,
    this.name,
    this.clockInTime,
    this.clockOutTime,
    this.lateMarkAfter,
    this.isSelfClocking,
    this.earlyClockInTime,
    this.allowClockOutTill,
    this.createdAt,
    this.updatedAt,
  });

  factory Shift.fromJson(String str) => Shift.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Shift.fromMap(Map<String, dynamic> json) => Shift(
        id: json["id"],
        companyId: json["company_id"],
        createdBy: json["created_by"],
        name: json["name"],
        clockInTime: json["clock_in_time"],
        clockOutTime: json["clock_out_time"],
        lateMarkAfter: json["late_mark_after"],
        earlyClockInTime: json["early_clock_in_time"],
        allowClockOutTill: json["allow_clock_out_till"],
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
        "created_by": createdBy,
        "name": name,
        "clock_in_time": clockInTime,
        "clock_out_time": clockOutTime,
        "late_mark_after": lateMarkAfter,
        "early_clock_in_time": earlyClockInTime,
        "allow_clock_out_till": allowClockOutTill,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
