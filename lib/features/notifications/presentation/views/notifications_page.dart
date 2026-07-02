import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/services/get_it_service.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../projects/presentation/cubit/assigned_project_cubit.dart';
import '../../../projects/presentation/views/project_dashboard_page.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import 'widgets/notification_card_widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL layout for Arabic interface
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 100,
          leading: Row(
            children: [
              const SizedBox(width: 16),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.menu, color: Colors.black, size: 24),
                onPressed: () {},
              ),
              const SizedBox(width: 14),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'الإشعارات',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [Color(0xFF006D5B)],
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            if (state is NotificationsLoaded) {
              final notifications = state.notifications;
              final delayWarnings = notifications.where((n) => n.type == 'delay_warning').toList();
              final previousNotifications = notifications.where((n) => n.type != 'delay_warning').toList();

              return RefreshIndicator(
                onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
                color: const Color(0xFF006D5B),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // 1. Render active delay warnings at the top of the feed
                    ...delayWarnings.map((warning) => DelayWarningCard(notification: warning)),

                    const SizedBox(height: 12),

                    // 2. Interactive Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الإشعارات السابقة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<NotificationsCubit>().markAllAsRead();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'تحديد الكل كمقروء',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006D5B),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. Render previous notifications feed
                    if (previousNotifications.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Text(
                            'لا توجد إشعارات سابقة',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ...previousNotifications.map((noti) => StandardNotificationCard(notification: noti)),

                    // 4. Bell Z Watermark Footer
                    const WatermarkFooter(),
                  ],
                ),
              );
            }

            if (state is NotificationsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFEF4444),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<NotificationsCubit>().loadNotifications(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006D5B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('بدء تهيئة الإشعارات...'));
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'الحساب',
                    isActive: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileView(),
                        ),
                      );
                    },
                  ),
                  _buildBottomNavItem(
                    icon: Icons.notifications_rounded,
                    label: 'الإشعارات',
                    isActive: true,
                    onTap: () {},
                  ),
                  _buildBottomNavItem(
                    icon: Icons.assignment_outlined,
                    label: 'المهام',
                    isActive: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'ميزة المهام ستكون متاحة قريباً!',
                            style: TextStyle(fontFamily: 'Tajawal'),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildBottomNavItem(
                    icon: Icons.business_rounded,
                    label: 'المشاريع',
                    isActive: false,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (context) => getIt<AssignedProjectsCubit>()..loadDashboard('الكل'),
                            child: const AssistantDashboardPage(),
                          ),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final activeColor = const Color(0xFF006D5B);
    final inactiveColor = const Color(0xFF94A3B8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
