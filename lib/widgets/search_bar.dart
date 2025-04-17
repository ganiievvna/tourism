import 'package:flutter/material.dart';

const Color kBeige = Color(0xFFF5E9DA);
const Color kBeigeLight = Color(0xFFFFF7EF);
const Color kBeigeAccent = Color(0xFFD6C1A6);
const Color kBeigeIcon = Color(0xFFBFAE99);

class SearchBarWidget extends StatefulWidget {
  final List<String> cityList;
  final void Function(String query, String? city, String? minPrice, String? maxPrice) onSearch;
  final void Function(double? minRating, String? vacationType)? onRatingAndTypeChanged;

  const SearchBarWidget({
    super.key,
    required this.cityList,
    required this.onSearch,
    this.onRatingAndTypeChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCity;
  String? _minPrice;
  String? _maxPrice;
  double? _minRating;
  String? _selectedVacationType;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  final List<String> _vacationTypes = [
    'Any',
    'Beach vacation',
    'Sightseeing tour',
    'Outdoor activities',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, -0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    _minRating = null;
    _selectedVacationType = _vacationTypes[0];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _selectedCity = null;
      _minPrice = null;
      _maxPrice = null;
      _minRating = null;
      _selectedVacationType = _vacationTypes[0];
      _searchController.clear();
    });
    widget.onSearch('', null, null, null);
  }

  void _applyFilters() {
    widget.onSearch(
      _searchController.text,
      _selectedCity,
      _minPrice,
      _maxPrice,
    );
    if (widget.onRatingAndTypeChanged != null) {
      widget.onRatingAndTypeChanged!(_minRating, _selectedVacationType);
    }
  }

  void _clearFilters() {
    _resetFilters();
    if (widget.onRatingAndTypeChanged != null) {
      widget.onRatingAndTypeChanged!(null, _vacationTypes[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          decoration: BoxDecoration(
            color: kBeige,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search tours... ',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: kBeigeLight,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: kBeigeIcon),
                  ),
                  onSubmitted: (value) => widget.onSearch(value, _selectedCity, _minPrice, _maxPrice),
                ),
              ),
              AnimatedScale(
                scale: (_selectedCity != null && _selectedCity!.isNotEmpty) || (_minPrice != null && _minPrice!.isNotEmpty) || (_maxPrice != null && _maxPrice!.isNotEmpty) || (_minRating != null) || (_selectedVacationType != null && _selectedVacationType != 'Any')
                    ? 1.15
                    : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: IconButton(
                  icon: const Icon(Icons.filter_alt, color: kBeigeIcon),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => DraggableScrollableSheet(
                        initialChildSize: 0.58,
                        minChildSize: 0.32,
                        maxChildSize: 0.85,
                        expand: false,
                        builder: (context, scrollController) => Container(
                          decoration: const BoxDecoration(
                            color: kBeige,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x22000000),
                                blurRadius: 24,
                                offset: Offset(0, -8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Center(
                                child: Container(
                                  width: 48,
                                  height: 5,
                                  margin: const EdgeInsets.only(bottom: 18),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const Text(
                                'Filter Tours',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 18),
                              DropdownButtonFormField<String>(
                                value: _selectedCity,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Cities')),
                                  ...widget.cityList.map((city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city),
                                  )),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _selectedCity = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: const Icon(Icons.location_city, color: kBeigeIcon),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Min Price (KZT)',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        prefixIcon: const Icon(Icons.money, color: kBeigeIcon),
                                      ),
                                      onChanged: (val) => _minPrice = val,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Max Price (KZT)',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        prefixIcon: const Icon(Icons.money_off, color: kBeigeIcon),
                                      ),
                                      onChanged: (val) => _maxPrice = val,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'Min Rating (1-5)',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        prefixIcon: const Icon(Icons.star, color: kBeigeIcon),
                                      ),
                                      onChanged: (val) {
                                        final parsed = double.tryParse(val);
                                        setState(() {
                                          _minRating = (parsed != null && parsed >= 1.0 && parsed <= 5.0) ? parsed : null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedVacationType,
                                items: _vacationTypes.map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                )).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedVacationType = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Vacation Type',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: const Icon(Icons.beach_access, color: kBeigeIcon),
                                ),
                              ),
                              const SizedBox(height: 22),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _applyFilters();
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: kBeigeAccent,
                                        side: const BorderSide(color: kBeigeAccent),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _clearFilters();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: kBeigeAccent,
                                        side: const BorderSide(color: kBeigeAccent),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: const Text('Clear Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
