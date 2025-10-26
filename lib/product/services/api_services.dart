// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:smt_project/feature/login/login_model.dart';
import 'package:smt_project/model/device_entity.dart';
import 'package:smt_project/product/constants/app/api_path_constant.dart';
import '../cache/locale_manager.dart';
import '../constants/enums/locale_keys_enum.dart';
import '../network/network_manager.dart';

class APIServices {
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    "Access-Control-Allow-Credentials": "false",
    "Access-Control-Allow-Headers":
    "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    'Access-Control-Allow-Origin': "*",
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
  };

  Future<T> executeApiCall<T>(Future<dynamic> Function() apiCall,
      {T Function(dynamic)? parser,
        String errorMessage = 'Lỗi khi gọi API',
        T Function(int)? statusCodeHandler}) async {
    try {
      final response = await apiCall().timeout(
        Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Yêu cầu hết thời gian'),
      );

      if (statusCodeHandler != null && response is int) {
        return statusCodeHandler(response);
      }

      if (response is String && response != "") {
        if (parser != null) {
          try {
            return parser(jsonDecode(response));
          } catch (e) {
            throw Exception('Lỗi parsing dữ liệu: $e');
          }
        }
        return response as T;
      } else {
        throw Exception('Dữ liệu trả về rỗng');
      }
    } catch (e, stackTrace) {
      log("Lỗi gọi API $e, $stackTrace");
      throw Exception('$errorMessage: $e');
    }
  }

  Future<T> execute<T>(
      BuildContext context,
      Future<T> Function() apiCall, {
        bool checkMounted = true,
      }) async {
    try {
      return await apiCall();
    } catch (e) {
      if (checkMounted && !context.mounted) {
        return Future.error('Widget not mounted');
      }
      log("Lỗi: $e");
      return Future.error(e);
    }
  }


  Future<LoginModel> login(String phone, String password) async {
    final params = {"phone": phone, "password": password};
    return executeApiCall(
          () => NetworkManager.instance!.getDataFromServerWithParams(
          APIPathConstant.LOGIN_PATH, params),
      parser: (json) => LoginModel.fromJson(json),
      errorMessage: 'Lỗi khi GET /${APIPathConstant.LOGIN_PATH}',
    );
  }

  Future<Device> changeDeviceStatus(String oCode,String oTitle, String value) async {
    final params = {"o_code": oCode, oTitle: value};
    return executeApiCall(
          () => NetworkManager.instance!.createDataInServerWithParams(
          APIPathConstant.UPDATE_LED_PATH, params),
      parser: (json) => Device.fromJson(json),
      errorMessage: 'Lỗi khi POST /${APIPathConstant.UPDATE_LED_PATH}',
    );
  }
  Future<Device> changeFanStatus(String oCode, Map<String,dynamic> params) async {
    return executeApiCall(
          () => NetworkManager.instance!.createDataInServerWithParams(
          APIPathConstant.UPDATE_LED_PATH, params),
      parser: (json) => Device.fromJson(json),
      errorMessage: 'Lỗi khi POST /${APIPathConstant.UPDATE_LED_PATH}',
    );
  }




  // Future<void> logOut(BuildContext context) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(appLocalization(context).log_out_content,
  //             textAlign: TextAlign.center),
  //         actions: [
  //           TextButton(
  //             onPressed: () async {
  //               var url = Uri.http(ApplicationConstants.DOMAIN,
  //                   APIPathConstants.LOGOUT_PATH);
  //               final headers = await NetworkManager.instance!.getHeaders();
  //               final response = await http.post(url, headers: headers);
  //               if (response.statusCode == 200) {
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.UID);
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.TOKEN);
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.EXP);
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.ROLE);
  //                 context.goNamed(AppRoutes.LOGIN.name);
  //               } else {
  //                 showErrorTopSnackBarCustom(
  //                     context, "Error: ${response.statusCode}");
  //               }
  //             },
  //             child: Text(appLocalization(context).log_out,
  //                 style: const TextStyle(color: Colors.red)),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(appLocalization(context).cancel_button_content),
  //           ),
  //         ],
  //       ));
  // }
  //

  Future<String> checkTheme() async {
    String theme = LocaleManager.instance.getStringValue(PreferencesKeys.THEME);
    return theme;
  }

  Future<String> checkLanguage() async {
    String language =
    LocaleManager.instance.getStringValue(PreferencesKeys.LANGUAGE_CODE);
    return language;
  }

}
