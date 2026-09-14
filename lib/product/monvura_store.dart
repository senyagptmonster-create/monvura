import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MonvuraStore extends ChangeNotifier {
  List<dynamic> journals = [];
  Map<String, dynamic> chronotype = {};

  MonvuraStore() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('monvura_data');
    if (data != null) {
      final map = jsonDecode(data);
      journals = map['journals'] ?? [];
      chronotype = map['chronotype'] ?? {};
      notifyListeners();
    }
  }

  Future<void> addJournal(String text) async {
    journals.add({"text": text, "date": DateTime.now().toIso8601String()});
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('monvura_data', jsonEncode({'journals': journals, 'chronotype': chronotype}));
  }
}
