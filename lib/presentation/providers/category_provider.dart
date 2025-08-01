import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> _selectedCategories = [];
  bool _isFirstLaunch = true;

  List<String> get selectedCategories => _selectedCategories;
  bool get isFirstLaunch => _isFirstLaunch;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool(AppConstants.isFirstLaunchKey) ?? true;
    _selectedCategories = prefs.getStringList(AppConstants.selectedCategoriesKey) ?? [];
    notifyListeners();
  }

  Future<void> saveSelectedCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCategories = categories;
    _isFirstLaunch = false;
    
    await prefs.setStringList(AppConstants.selectedCategoriesKey, categories);
    await prefs.setBool(AppConstants.isFirstLaunchKey, false);
    notifyListeners();
  }
}