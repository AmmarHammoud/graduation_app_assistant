import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app_assistant/core/theme/app_colors.dart';
import 'package:graduation_app_assistant/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:graduation_app_assistant/features/profile/presentation/views/profile_view.dart';
import 'package:graduation_app_assistant/features/projects/presentation/cubit/assigned_project_details_cubit.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/proejct_details_page.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../../core/services/get_it_service.dart';
import '../../domain/entities/assigned_project.dart';
import '../cubit/assigned_project_cubit.dart';
import '../cubit/assigned_project_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/views/notifications_page.dart';

class AssistantDashboardPage extends StatelessWidget {
  const AssistantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, color: Theme.of(context).primaryColor),
            onPressed: () {},
          ),
          title: Text(
            'مشاريعي المسندة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none_outlined, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => getIt<NotificationsCubit>()..loadNotifications(),
                      child: const NotificationsPage(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => getIt<ProfileCubit>()..getProfile(),
                      child: const ProfileView(),
                    ),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFE2E8F0),
                child: Icon(Icons.person_outline, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: BlocBuilder<AssignedProjectsCubit, AssignedProjectsState>(
          builder: (context, state) {
            if (state is AssignedProjectsLoading) {
              print('00000000000000000000000000000000000000000000000000');
              return const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [Colors.red],
                strokeWidth: 2,
              );
            }
            if (state is AssignedProjectsLoaded) {
              return Column(
                children: [
                  _buildFilterChipsRow(context, state),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.filteredProjects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(context, state.filteredProjects[index]);
                      },
                    ),
                  ),
                ],
              );
            }
            if (state is AssignedProjectsError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('بدء تهيئة لوحة التحكم...'));
          },
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow(BuildContext context, AssignedProjectsLoaded state) {
    final filters = ['الكل', 'قيد التنفيذ', 'منجز'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: filters.map((filter) {
          final isSelected = state.activeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.form,
              labelStyle: TextStyle(
                fontFamily: 'Tajawal',
                color: isSelected ? Colors.white : AppColors.textGrey,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : AppColors.border,
                  width: 0.8,
                ),
              ),
              onSelected: (_) {
                context.read<AssignedProjectsCubit>().loadDashboard(filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, AssignedProject project) {
    // Dynamic status colors configuration
    Color statusBgColor = AppColors.border.withOpacity(0.5);
    Color statusTextColor = AppColors.textGrey;
    
    if (project.statusText == 'قيد التنفيذ') {
      statusBgColor = AppColors.accentGold.withOpacity(0.12);
      statusTextColor = AppColors.accentGold;
    } else if (project.statusText == 'منجز') {
      statusBgColor = AppColors.success.withOpacity(0.12);
      statusTextColor = AppColors.success;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.title,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.statusText,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: statusTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 4),
              Text(
                project.location,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'نسبة الإنجاز',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                '${(project.progressPercentage * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: project.progressPercentage,
              backgroundColor: AppColors.border.withOpacity(0.4),
              color: AppColors.accentGold,
              minHeight: 6,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              //   children: [
              //     Icon(
              //       Icons.calendar_today_outlined,
              //       size: 16,
              //       color: project.activeWorkItemsCount > 0 ? AppColors.accentGold : AppColors.textGrey,
              //     ),
              //     const SizedBox(width: 6),
              //     Text(
              //       'بنود قيد التنفيذ: ${project.activeWorkItemsCount}',
              //       style: TextStyle(
              //         fontFamily: 'Tajawal',
              //         fontSize: 12,
              //         fontWeight: FontWeight.w500,
              //         color: project.activeWorkItemsCount > 0 ? AppColors.textDark : AppColors.textGrey,
              //       ),
              //     ),
              //   ],
              // ),
              TextButton(
                onPressed: () {
                  // Navigation setup to details screen goes here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => getIt<AssignedProjectDetailsCubit>()..loadProjectDetails(project.id),
                        child: const AssistantProjectDetailsPage(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'التفاصيل',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}