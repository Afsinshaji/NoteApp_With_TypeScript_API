import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:note_app/domain/data.dart';
import 'package:note_app/domain/get_all_note_model/get_all_note_model.dart';
import 'package:note_app/domain/note_model/note_model.dart';
import 'package:note_app/domain/url.dart';

class NoteDB extends ApiCalls {
  //----Single ton

  NoteDB.internal();
  static NoteDB intstance = NoteDB.internal();
  NoteDB factory() {
    return intstance;
  }

  //----end
  final dio = Dio();
  final url = Url();

  ValueNotifier<List<NoteModel>> noteListNotifier = ValueNotifier([]);
  NoteDB() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }
  @override
  Future<NoteModel?> createNote(NoteModel note) async {
    final result = await dio.post(url.createNote, data: note.toJson());
    final resultData =
        NoteModel.fromJson(jsonDecode(result.data) as Map<String, dynamic>);
    noteListNotifier.value.insert(0, resultData);
    return resultData;
  }

  @override
  Future<void> deleteNote(String id) async {
    final result = await dio.delete(url.deleteNote.replaceFirst('{id}', id));
    if (result.data == null) {
      return;
    }
    //find index
    final index =
        noteListNotifier.value.indexWhere((element) => element.id == id);
    if (index == -1) {
      return;
    }
    //remove element at that index
    noteListNotifier.value.removeAt(index);
    // noteListNotifier.notifyListeners();
    return;
  }

  @override
  Future<List<NoteModel>> getAllNote() async {
    final result = await dio.get(url.getAllNote);

    if (result.data == null) {
      noteListNotifier.value.clear();
      return [];
    } else {
      final resultAsJson = jsonDecode(result.data);
      final resultData = GetAllNoteModel.fromJson(resultAsJson);
      noteListNotifier.value.clear();
      noteListNotifier.value.addAll(resultData.data.reversed);
      return resultData.data;
    }
  }

  @override
  Future<NoteModel?> updateNote(NoteModel note) async {
    final result = await dio.put(url.updateNote, data: note.toJson());
    if (result.data == null) {
      return null;
    }
    //find index
    final index =
        noteListNotifier.value.indexWhere((element) => element.id == note.id);
    if (index == -1) {
      return null;
    }
    //remove from index
    noteListNotifier.value.removeAt(index);
    //insert the new value at that index
    noteListNotifier.value.insert(index, note);

    // noteListNotifier.notifyListeners();
    return result.data;
  }

  NoteModel? getNoteById(String id) {
    try {
      return noteListNotifier.value.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }
}
