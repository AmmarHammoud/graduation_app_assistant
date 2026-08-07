import 'package:flutter/material.dart';
import 'package:graduation_app_assistant/core/theme/app_colors.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_proejct_details.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/metric_tile.dart';

class ProgressHeaderCard extends StatelessWidget {
  final AssignedProjectDetails details;

  const ProgressHeaderCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    // Dynamic status colors configuration
    Color statusBgColor = AppColors.border.withOpacity(0.5);
    Color statusTextColor = AppColors.textGrey;
    
    if (details.statusText == 'قيد التنفيذ') {
      statusBgColor = AppColors.accentGold.withOpacity(0.12);
      statusTextColor = AppColors.accentGold;
    } else if (details.statusText == 'منجز') {
      statusBgColor = AppColors.success.withOpacity(0.12);
      statusTextColor = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.015),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
                    backgroundColor: AppColors.border.withOpacity(0.4),
                    color: AppColors.accentGold,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(details.progressPercentage * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Text(
                      'الإنجاز',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
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
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              details.statusText,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: statusTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            details.title,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            details.location,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              color: AppColors.textGrey,
              fontSize: 12,
            ),
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
