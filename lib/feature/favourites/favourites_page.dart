import 'package:flutter/material.dart';
import 'package:tourism/feature/main_page/main_page.dart';
import 'package:tourism/feature/main_page/selected_page.dart'; // Make sure this import is present

class FavouritesPage extends StatefulWidget {
  final List<Tour> favourites;
  final Function(Tour) onFavouriteToggle;

  const FavouritesPage({
    super.key,
    required this.favourites,
    required this.onFavouriteToggle,
  });

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> with SingleTickerProviderStateMixin {
  late final AnimationController _listAnimController;

  static const Color kBeige = Color(0xFFF5E9DA);
  static const Color kBeigeLight = Color(0xFFFFF7EF);
  static const Color kBeigeAccent = Color(0xFFD6C1A6);
  static const Color kBeigeIcon = Color(0xFFBFAE99);

  final Map<String, Map<String, String>> tourDetails = {
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
    'Kolsay Lakes': {
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
    'Kaindy Lake': {
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _FavouritesPageState.kBeigeLight,
            _FavouritesPageState.kBeige,
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: widget.favourites.isEmpty
            ? _AnimatedEmptyFavourites()
            : ListView.builder(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                itemCount: widget.favourites.length,
                itemBuilder: (context, index) {
                  final tour = widget.favourites[index];
                  return AnimatedBuilder(
                    animation: _listAnimController,
                    builder: (context, child) {
                      double animValue = _listAnimController.value - (index * 0.08);
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
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Card(
                              elevation: 7,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                              color: _FavouritesPageState.kBeige,
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(32),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectedPage(
                                        name: tour.name,
                                        imagePath: tour.assetImagePath,
                                        description: tourDetails[tour.name]?['description'] ?? '',
                                        priceRange: '${tour.minPrice} - ${tour.maxPrice} KZT',
                                        address: tourDetails[tour.name]?['address'] ?? '',
                                        estimate: tourDetails[tour.name]?['estimate'] ?? '',
                                        vacationType: tourDetails[tour.name]?['vacationType'] ?? '',
                                        howToGetThere: tourDetails[tour.name]?['howToGetThere'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        bottomLeft: Radius.circular(32),
                                      ),
                                      child: Image.asset(
                                        tour.assetImagePath,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    tour.name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 23,
                                                      letterSpacing: 0.2,
                                                      color: Colors.black,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.favorite, color: _FavouritesPageState.kBeigeAccent, size: 27),
                                                  onPressed: () => widget.onFavouriteToggle(tour),
                                                  splashRadius: 22,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${tour.minPrice} - ${tour.maxPrice} KZT',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color: _FavouritesPageState.kBeigeIcon,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on, color: _FavouritesPageState.kBeigeIcon, size: 19),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    tour.location,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black54,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                ..._buildStarIcons(tour.rating),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "${tour.rating.toStringAsFixed(1)}/5",
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }

  List<Widget> _buildStarIcons(double rating) {
    List<Widget> stars = [];
    if (rating >= 4.8) {
      for (int i = 0; i < 5; i++) {
        stars.add(const Icon(Icons.star, color: _FavouritesPageState.kBeigeAccent, size: 21));
      }
      return stars;
    }
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: _FavouritesPageState.kBeigeAccent, size: 21));
    }
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: _FavouritesPageState.kBeigeAccent, size: 21));
    }
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: _FavouritesPageState.kBeigeAccent, size: 21));
    }
    return stars;
  }
}

class _AnimatedEmptyFavourites extends StatefulWidget {
  @override
  State<_AnimatedEmptyFavourites> createState() => _AnimatedEmptyFavouritesState();
}

class _AnimatedEmptyFavouritesState extends State<_AnimatedEmptyFavourites> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 70, color: _FavouritesPageState.kBeigeAccent),
            SizedBox(height: 18),
            Text(
              "No favourites yet!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            SizedBox(height: 7),
            Text(
              "Tours you favourite will appear here.",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
