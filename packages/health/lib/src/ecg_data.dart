part of '../health.dart';

class ECGData {
  List<ECGValue>? values;
  double? period;
  int? interpretation;

  ECGData._({
    this.period,
    this.values,
    this.interpretation,
  });

  factory ECGData.fromRawJson(String str) => ECGData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ECGData.fromJson(Map<String, dynamic> json) => ECGData._(
        period: json['period'] == null ? null : json['period'].toDouble(),
        values:
            json['values'] == null ? null : List<ECGValue>.from(json['values'].map((x) => ECGValue.fromJson(Map<String, dynamic>.from(x)))),
        interpretation: json['interpretation'] == null ? null : json['interpretation'],
      );

  Map<String, dynamic> toJson() => {
        'period': period == null ? null : period,
        'values': values == null ? null : List<dynamic>.from(values!.map((x) => x.toJson())),
        'interpretation': interpretation == null ? null : interpretation,
      };

  String toString() =>
      '{values: $values, '
      'period: $period,'
      'interpretation: $interpretation}';

  @override
  bool operator ==(Object o) {
    return o is ECGData &&
        this.interpretation == o.interpretation &&
        this.period == o.period &&
        ListEquality().equals(o.values, values);
  }

  /// Override required due to overriding the '==' operator
  @override
  int get hashCode => toJson().hashCode;
}


