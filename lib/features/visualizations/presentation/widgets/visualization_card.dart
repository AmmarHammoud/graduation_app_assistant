import 'package:flutter/material.dart';
import '../../domain/entities/ai_visualization.dart';

class VisualizationCard extends StatelessWidget {
  final AIVisualization visualization;
  final VoidCallback onTap;

  const VisualizationCard({
    super.key,
    required this.visualization,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Exact format from the mockup (YYYY-MM-DD)
    final dateStr = "${visualization.createdAt.year}-${visualization.createdAt.month.toString().padLeft(2, '0')}-${visualization.createdAt.day.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCD8CF), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.02),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. AI Generated Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 250,
              child: Image.network(
                visualization.generatedImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFFEFECE5),
                    child: Center(
                      child: CircularProgressIndicator(color: theme.primaryColor),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFEFECE5),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image_outlined, size: 48, color: Color(0xFF8B8478)),
                        SizedBox(height: 8),
                        Text(
                          'تعذر تحميل الصورة',
                          style: TextStyle(color: Color(0xFF8B8478), fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Info Block (Title, Date, and Button)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  visualization.title,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Date in YYYY-MM-DD format
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: Color(0xFF8B8478), // Stone
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // "عرض التفاصيل" Full-width Button
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor, // Mutqin Ink Color
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'عرض التفاصيل',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
