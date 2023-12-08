// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as int,
      name: json['login'] as String,
      htmlUrl: Uri.parse(json['html_url'] as String),
      avatarUrl: Uri.parse(json['avatar_url'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.name,
      'html_url': instance.htmlUrl.toString(),
      'avatar_url': instance.avatarUrl.toString(),
    };
