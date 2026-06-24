import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/saved_places_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SavedPlacesService.instance,
      builder: (context, _) {
        final allPlaces = SavedPlacesService.instance.savedPlaces;
        final moods = allPlaces.map((p) => p.mood).toSet().toList();
        final filters = ['All', ...moods];
        final places =
            _selectedFilter == 'All' ? allPlaces : allPlaces.where((p) => p.mood == _selectedFilter).toList();

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saved places',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    const Text('Your personal mood collection',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _statPill(value: '${allPlaces.length}', label: 'Saved'),
                        const SizedBox(width: 8),
                        _statPill(value: '${moods.length}', label: 'Moods'),
                      ],
                    ),
                  ],
                ),
              ),
              if (allPlaces.isNotEmpty)
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: filters.map((tab) {
                      final bool active = tab == _selectedFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = tab),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: active ? AppColors.primary : AppColors.borderMedium),
                          ),
                          alignment: Alignment.center,
                          child: Text(tab,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: active ? Colors.white : AppColors.textMuted)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              Expanded(
                child: places.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          final place = places[index];
                          final tagBg = SavedPlacesService.moodBackgrounds[place.mood] ?? AppColors.borderLight;
                          final tagText = SavedPlacesService.moodTextColors[place.mood] ?? AppColors.textMuted;
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
                                        color: place.thumbColor,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(place.emoji, style: const TextStyle(fontSize: 30)),
                                    ),
                                    Positioned(
                                      left: 10,
                                      top: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration:
                                            BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(10)),
                                        child: Text(place.mood,
                                            style: TextStyle(
                                                fontSize: 9.5, fontWeight: FontWeight.w600, color: tagText)),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 8,
                                      child: GestureDetector(
                                        onTap: () => SavedPlacesService.instance.toggle(place),
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                                          child: const Icon(Icons.favorite, size: 14, color: AppColors.secondary),
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
                                      Text(place.name,
                                          style: const TextStyle(
                                              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.star, size: 13, color: Colors.amber[700]),
                                          const SizedBox(width: 2),
                                          Text('${place.rating}',
                                              style: const TextStyle(fontSize: 11, color: AppColors.textDark)),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.location_on_outlined,
                                              size: 12, color: AppColors.textMuted),
                                          const SizedBox(width: 2),
                                          Text('${place.distanceKm} km away',
                                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
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
        );
      },
    );
  }

  Widget _statPill({required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9.5)),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 40, color: AppColors.borderMedium),
            const SizedBox(height: 12),
            const Text('No saved places yet',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text(
              'Tap the heart icon on any place in Discover to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}