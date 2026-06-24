import 'package:flutter/material.dart';

class SavedPlace {
  final String name;
  final String emoji;
  final Color thumbColor;
  final double rating;
  final double distanceKm;
  final String mood;

  SavedPlace({
    required this.name,
    required this.emoji,
    required this.thumbColor,
    required this.rating,
    required this.distanceKm,
    required this.mood,
  });
}

class SavedPlacesService extends ChangeNotifier {
  SavedPlacesService._internal();
  static final SavedPlacesService instance = SavedPlacesService._internal();

  final List<SavedPlace> _savedPlaces = [];

  List<SavedPlace> get savedPlaces => List.unmodifiable(_savedPlaces);

  bool isSaved(String name) => _savedPlaces.any((p) => p.name == name);

  void toggle(SavedPlace place) {
    if (isSaved(place.name)) {
      _savedPlaces.removeWhere((p) => p.name == place.name);
    } else {
      _savedPlaces.insert(0, place);
    }
    notifyListeners();
  }

  static const Map<String, Color> moodBackgrounds = {
    'Happy': Color(0xFFFFF8E1),
    'Relaxed': Color(0xFFE8F5F0),
    'Adventurous': Color(0xFFFFF0E8),
    'Romantic': Color(0xFFFDE8EF),
    'Social': Color(0xFFEEF0FF),
    'Need Comfort': Color(0xFFE8EDF5),
  };

  static const Map<String, Color> moodTextColors = {
    'Happy': Color(0xFFB37D00),
    'Relaxed': Color(0xFF1A7A56),
    'Adventurous': Color(0xFFBF4E14),
    'Romantic': Color(0xFFB02355),
    'Social': Color(0xFF4840B8),
    'Need Comfort': Color(0xFF3D5280),
  };
}