import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/get_it_service.dart';
import '../../../domain/entities/assigned_proejct_details.dart';
import '../../cubit/item_update_cubit.dart';
import '../update_project_progress_page.dart';

class WorkItemTaskList extends StatelessWidget {
  final List<AssistantWorkItemEntity> workItems;
  const WorkItemTaskList({super.key, required this.workItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workItems.length,
      itemBuilder: (context, index) {
        final item = workItems[index];

        Color badgeBgColor = const Color(0xFFF1F5F9);
        Color badgeTextColor = const Color(0xFF64748B);

        if (item.statusLabel == 'مكتمل') {
          badgeBgColor = const Color(0xFFE6F7F4);
          badgeTextColor = const Color(0xFF006D5B);
        } else if (item.statusLabel == 'قيد التنفيذ') {
          badgeBgColor = const Color(0xFFEFF6FF);
          badgeTextColor = const Color(0xFF2563EB);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: item.canUpdate
                ? Border.all(color: const Color(0xFF006D5B).withOpacity(0.6), width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.005),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: item.statusLabel == 'مكتمل' ? const Color(0xFFE6F7F4) : const Color(0xFFF1F5F9),
                    child: Text(
                      '${item.sequenceNumber}',
                      style: TextStyle(
                        color: item.statusLabel == 'مكتمل' ? const Color(0xFF006D5B) : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: item.statusLabel == 'لم يبدأ' ? Colors.grey.shade400 : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: badgeBgColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.statusLabel == 'قيد التنفيذ'
                                    ? 'قيد التنفيذ - ${(item.completionPercent * 100).toStringAsFixed(0)}%'
                                    : item.statusLabel,
                                style: TextStyle(color: badgeTextColor, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              '${item.commentCount}',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (item.canUpdate)
                    ElevatedButton(
                      onPressed: () {
                        // Open update contextual actions panel sheet layout configuration
                        // Inside AssistantProjectDetailsPage -> _buildWorkItemsTaskList -> ElevatedButton
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              // We initialize the factory and cascade call loadItemDetails passing the item's ID
                              create: (context) => getIt<ItemUpdateCubit>()..loadItemDetails(item.id.toString()),
                              child: const UpdateProjectProgressPage(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('تحديث', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    )
                  else if (item.statusLabel == 'مكتمل')
                    Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey.shade400)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'معلق',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              if (item.canUpdate) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: item.completionPercent,
                    backgroundColor: const Color(0xFFF1F5F9),
                    color: const Color(0xFF006D5B),
                    minHeight: 6,
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
