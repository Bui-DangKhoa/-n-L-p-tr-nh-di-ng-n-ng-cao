import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  // Load notifications của user
  void loadNotifications(String userId) {
    _notificationService.getUserNotifications(userId).listen((notifications) {
      _notifications = notifications;
      _updateUnreadCount();
      notifyListeners();
    });
  }

  // Cập nhật số lượng chưa đọc
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }

  // Đánh dấu đã đọc
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Đánh dấu tất cả đã đọc
  Future<void> markAllAsRead(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _notificationService.markAllAsRead(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Xóa notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Xóa tất cả notifications
  Future<void> deleteAllNotifications(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _notificationService.deleteAllNotifications(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Gửi notification broadcast (Admin)
  Future<void> sendBroadcastNotification({
    required String title,
    required String body,
    String type = 'system',
    String? imageUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _notificationService.sendBroadcastNotification(
        title: title,
        body: body,
        type: type,
        imageUrl: imageUrl,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
