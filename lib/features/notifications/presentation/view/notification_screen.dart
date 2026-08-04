import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extension.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= (maxScroll * 0.9)) {
      final cubit = context.read<NotificationCubit>();
      final state = cubit.state;
      if (state is NotificationLoaded && !state.isPaginating && state.hasMore) {
        cubit.fetchNotifications();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('notifications.title'.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              bool hasUnread = false;
              if (state is NotificationLoaded) {
                hasUnread = state.notifications.any((n) => !n.isRead);
              } else if (state is NotificationError && state.oldData != null) {
                hasUnread = state.oldData!.any((n) => !n.isRead);
              }
              if (!hasUnread) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.done_all),
                tooltip: 'Mark all as read',
                onPressed: () {
                  context.read<NotificationCubit>().markAllAsRead();
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading && state.isFirstFetch) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError && state.oldData == null) {
            return ErrorStateWidget(
              failure: state.failure,
              onRetry: () => context.read<NotificationCubit>().fetchNotifications(),
            );
          } else if (state is NotificationLoaded || (state is NotificationError && state.oldData != null)) {
            final notifications = state is NotificationLoaded
                ? state.notifications
                : (state as NotificationError).oldData!;
            final isPaginating = state is NotificationLoaded ? state.isPaginating : false;

            if (notifications.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.notifications_off_outlined,
                title: 'notifications.empty_title'.tr(),
                subtitle: 'notifications.empty_subtitle'.tr(),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationCubit>().fetchNotifications(refresh: true);
              },
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: notifications.length + (isPaginating ? 1 : 0),
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  if (index >= notifications.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final notif = notifications[index];
                  return GestureDetector(
                    onTap: () {
                      if (!notif.isRead) {
                        context.read<NotificationCubit>().markAsRead(notif.id);
                      }
                    },
                    child: _NotificationCard(notification: notif),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final date = DateTime.tryParse(notification.createdAt);
    
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : (isDark ? Colors.white.withOpacity(0.05) : theme.primaryColor.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.isRead 
                ? (isDark ? Colors.white12 : Colors.grey[200]!) 
                : theme.primaryColor.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: notification.isRead 
                    ? (isDark ? Colors.grey[800] : Colors.grey[100])
                    : theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.isRead ? Icons.notifications_none : Icons.notifications_active,
                color: notification.isRead ? theme.hintColor : theme.primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (date != null) ...[
                        SizedBox(width: 8.w),
                        Text(
                          date.timeAgo(locale: context.locale.languageCode),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    maxLines: notification.isRead ? null : 2,
                    overflow: notification.isRead ? null : TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: notification.isRead ? theme.hintColor : theme.textTheme.bodyMedium?.color,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
