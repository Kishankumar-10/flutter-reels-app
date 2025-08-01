import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';

class CategoryCard extends StatelessWidget {
  final VideoCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.white : Colors.grey[800]!, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 12),
              Text(category.name, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? Colors.black : Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}