part of '../health.dart';

class ECGData {
  List<ECGValue>? values;
  double? period;
  int? interpretation;
  List<String>? symptoms;
  double? averageHearthRate;

  ECGData._({
    this.period,
    this.values,
    this.interpretation,
    this.symptoms,
    this.averageHearthRate,
  });

  factory ECGData.fromRawJson(String str) => ECGData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ECGData.fromJson(Map<String, dynamic> json) => ECGData._(
        period: json['period'] == null ? null : json['period'].toDouble(),
        values:
            json['values'] == null ? null : List<ECGValue>.from(json['values'].map((x) => ECGValue.fromJson(Map<String, dynamic>.from(x)))),
        interpretation: json['interpretation'] == null ? null : json['interpretation'],
        symptoms: json['symptoms'] == null ? null : List<String>.from(json['symptoms'].map((x) => x)),
        averageHearthRate: json['average_heart_rate'] == null ? null : json['average_heart_rate'],
      );

  Map<String, dynamic> toJson() => {
        'period': period == null ? null : period,
        'values': values == null ? null : List<dynamic>.from(values!.map((x) => x.toJson())),
        'interpretation': interpretation == null ? null : interpretation,
        'symptoms': symptoms == null ? null : List<dynamic>.from(values!.map((x) => x.toJson())),
        'average_heart_rate': averageHearthRate == null ? null : averageHearthRate,
      };

  String toString() => '{values: $values, '
      'period: $period,'
      'interpretation: $interpretation '
      'averageHearthRate: $averageHearthRate '
      'symptoms: $symptoms}';

  @override
  bool operator ==(Object o) {
    return o is ECGData &&
        this.interpretation == o.interpretation &&
        this.period == o.period &&
        this.averageHearthRate == o.averageHearthRate &&
        ListEquality().equals(o.values, values) &&
        ListEquality().equals(o.symptoms, symptoms);
  }

  /// Override required due to overriding the '==' operator
  @override
  int get hashCode => toJson().hashCode;
}
