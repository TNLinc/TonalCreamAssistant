import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class ProductRead {
  /// The generated code assumes these values exist in JSON.
  final String name, color, id, url;
  final int type;

  ProductRead(
      {required this.name,
      required this.type,
      required this.color,
      required this.id,
      required this.url});

  factory ProductRead.fromJson(Map<String, dynamic> json) =>
      _$ProductReadFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductReadToJson(this);
}
