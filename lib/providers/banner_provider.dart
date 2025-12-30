import 'package:flutter/material.dart';
import '../models/banner_model.dart';
import '../services/banner_service.dart';

class BannerProvider with ChangeNotifier {
  final BannerService _bannerService = BannerService();
  List<BannerModel> _banners = [];
  bool _isLoading = false;

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;

  BannerProvider() {
    loadBanners();
  }

  void loadBanners() {
    _isLoading = true;
    notifyListeners();

    _bannerService.getBannersStream().listen((data) {
      _banners = data.where((banner) => banner.isActive).toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      _isLoading = false;
      notifyListeners();
    });
  }
}



