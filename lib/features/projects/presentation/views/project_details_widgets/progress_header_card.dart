import 'package:flutter/material.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_proejct_details.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/metric_tile.dart';

class ProgressHeaderCard extends StatelessWidget {
  final AssignedProjectDetails details;

  const ProgressHeaderCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress Indicator corresponding to image_f15223 layout design
          SizedBox(
            height: 140,
            width: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: CircularProgressIndicator(
                    value: details.progressPercentage,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFFF1F5F9),
                    color: const Color(0xFF006D5B),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(details.progressPercentage * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    const Text(
                      'الإنجاز',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7F4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              details.statusText,
              style: const TextStyle(
                color: Color(0xFF006D5B),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            details.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            details.location,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  icon: Icons.height_rounded,
                  label: 'الارتفاع',
                  value: details.heightText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricTile(
                  icon: Icons.square_foot_rounded,
                  label: 'المساحة',
                  value: details.areaText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
