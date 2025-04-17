import 'package:flutter/material.dart';

const Color kBeige = Color(0xFFF5E9DA);
const Color kBeigeLight = Color(0xFFFFF7EF);
const Color kBeigeAccent = Color(0xFFD6C1A6);
const Color kBeigeIcon = Color(0xFFBFAE99);

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBeige,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        child: BottomNavigationBar(
          backgroundColor: kBeige,
          currentIndex: currentIndex,
          onTap: onTap,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kBeigeIcon,
          unselectedItemColor: kBeigeAccent,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            _AnimatedNavBarItem(
              icon: Icons.home,
              label: 'Home',
              selected: currentIndex == 0,
            ),
            _AnimatedNavBarItem(
              icon: Icons.favorite,
              label: 'Favourites',
              selected: currentIndex == 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedNavBarItem extends BottomNavigationBarItem {
  _AnimatedNavBarItem({
    required IconData icon,
    required String label,
    required bool selected,
  }) : super(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            padding: selected ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6) : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: selected
                ? BoxDecoration(
                    color: kBeigeLight,
                    borderRadius: BorderRadius.circular(14),
                  )
                : null,
            child: Icon(icon, size: 26, color: selected ? kBeigeIcon : kBeigeAccent),
          ),
          label: label,
        );
}
