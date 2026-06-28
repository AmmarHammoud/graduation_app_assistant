import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/progress_header_card.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/supervisor_card.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/work_item_task_list.dart';

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
                  ProgressHeaderCard(details: details),
                  const SizedBox(height: 12),
                  SupervisorCard(details: details),
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
                  WorkItemTaskList(workItems: details.workItems)
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
}