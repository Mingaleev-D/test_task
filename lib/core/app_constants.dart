import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  /// Texts
  static const String appName = 'Test Task';
  static const String titleName = 'Название';
  static const String unitofmeasurementName = 'Единица измерения';
  static const String codeName = 'Артикул/код';
  static const String descriptionName = 'Описание';

  /// access token
  static const String accessToken = 'accessToken';

  /// Colors
  static Color backgroundColor = const Color(0xffA85757);

  /// url and enpoinds
  static const String baseUrl =
      'https://hcateringback-dev.unitbeandev.com/api/';
  static const String loginEndpoint = 'auth/login';
  static const String itemsEndpoint = 'items';
  // static const String postsEndpoint = 'posts';
  // static const String categoriesEndpoint = 'categories';
  // static const String addTagsEndpoint = 'add-tags';
  // static const String loginEndpoint = 'login';
}
