import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/assigned_proejct_details.dart';
import '../cubit/assigned_project_details_cubit.dart';
import '../cubit/assigned_project_details_state.dart';


class AssistantProjectDetailsPage extends StatelessWidget {
  const AssistantProjectDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تفاصيل المشروع',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AssignedProjectDetailsCubit, AssignedProjectDetailsState>(
          builder: (context, state) {
            if (state is AssignedProjectDetailsLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF006D5B)));
            }
            if (state is AssignedProjectDetailsLoaded) {
              final details = state.details;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildProgressHeaderCard(details),
                  const SizedBox(height: 12),
                  _buildSupervisorCard(details),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'قائمة الأعمال',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Row(
                          children: [
                            Icon(Icons.filter_list_rounded, size: 18, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text('فلترة', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildWorkItemsTaskList(details.workItems),
                ],
              );
            }
            if (state is AssignedProjectDetailsError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('جاري تهيئة تفاصيل المشروع...'));
          },
        ),
      ),
    );
  }

  Widget _buildProgressHeaderCard(AssignedProjectDetails details) {
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
          )
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    const Text('الإنجاز', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
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
              style: const TextStyle(color: Color(0xFF006D5B), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Text(details.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 2),
          Text(details.location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildMetricTile(Icons.height_rounded, 'الارتفاع', details.heightText)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricTile(Icons.square_foot_rounded, 'المساحة', details.areaText)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMetricTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF006D5B)),
              const SizedBox(width: 6),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSupervisorCard(AssignedProjectDetails details) {
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

  Widget _buildWorkItemsTaskList(List<AssistantWorkItemEntity> workItems) {
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