import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/firestore_service.dart';
import '../services/user_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverScreen extends StatefulWidget {
  final String initialMood;

  const DiscoverScreen({super.key, this.initialMood = 'Adventurous'});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _Place {
  final String name;
  final String emoji;
  final Color color;
  final double rating;
  final double distanceKm;

  _Place({
    required this.name,
    required this.emoji,
    required this.color,
    required this.rating,
    required this.distanceKm,
  });
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late String _selectedMood;
  final Map<int, String> _savedPlaceIds = {};

  final List<_Place> _places = [
    _Place(
      name: 'Hidden Rooftop Café',
      emoji: '☕',
      color: const Color(0xFFD4CCF8),
      rating: 4.8,
      distanceKm: 1.2,
    ),
    _Place(
      name: 'Indoor Arcade Night',
      emoji: '🕹️',
      color: const Color(0xFFFDE3CB),
      rating: 4.6,
      distanceKm: 2.4,
    ),
    _Place(
      name: 'Sunset Hiking Spot',
      emoji: '🥾',
      color: const Color(0xFFC5EDD8),
      rating: 4.9,
      distanceKm: 5.1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
    _loadSavedPlaces();
  }

  Future<void> _loadSavedPlaces() async {
    final userId = UserSession.userId;
    if (userId == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('saved_places')
        .where('userId', isEqualTo: userId)
        .get();
    if (!mounted) return;
    setState(() {
      for (final doc in snapshot.docs) {
        final name = doc.data()['name'] as String?;
        final index = _places.indexWhere((p) => p.name == name);
        if (index != -1) _savedPlaceIds[index] = doc.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, Color(0xFFFFB3CC)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Navigator.canPop(context))
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white70,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),
                  Text(
                    'Feeling $_selectedMood',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_places.length} places match your mood near you',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: ['All', 'Cafés', 'Outdoors', 'Nightlife'].map((tab) {
                  final bool active = tab == 'All';
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active
                            ? AppColors.primary
                            : AppColors.borderMedium,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : AppColors.textMuted,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: _places.length,
                itemBuilder: (context, index) {
                  final place = _places[index];
                  final bool isSaved = _savedPlaceIds.containsKey(index);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: place.color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                place.emoji,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 8,
                              child: GestureDetector(
                                onTap: () async {
                                  final userId = UserSession.userId;
                                  if (userId == null) return;
                                  if (_savedPlaceIds.containsKey(index)) {
                                    await FirestoreService.deletePlace(
                                      _savedPlaceIds[index]!,
                                      userId,
                                    );
                                    setState(
                                      () => _savedPlaceIds.remove(index),
                                    );
                                  } else {
                                    final docId =
                                        await FirestoreService.savePlace(
                                          userId: userId,
                                          name: place.name,
                                          emoji: place.emoji,
                                          rating: place.rating,
                                          distanceKm: place.distanceKm,
                                          mood: _selectedMood,
                                        );
                                    setState(
                                      () => _savedPlaceIds[index] = docId,
                                    );
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.9,
                                  ),
                                  child: Icon(
                                    isSaved
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 13,
                                    color: Colors.amber[700],
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${place.rating}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 12,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${place.distanceKm} km away',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
