import 'dart:convert';

class HolidayResponseModel {
  final String? message;
  final List<Holiday>? data;

  HolidayResponseModel({
    this.message,
    this.data,
  });

  factory HolidayResponseModel.fromJson(String str) =>
      HolidayResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HolidayResponseModel.fromMap(Map<String, dynamic> json) =>
      HolidayResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Holiday>.from(json["data"]!.map((x) => Holiday.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Holiday {
  final int? id;
  final int? companyId;
  final String? name;
  final int? year;
  final int? month;
  final DateTime? date;
  final int? isWeekend;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Holiday({
    this.id,
    this.companyId,
    this.name,
    this.year,
    this.month,
    this.date,
    this.isWeekend,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Holiday.fromJson(String str) => Holiday.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Holiday.fromMap(Map<String, dynamic> json) => Holiday(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        year: json["year"],
        month: json["month"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        isWeekend: json["is_weekend"],
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
        "year": year,
        "month": month,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "is_weekend": isWeekend,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
