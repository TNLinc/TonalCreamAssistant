// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductRead _$ProductReadFromJson(Map<String, dynamic> json) => ProductRead(
      name: json['name'] as String,
      type: json['type'] as int,
      color: json['color'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$ProductReadToJson(ProductRead instance) =>
    <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'id': instance.id,
      'type': instance.type,
    };
