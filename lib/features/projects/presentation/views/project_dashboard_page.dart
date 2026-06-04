import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../domain/entities/assigned_project.dart';
import '../cubit/assigned_project_cubit.dart';
import '../cubit/assigned_project_state.dart';

class AssistantDashboardPage extends StatelessWidget {
  const AssistantDashboardPage({super.key});

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
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          title: const Text(
            'مشاريعي المسندة',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE2E8F0),
              child: Icon(Icons.person_outline, color: Colors.black54),
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: filters.map((filter) {
          final isSelected = state.activeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              selectedColor: const Color(0xFF0F172A),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF475569),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
    Color statusBgColor = const Color(0xFFE2E8F0);
    Color statusTextColor = const Color(0xFF475569);
    if (project.statusText == 'قيد التنفيذ') {
      statusBgColor = const Color(0xFFE6F7F4);
      statusTextColor = const Color(0xFF006D5B);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.statusText,
                  style: TextStyle(color: statusTextColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                project.location,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('نسبة الإنجاز', style: TextStyle(fontSize: 13, color: Colors.grey)),
              Text(
                '${(project.progressPercentage * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: project.progressPercentage,
              backgroundColor: const Color(0xFFF1F5F9),
              color: const Color(0xFF006D5B),
              minHeight: 8,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: project.activeWorkItemsCount > 0 ? const Color(0xFF006D5B) : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'بنود قيد التنفيذ: ${project.activeWorkItemsCount}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: project.activeWorkItemsCount > 0 ? const Color(0xFF334155) : Colors.grey,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigation setup to details screen goes here
                },
                child: const Text(
                  'التفاصيل',
                  style: TextStyle(color: Color(0xFF006D5B), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}