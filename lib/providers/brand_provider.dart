import 'package:flutter/material.dart';
import '../models/brand_model.dart';
import '../services/brand_service.dart';

class BrandProvider with ChangeNotifier {
  final BrandService _brandService = BrandService();
  List<BrandModel> _brands = [];
  bool _isLoading = false;

  List<BrandModel> get brands => _brands;
  bool get isLoading => _isLoading;

  BrandProvider() {
    loadBrands();
  }

  void loadBrands() {
    _isLoading = true;
    notifyListeners();

    _brandService.getBrandsStream().listen((data) {
      _brands = data.where((brand) => brand.isActive).toList();
      _isLoading = false;
      notifyListeners();
    });
  }
}



