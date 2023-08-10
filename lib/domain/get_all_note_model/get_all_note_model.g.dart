// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllNoteModel _$GetAllNoteModelFromJson(Map<String, dynamic> json) =>
    GetAllNoteModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GetAllNoteModelToJson(GetAllNoteModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
