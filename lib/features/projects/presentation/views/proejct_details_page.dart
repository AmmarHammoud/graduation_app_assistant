import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/proejct_details.dart';
import '../cubit/project_details_cubit.dart';
import '../cubit/project_details_state.dart';

class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapped in Directionality to strictly enforce Right-to-Left formatting
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
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
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
            builder: (context, state) {
              if (state is ProjectDetailsLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF006D5B)));
              }
              if (state is ProjectDetailsLoaded) {
                final details = state.details;

                return Column(
                  children: [
                    _buildHeaderSummaryCard(details),
                    const TabBar(
                      indicatorColor: Color(0xFF006D5B),
                      labelColor: Color(0xFF006D5B),
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      tabs: [
                        Tab(text: 'الفراغات'),
                        Tab(text: 'بنود العمل'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildSpacesView(details.spaces),
                          _buildWorkItemsView(details.workItems),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is ProjectDetailsError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('جاري تحميل بيانات المشروع...'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSummaryCard(ProjectDetails details) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Text(
                    'دمشق - المزة',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildHeaderMetricTile('المساحة', details.areaText)),
              const SizedBox(width: 12),
              Expanded(child: _buildHeaderMetricTile('الارتفاع', details.heightText)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('إجمالي الإنجاز', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                '${(details.totalCompletionPercentage * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: details.totalCompletionPercentage,
              backgroundColor: const Color(0xFFE2E8F0),
              color: const Color(0xFF006D5B),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMetricTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSpacesView(List<ProjectSpaceEntity> spaces) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: spaces.length,
      itemBuilder: (context, index) {
        final space = spaces[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(space.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(
                    space.statusLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: space.statusLabel == 'مكتمل' ? Colors.green : Colors.orange,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Color(0xFFF1F5F9)),
              ),
              ...space.specifications.entries.map((spec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text('${spec.key}: ', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const Spacer(),
                    Text(
                      spec.value,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkItemsView(List<ProjectPhaseEntity> workItems) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: workItems.length,
      itemBuilder: (context, index) {
        final item = workItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF1F5F9),
                child: Text(
                  '${item.order}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      'الحالة التقديرية: ${item.statusLabel}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '${(item.completionPercent * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006D5B)),
              ),
            ],
          ),
        );
      },
    );
  }
}