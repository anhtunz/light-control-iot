import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smt_project/feature/login/login_model.dart';
import 'package:smt_project/product/services/api_services.dart';

import '../../product/base/bloc/base_bloc.dart';
import '../../product/cache/locale_manager.dart';
import '../../product/constants/enums/app_route_enums.dart';
import '../../product/constants/enums/locale_keys_enum.dart';
import '../../product/shared/shared_snack_bar.dart';

class LoginBloc extends BlocBase{
  APIServices apiServices = APIServices();
  @override
  void dispose() {
    // TODO: implement dispose
  }

  void checkLogin(BuildContext context) async {
    String token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    int exp = LocaleManager.instance.getIntValue(PreferencesKeys.EXP);
    int timeNow = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (token != "" && (exp - timeNow) > 7200) {
      context.goNamed(AppRoutes.MAIN.name);
    }
  }

  void handleLogin(BuildContext context,String phone, String password) async {
    await apiServices.execute(context, () async {
      LoginModel auth = await apiServices.login(phone, password);
      if(auth.statusCode == 200){
        LocaleManager.instance.setStringValue(PreferencesKeys.TOKEN, auth.token ?? "");
        String userToken = getBaseToken(auth.token!);
        var decode = decodeBase64Token(userToken);
        var data = jsonDecode(decode) as Map<String, dynamic>;
      LocaleManager.instance.setInt(PreferencesKeys.EXP, data['exp']);
      showSuccessTopSnackBarCustom(context, "Đăng nhập thành công");
        context.goNamed(AppRoutes.MAIN.name);
        // log("Decode ${data['exp']}");
      }else{
        showErrorTopSnackBarCustom(context, "Đăng nhập không thành công");
      }
    });
  }


  getBaseToken(String token) {
    List<String> parts = token.split('.');
    String userToken = parts[1];
    return userToken;
  }

  decodeBase64Token(String value) {
    List<int> res = base64.decode(base64.normalize(value));
    return utf8.decode(res);
  }

}