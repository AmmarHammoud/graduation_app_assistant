import 'package:flutter/material.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_proejct_details.dart';
class SupervisorCard extends StatelessWidget {
  final AssignedProjectDetails details;
  const SupervisorCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark slate/navy block matching layout specification
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.15),
            child: const Icon(Icons.person_outline_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('المشرف المسؤول', style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text(
                  details.supervisorName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0F172A),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('تواصل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          )
        ],
      ),
    );
  }
}
