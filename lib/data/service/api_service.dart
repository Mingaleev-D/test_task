import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task/core/app_constants.dart';
import 'package:test_task/core/utils/shared_utils.dart';
import 'package:test_task/data/model/auth_model.dart';

import '../model/items_model.dart';
import '../model/new_item_model.dart';

class ApiService {
  final dio = Dio();

  Future<AuthModel> loginAuth({
    required String login,
    required String password,
  }) async {
    Map<String, dynamic> body = {'login': login, 'password': password};

    try {
      final response = await dio.post(
        AppConstants.baseUrl + AppConstants.loginEndpoint,
        data: body,
      );
      if (response.statusCode == 200) {
        final result = response.data as Map<String, dynamic>;
        final AuthModel authModel = AuthModel.fromJson(result);
        return authModel;
      } else {
        throw Exception('Ошибка при получении данных из сети');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Ошибка при получении данных');
    }
  }

  Future<List<Result>> getItems({
    int? page = 1,
    int? pageSize = 10,
    String? itemName,
    String? sortOrder,
  }) async {
    var token = await SharedUtils.getToken();
    try {
      final response = await dio.get(
          AppConstants.baseUrl + AppConstants.itemsEndpoint,
          queryParameters: {
            'page': page,
            'pageSize': pageSize,
            'itemName': itemName,
            'sortOrder': sortOrder
          },
          options: Options(headers: {'Authorization': token}));
      if (response.statusCode == 200) {
        final itemResult = response.data['result'] as List<dynamic>;
        final items = itemResult.map((e) => Result.fromJson(e)).toList();
        return items;
      } else {
        throw Exception('Ошибка при получении данных из сети');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Ошибка при получении данных');
    }
  }

  Future<NewItemModel> postCreateNewItem({
    required String name,
    required String measurementUnits,
  }) async {
    var token = await SharedUtils.getToken();
    try {
      final response = await dio.post(
        AppConstants.baseUrl + AppConstants.itemsEndpoint,
        data: {
          'name': name,
          'measurement_units': measurementUnits,
        },
        options: Options(headers: {
          'Authorization': token,
        }),
      );
      if (response.statusCode == 201) {
        final itemResult = response.data as Map<String, dynamic>;
        final items = NewItemModel.fromJson(itemResult);
        return items;
      } else {
        throw Exception('Ошибка при получении данных из сети');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Ошибка при получении данных');
    }
  }
}
