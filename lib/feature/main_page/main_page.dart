// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tourism/widgets/bottom_nav_bar.dart';
import 'package:tourism/feature/favourites/favourites_page.dart';
import 'package:tourism/widgets/search_bar.dart';
import 'package:tourism/feature/main_page/selected_page.dart';

const Color kBeige = Color(0xFFF5E9DA);
const Color kBeigeLight = Color(0xFFFFF7EF);
const Color kBeigeDark = Color(0xFFE5D3B3);
const Color kBeigeAccent = Color(0xFFD6C1A6);
const Color kBeigeIcon = Color(0xFFBFAE99);
const Color kBrown = Color(0xFF6D4C3D);
const Color kOrangeAccent = Color(0xFFFFA726);
const Color kOlive = Color(0xFF8D8741);
const Color kTealMuted = Color(0xFF7FB3A6);
const Color kDeepPurple = Color(0xFF7A5CFA);

void main() {
  runApp(const TouristApp());
}

class TouristApp extends StatelessWidget {
  const TouristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: kBrown,
      ),
      home: const MainPage(),
    );
  }
}

class Tour {
  final String name;
  final String assetImagePath;
  final int minPrice;
  final int maxPrice;
  final String location;
  final double rating;
  final String vacation_type;
  bool isFavorite;

  Tour({
    required this.name,
    required this.assetImagePath,
    required this.minPrice,
    required this.maxPrice,
    required this.location,
    required this.rating,
    required this.vacation_type,
    this.isFavorite = false,
  });
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _searchCity;
  String? _searchMinPrice;
  String? _searchMaxPrice;
  double? _searchMinRating;
  String? _searchVacationType;
  late final AnimationController _listAnimController;

  List<Tour> tours = [
    Tour(name: "Medeu", assetImagePath: "assets/images/medeu.jpg", minPrice: 5000, maxPrice: 10000, location: "Almaty", rating: 4.8, vacation_type: "Outdoor activities"),
    Tour(name: "Shymbulak", assetImagePath: "assets/images/shymbulak.jpg", minPrice: 10000, maxPrice: 20000, location: "Almaty", rating: 3.0, vacation_type: "Outdoor activities"),
    Tour(name: "Kolsay", assetImagePath: "assets/images/kolsay.jpg", minPrice: 30000, maxPrice: 60000, location: "Almaty Region", rating: 5.0, vacation_type: "Outdoor activities"),
    Tour(name: "Bozhyra", assetImagePath: "assets/images/bozhyra.jpg", minPrice: 70000, maxPrice: 120000, location: "Mangystau", rating: 3.3, vacation_type: "Sightseeing tour"),
    Tour(name: "Katon Karagay", assetImagePath: "assets/images/katonkaragay.jpg", minPrice: 100000, maxPrice: 180000, location: "East Kazakhstan", rating: 4.5, vacation_type: "Outdoor activities"),
    Tour(name: "Turkistan", assetImagePath: "assets/images/turkistan.jpg", minPrice: 30000, maxPrice: 60000, location: "Turkistan", rating: 4.2, vacation_type: "Sightseeing tour"),
    Tour(name: "Kaindy", assetImagePath: "assets/images/kaindy.jpg", minPrice: 25000, maxPrice: 40000, location: "Almaty Region", rating: 3.7, vacation_type: "Outdoor activities"),
    Tour(name: "Altyn Emel", assetImagePath: "assets/images/altyn_emel.jpg", minPrice: 40000, maxPrice: 70000, location: "Almaty Region", rating: 5.0, vacation_type: "Sightseeing tour"),
  ];

