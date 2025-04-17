import 'package:flutter/material.dart';

const Color kBeige = Color(0xFFF5E9DA);
const Color kBeigeLight = Color(0xFFFFF7EF);
const Color kBeigeAccent = Color(0xFFD6C1A6);
const Color kBeigeIcon = Color(0xFFBFAE99);

class SelectedPage extends StatefulWidget {
  final String name;
  final String imagePath;
  final String description;
  final String priceRange;
  final String address;
  final String estimate;
  final String vacationType;
  final String howToGetThere;

  const SelectedPage({
    super.key,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.priceRange,
    required this.address,
    required this.estimate,
    required this.vacationType,
    required this.howToGetThere,
  });

  @override
  State<SelectedPage> createState() => _SelectedPageState();
}

class _SelectedPageState extends State<SelectedPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBeigeLight,
      appBar: AppBar(
        title: Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        elevation: 0,
        backgroundColor: kBeigeAccent,
        iconTheme: const IconThemeData(color: Colors.black),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.imagePath,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: Image.asset(
                      widget.imagePath,
                      width: double.infinity,
                      height: 270,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC222222)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  bottom: 20,
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black38)],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kBeige,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: kBeigeAccent.withOpacity(0.13),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 28),
                        _InfoRow(
                          icon: Icons.attach_money,
                          label: 'Price Range',
                          value: widget.priceRange,
                          color: kBeigeAccent,
                          valueStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                          iconBg: kBeigeLight,
                        ),
                        const SizedBox(height: 18),
                        _InfoRow(
                          icon: Icons.location_on,
                          label: 'Address',
                          value: widget.address,
                          color: kBeigeIcon,
                          valueStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          iconBg: kBeigeAccent,
                        ),
                        const SizedBox(height: 18),
                        _InfoRow(
                          icon: Icons.timer,
                          label: 'Estimate',
                          value: widget.estimate,
                          color: kBeigeIcon,
                          valueStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          iconBg: kBeigeLight,
                        ),
                        const SizedBox(height: 18),
                        _InfoRow(
                          icon: Icons.beach_access,
                          label: 'Vacation Type',
                          value: widget.vacationType,
                          color: kBeigeIcon,
                          valueStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          iconBg: kBeigeAccent,
                        ),
                        const SizedBox(height: 18),
                        _InfoRow(
                          icon: Icons.directions,
                          label: 'How to get there',
                          value: widget.howToGetThere,
                          color: kBeigeIcon,
                          valueStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          iconBg: kBeigeLight,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final TextStyle? valueStyle;
  final Color? iconBg;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color = kBeigeIcon,
    this.valueStyle,
    this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBg ?? kBeigeLight,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(7),
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(width: 14),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                height: 1.4,
                letterSpacing: 0.02,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}