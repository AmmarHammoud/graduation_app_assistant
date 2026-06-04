import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app_assistant/features/projects/presentation/views/proejct_details_page.dart';
import '../../../../core/services/get_it_service.dart';
import '../../domain/entities/project.dart';
import '../cubit/project_cubit.dart';
import '../cubit/project_details_cubit.dart';
import '../cubit/project_state.dart';

class ProjectsDashboardPage extends StatelessWidget {
  const ProjectsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildFilterTabs(context),
              const SizedBox(height: 16),
              Expanded(child: _buildProjectsList()),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF7F9FC),
      elevation: 0,
      title: const Text(
        'مشاريعي',
        style: TextStyle(color: Color(0xFF0F172A), fontSize: 22, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF0F172A)),
              onPressed: () {},
            ),
            const Positioned(
              top: 12,
              right: 12,
              child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150'),
          ),
        )
      ],
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    final tabs = ['الكل', 'قيد التنفيذ', 'منجز'];
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        String currentTab = 'الكل';
        if (state is ProjectLoaded) currentTab = state.activeFilter;

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final isSelected = tabs[index] == currentTab;
              return GestureDetector(
                onTap: () {
                  // Simply invoking the method on Cubit directly instead of adding an event
                  context.read<ProjectCubit>().loadProjects(tabs[index]);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12.withOpacity(0.05)),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProjectsList() {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is ProjectLoaded) {
          print(state.projects.toString());
          if (state.projects.isEmpty) {
            return const Center(child: Text('لا توجد مشاريع متاحة'));
          }
          return ListView.builder(
            itemCount: state.projects.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => ProjectCard(project: state.projects[index]),
          );
        } else if (state is ProjectError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ProjectCard is identical to the prior implementation...
class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.bottom(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  project.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(top: 12, right: 12, child: _buildStatusBadge())
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(project.location, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('نسبة الإنجاز', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    Text('${(project.completionPercentage * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project.completionPercentage,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Locate TextButton.icon inside your dashboard project card:
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => getIt<ProjectDetailsCubit>()..loadProjectDetails(project.id),
                              child: const ProjectDetailsPage(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back, size: 16, color: Color(0xFF0F172A)),
                      label: const Text('التفاصيل', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                    ),
                    if (project.executionDateText != null)
                      Row(
                        children: [
                          Icon(
                              project.status == ProjectStatus.upcoming ? Icons.access_time : Icons.calendar_today_outlined,
                              size: 14,
                              color: const Color(0xFF94A3B8)
                          ),
                          const SizedBox(width: 4),
                          Text(project.executionDateText!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        ],
                      )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;

    switch (project.status) {
      case ProjectStatus.completed:
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF065F46);
        break;
      case ProjectStatus.upcoming:
        bgColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF475569);
        break;
      case ProjectStatus.inProgress:
      default:
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF10B981);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: textColor),
          const SizedBox(width: 6),
          Text(project.statusLabel ?? '', style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}