  List<Tour> get _filteredTours {
    List<Tour> filtered = tours;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((tour) => tour.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    if (_searchCity != null && _searchCity!.isNotEmpty) {
      filtered = filtered.where((tour) => tour.location == _searchCity).toList();
    }
    int? min = _searchMinPrice != null && _searchMinPrice!.isNotEmpty
        ? int.tryParse(_searchMinPrice!.replaceAll(RegExp(r'[^0-9]'), ''))
        : null;
    int? max = _searchMaxPrice != null && _searchMaxPrice!.isNotEmpty
        ? int.tryParse(_searchMaxPrice!.replaceAll(RegExp(r'[^0-9]'), ''))
        : null;
    if (min != null || max != null) {
      filtered = filtered.where((tour) {
        // Show only tours whose range overlaps with the filter range
        // That is: tourMin <= max && tourMax >= min
        bool passesMin = min == null ? true : tour.maxPrice >= min;
        bool passesMax = max == null ? true : tour.minPrice <= max;
        return passesMin && passesMax;
      }).toList();
    }
    if (_searchMinRating != null) {
      filtered = filtered.where((tour) => tour.rating >= _searchMinRating!).toList();
    }
    if (_searchVacationType != null && _searchVacationType!.isNotEmpty && _searchVacationType != 'Any') {
      filtered = filtered.where((tour) {
        final details = _tourDetails[tour.name];
        return details != null && details['vacationType'] == _searchVacationType;
      }).toList();
    }
    return filtered;
  }

  List<String> get _kazakhstanCities {
    return [
      'Almaty',
      'Almaty Region',
      'Mangystau',
      'East Kazakhstan',
      'Turkistan',
      // Add more cities if needed
    ];
  }

  final Map<String, Map<String, String>> _tourDetails = {
    'Medeu': {
      'description': 'Medeu is a high-mountain sports complex near Almaty, famous for its ice skating rink and beautiful mountain views.',
      'address': 'Gornaya St 465, Medeu District, Almaty',
      'estimate': '5,000 – 10,000 KZT per visit',
      'vacationType': 'Outdoor activities',
      'howToGetThere': 'Take a taxi or bus from Almaty city center to Medeu sports complex.',
    },
    'Shymbulak': {
      'description': 'Shymbulak is a popular ski resort located in the picturesque Zailiyskiy Alatau mountains.',
      'address': 'Gornaya St 640, Almaty',
      'estimate': '10,000 – 20,000 KZT per day',
      'vacationType': 'Outdoor activities',
      'howToGetThere': 'Take a cable car from Medeu or drive from Almaty.',
    },
    'Kolsay': {
      'description': 'Kolsay Lakes are a series of three alpine lakes in the northern Tien Shan mountains, perfect for hiking and camping.',
      'address': 'Kolsay Lakes National Park, Almaty Region',
      'estimate': '30,000 – 60,000 KZT per trip',
      'vacationType': 'Outdoor activities',
      'howToGetThere': 'Drive from Almaty (about 5 hours) or join a tour group.',
    },
    'Bozhyra': {
      'description': 'Bozhyra is a stunning canyon in the Mangystau region, known for its unique rock formations and breathtaking views.',
      'address': 'Bozhyra Tract, Mangystau',
      'estimate': '70,000 – 120,000 KZT per trip',
      'vacationType': 'Sightseeing tour',
      'howToGetThere': 'Best reached by 4x4 vehicle from Aktau; tours available.',
    },
    'Katon Karagay': {
      'description': 'Katon Karagay National Park offers pristine nature, mountains, and rivers ideal for eco-tourism.',
      'address': 'Katon-Karagay District, East Kazakhstan',
      'estimate': '100,000 – 180,000 KZT per trip',
      'vacationType': 'Outdoor activities',
      'howToGetThere': 'Fly to Ust-Kamenogorsk, then drive or take a tour to the park.',
    },
    'Turkistan': {
      'description': 'Turkistan is a historic city famous for the Mausoleum of Khoja Ahmed Yasawi, a UNESCO World Heritage site.',
      'address': 'Turkistan, Turkistan Region',
      'estimate': '30,000 – 60,000 KZT per trip',
      'vacationType': 'Sightseeing tour',
      'howToGetThere': 'Direct train or bus from major cities, or fly to Turkistan airport.',
    },
    'Kaindy': {
      'description': 'Kaindy Lake is renowned for its submerged forest and crystal-clear waters, a unique natural wonder.',
      'address': 'Kaindy Lake, Almaty Region',
      'estimate': '25,000 – 40,000 KZT per trip',
      'vacationType': 'Outdoor activities',
      'howToGetThere': 'Drive from Almaty (about 4 hours) or join a guided tour.',
    },
    'Altyn Emel': {
      'description': 'Altyn Emel National Park is famous for its Singing Dunes and diverse wildlife.',
      'address': 'Altyn Emel National Park, Almaty Region',
      'estimate': '40,000 – 70,000 KZT per trip',
      'vacationType': 'Sightseeing tour',
      'howToGetThere': 'Drive from Almaty (about 4 hours) or book a tour.',
    },
  };

  void _toggleFavourite(Tour tour) {
    setState(() {
      tour.isFavorite = !tour.isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _listAnimController.forward();
  }

  @override
  void dispose() {
    _listAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget pageContent;
    if (_selectedIndex == 1) {
      final favourites = tours.where((tour) => tour.isFavorite).toList();
      pageContent = FavouritesPage(
        favourites: favourites,
        onFavouriteToggle: _toggleFavourite,
      );
    } else {
      pageContent = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kBeige,
              kBeigeLight.withOpacity(0.7),
              kBeigeLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SearchBarWidget(
                  cityList: _kazakhstanCities,
                  onSearch: (query, city, minPrice, maxPrice) {
                    setState(() {
                      _searchQuery = query;
                      _searchCity = city;
                      _searchMinPrice = minPrice;
                      _searchMaxPrice = maxPrice;
                    });
                  },
                  onRatingAndTypeChanged: (double? minRating, String? vacationType) {
                    setState(() {
                      _searchMinRating = minRating;
                      _searchVacationType = vacationType;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _filteredTours.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('😢', style: TextStyle(fontSize: 64)),
                              SizedBox(height: 16),
                              Text('There is no existing tour', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredTours.length,
                          itemBuilder: (context, index) {
                            final tour = _filteredTours[index];
                            return AnimatedBuilder(
                              animation: _listAnimController,
                              builder: (context, child) {
                                double animValue = _listAnimController.value - (index * 0.07);
                                if (_listAnimController.status == AnimationStatus.completed || animValue >= 1.0) {
                                  animValue = 1.0;
                                } else if (animValue <= 0.0) {
                                  animValue = 0.0;
                                }
                                return Opacity(
                                  opacity: animValue,
                                  child: Transform.translate(
                                    offset: Offset(0, 40 * (1 - animValue)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SelectedPage(
                                                name: tour.name,
                                                imagePath: tour.assetImagePath,
                                                description: _tourDetails[tour.name]?['description'] ?? '',
                                                priceRange: '${tour.minPrice} - ${tour.maxPrice} KZT',
                                                address: _tourDetails[tour.name]?['address'] ?? '',
                                                estimate: _tourDetails[tour.name]?['estimate'] ?? '',
                                                vacationType: _tourDetails[tour.name]?['vacationType'] ?? '',
                                                howToGetThere: _tourDetails[tour.name]?['howToGetThere'] ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: TourCard(
                                          tour: tour,
                                          onFavoriteToggle: () => _toggleFavourite(tour),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            _selectedIndex == 0 ? 'Tourist Platform' : 'Favourites',
            key: ValueKey(_selectedIndex),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBeigeAccent.withOpacity(0.95),
        foregroundColor: kBeigeIcon,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
      ),
      body: pageContent,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              _listAnimController.reset();
              _listAnimController.forward();
            }
          });
        },
      ),
    );
  }
}

class TourCard extends StatelessWidget {
  final Tour tour;
  final VoidCallback onFavoriteToggle;

  const TourCard({
    super.key,
    required this.tour,
    required this.onFavoriteToggle,
  });

  List<Widget> _buildStarIcons(double rating) {
    List<Widget> stars = [];
    if (rating >= 4.8) {
      for (int i = 0; i < 5; i++) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
      }
      return stars;
    }
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
    }
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
    }
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      clipBehavior: Clip.antiAlias,
      color: kBeige,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: tour.assetImagePath,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: Image.asset(
                    tour.assetImagePath,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: kBeigeAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kBeigeAccent.withOpacity(0.16),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      tour.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: tour.isFavorite ? Colors.redAccent : kBeigeIcon,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              tour.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, letterSpacing: 0.3, color: kBrown),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${tour.minPrice} - ${tour.maxPrice} KZT',
              style: const TextStyle(color: kOrangeAccent, fontSize: 19, fontWeight: FontWeight.w600, letterSpacing: 0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kBeigeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.location_on, color: kBeigeIcon, size: 21),
                ),
                const SizedBox(width: 5),
                Text(
                  tour.location,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: kDeepPurple),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kBeigeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.beach_access, color: kBeigeIcon, size: 18),
                ),
                const SizedBox(width: 4),
                Text(
                  tour.vacation_type,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kOlive),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 13),
            child: Row(
              children: [
                ..._buildStarIcons(tour.rating),
                const SizedBox(width: 9),
                Text(
                  "${tour.rating.toStringAsFixed(1)}/5",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: kTealMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
