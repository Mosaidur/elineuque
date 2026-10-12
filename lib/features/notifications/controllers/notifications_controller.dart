import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/notification_item_model.dart';

class NotificationsController extends GetxController {
  final isLoading = false.obs;
  final notifications = <NotificationItemModel>[].obs;
  final selectedFilter = 'All'.obs;

  final filterOptions = <String>['All', 'Unread', 'Referrals', 'System'];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationItemModel> get filteredNotifications {
    switch (selectedFilter.value) {
      case 'Unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'Referrals':
        return notifications.where((n) => n.type == 'REFERRAL' || n.type == 'REWARD').toList();
      case 'System':
        return notifications.where((n) => n.type == 'SYSTEM' || n.type == 'CAMPAIGN').toList();
      default:
        return notifications.toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final res = await ApiClient.get(ApiConstants.notifications, withAuth: true);
      if (res.success) {
        final raw = res.data;
        final list = (raw is List
                ? raw
                : (raw is Map ? (raw['data'] as List? ?? raw['notifications'] as List?) : null)) ??
            [];

        if (list.isNotEmpty) {
          final mapped = list
              .map((item) => NotificationItemModel.fromJson(item as Map<String, dynamic>))
              .toList();
          notifications.assignAll(mapped);
        } else {
          _loadSampleNotifications();
        }
      } else {
        _loadSampleNotifications();
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      _loadSampleNotifications();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadSampleNotifications() {
    final now = DateTime.now();
    notifications.assignAll([
      NotificationItemModel(
        id: 'n1',
        title: 'Referral Verified 🎉',
        message: 'Your referral for FitZone Gym was scanned and verified! \$40 has been added to your pending ledger.',
        type: 'REFERRAL',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 25)),
      ),
      NotificationItemModel(
        id: 'n2',
        title: 'New Campaign Alert',
        message: 'Kava Brew launched a new "Summer Cold Brew Drive" with \$25 per conversion. Start sharing your link now!',
        type: 'CAMPAIGN',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      NotificationItemModel(
        id: 'n3',
        title: 'Payout Processed',
        message: 'Your withdrawal request of \$120.00 via Bank Transfer has been approved and disbursed.',
        type: 'PAYOUT',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationItemModel(
        id: 'n4',
        title: 'Welcome to Elinque',
        message: 'Your account is active. Connect with businesses, share referral links, and earn rewards effortlessly.',
        type: 'SYSTEM',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ]);
  }

  Future<void> markAsRead(String id) async {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1 && !notifications[idx].isRead) {
      notifications[idx] = notifications[idx].copyWith(isRead: true);
      try {
        await ApiClient.patch(ApiConstants.markNotificationRead(id), withAuth: true);
      } catch (e) {
        debugPrint('Error marking notification read: $e');
      }
    }
  }

  Future<void> markAllAsRead() async {
    final updated = notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifications.assignAll(updated);

    try {
      await ApiClient.patch(ApiConstants.markAllNotificationsRead, withAuth: true);
      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Marked All as Read',
          'All your notifications are marked as read.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF163E24),
          colorText: const Color(0xFF52E385),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('Error marking all notifications read: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    notifications.removeWhere((n) => n.id == id);
    try {
      await ApiClient.delete('${ApiConstants.notifications}/$id', withAuth: true);
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }
}
