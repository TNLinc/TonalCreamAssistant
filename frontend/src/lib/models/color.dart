import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

@JsonSerializable()
class ColorRead {
  /// The generated code assumes these values exist in JSON.
  final String color;

  ColorRead({
    required this.color,
  });

  factory ColorRead.fromJson(Map<String, dynamic> json) =>
      _$ColorFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ColorToJson(this);
}
