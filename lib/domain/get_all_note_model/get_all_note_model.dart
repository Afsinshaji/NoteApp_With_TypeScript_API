import 'package:json_annotation/json_annotation.dart';
import 'package:note_app/domain/note_model/note_model.dart';



part 'get_all_note_model.g.dart';

@JsonSerializable()
class GetAllNoteModel {
   @JsonKey(name: 'data')
  List<NoteModel> data;

  GetAllNoteModel({this.data= const []});

  factory GetAllNoteModel.fromJson(Map<String, dynamic> json) {
    return _$GetAllNoteModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetAllNoteModelToJson(this);
}
