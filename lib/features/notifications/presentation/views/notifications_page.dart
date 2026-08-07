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
      ),
    );
  }
}
