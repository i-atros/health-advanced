part of '../health.dart';

class ECGValue {
  ECGValue({
    this.voltage,
    this.timeSinceStart,
  });

  double? voltage;
  double? timeSinceStart;

  int get inMicroVolts => voltage != null ? (voltage! * pow(10,6)).toInt() : 0;

  factory ECGValue.fromRawJson(String str) => ECGValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ECGValue.fromJson(Map<String, dynamic> json) => ECGValue(
    voltage: json['voltage'] == null ? null : json['voltage'].toDouble(),
    timeSinceStart: json['timeSinceStart'] == null ? null : json['timeSinceStart'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'voltage': voltage == null ? null : voltage,
    'timeSinceStart': timeSinceStart == null ? null : timeSinceStart,
  };

  String toString() =>
      '{voltage: $voltage, '
          'timeSinceStart: $timeSinceStart}';
}