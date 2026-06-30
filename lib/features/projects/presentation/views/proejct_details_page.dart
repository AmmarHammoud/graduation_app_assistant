import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app_assistant/features/project_images/presentation/cubits/project_images_cubit.dart';
import 'package:graduation_app_assistant/features/project_images/presentation/views/project_images_page.dart';
import 'package:graduation_app_assistant/features/expenses/presentation/cubits/expenses_cubit.dart';
import 'package:graduation_app_assistant/features/expenses/presentation/views/expenses_page.dart';
import 'package:graduation_app_assistant/features/ai_visualization/presentation/cubits/ai_visualization_cubit.dart';
import 'package:graduation_app_assistant/features/ai_visualization/presentation/views/ai_visualizations_page.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/progress_header_card.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/supervisor_card.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/project_details_widgets/work_item_task_list.dart';

import '../../../../core/services/get_it_service.dart';
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => getIt<ProjectImagesCubit>()..loadImages(details.id),
                                  child: ProjectImagesPage(projectId: details.id, projectName: details.title),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.image_outlined, size: 18, color: Colors.white),
                          label: const Text('صور الوحدة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Tajawal')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => getIt<ExpensesCubit>(),
                                  child: ExpensesPage(
                                    projectId: details.id,
                                    projectName: details.title,
                                    workItems: details.workItems,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.wallet_outlined, size: 18, color: Colors.white),
                          label: const Text('مصاريف الورشة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Tajawal')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006D5B),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => getIt<AiVisualizationCubit>(),
                                ),
                                BlocProvider(
                                  create: (context) => getIt<ProjectImagesCubit>()..loadImages(details.id),
                                ),
                              ],
                              child: AiVisualizationsPage(
                                projectId: details.id,
                                projectName: details.title,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome_outlined, size: 18, color: Colors.white),
                      label: const Text(
                        'تصاميم الذكاء الاصطناعي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF042623), // Beautiful primary dark green
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ),
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